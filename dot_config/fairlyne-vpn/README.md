# fairlyne-vpn : split tunneling par domaine

Quand le VPN Fairlyne est connecté (clic dans le tray, comme avant), **seul le trafic vers les
domaines de `domains.txt`** passe par le tunnel. Tout le reste reste sur la connexion normale.
VPN déconnecté, ces mêmes domaines partent en direct, avec l'IP normale.

## Mise en place sur une machine

`connection.conf` contient les infos propres à la connexion (UUID NetworkManager, port du
serveur VPN). **Il n'est pas commité** : le créer depuis `connection.conf.example`.
Dans chezmoi, il est exclu par `.config/fairlyne-vpn/connection.conf` dans `.chezmoiignore`.

## Usage

| Je veux… | Je fais… |
|---|---|
| Activer le dispositif | `sudo ~/.config/fairlyne-vpn/install` |
| Ajouter un domaine | une ligne dans `domains.txt`, puis `sudo ~/.config/fairlyne-vpn/install` |
| Modifier la logique | éditer `split.sh`, puis `sudo ~/.config/fairlyne-vpn/install` |
| Tout retirer | `sudo ~/.config/fairlyne-vpn/uninstall` |

`install` reconstruit la table nftables et, si le VPN est connecté en mode split, réapplique
ses règles : pas besoin de reconnecter. Il indique quand une reconnexion est nécessaire : premier
passage du mode « tout dans le tunnel » au mode split, ou changement de `domains.txt` (pour le
DNS). Après `uninstall`, reconnecter le VPN s'il était connecté.

## Ce que `install` pose hors de ce dossier

- `/etc/NetworkManager/conf.d/fairlyne-vpn.conf` : `dns=dnsmasq`, NetworkManager lance un
  dnsmasq local (relaie vers les mêmes serveurs DNS qu'avant).
- `/etc/NetworkManager/dnsmasq.d/fairlyne-vpn.conf` : généré depuis `domains.txt`.
- `/etc/NetworkManager/fairlyne-vpn.connection` : généré depuis `connection.conf` (appartient à
  root, lu par le script dispatcher).
- `/etc/NetworkManager/dispatcher.d/50-fairlyne-vpn` : copie de `split.sh` (doit appartenir à
  root : NetworkManager l'exécute en root et refuse un script modifiable par un utilisateur).
- Connexion VPN : `ipv4.never-default` et `ipv6.never-default` à `yes`, et `ipv4.dns-search`
  remplacé par les domaines de `domains.txt` préfixés de `~` (domaines de routage DNS).
- Au runtime : table nftables `inet fairlyne_vpn`, règle `ip rule fwmark 0x1951 lookup 1951`.

## Fonctionnement

1. dnsmasq ajoute chaque IP résolue pour un domaine listé dans les sets nftables `dst4`/`dst6`.
2. nftables marque les paquets vers ces IP ; la règle `ip rule` les envoie vers la table 1951.
3. VPN connecté : la table 1951 contient `default dev tun0`, et le trafic marqué sortant par
   `tun0` (et lui seul) est masqueradé. VPN déconnecté : la table est vide, et le noyau retombe
   sur le routage normal.
4. Le VPN est IPv4 seulement : pendant qu'il est connecté, l'IPv6 vers ces domaines est refusé
   pour que les clients se rabattent sur IPv4 au lieu de contourner le tunnel.
5. DNS : VPN connecté, si le serveur VPN pousse des serveurs DNS, dnsmasq leur envoie les
   requêtes pour les domaines listés (et seulement celles-là). Un serveur DNS privé (10.x,
   172.16-31.x, 192.168.x) est joint par le tunnel ; un public (aujourd'hui 1.1.1.1 et 1.0.0.1)
   est joint en direct, pour ne pas faire passer tout le trafic vers lui dans le tunnel.
   Sans DNS poussé, ou VPN déconnecté, le DNS normal répond.

## Vérifier

```sh
curl -4 ifconfig.me                       # IP normale, VPN connecté ou non
ip route get "$(dig +short A <service>.fairlyne.com | tail -1)" mark 0x1951   # dev tun0 si VPN connecté
sudo nft list table inet fairlyne_vpn     # IP collectées, règles actives
journalctl -t fairlyne-vpn                # VPN up / down, DNS poussés par le VPN
```

## Limites connues

- **DNS sécurisé (DoH) du navigateur** : il contourne dnsmasq, donc rien n'est routé. Le désactiver
  (Firefox : « DNS via HTTPS » ; Chrome : « Utiliser un DNS sécurisé »).
- **Basculement** : à la connexion du VPN, les connexions déjà ouvertes restent en direct ; un
  rechargement suffit (les caches DNS des applis expirent en ~1 min).
- **IP partagées CloudFront** : une IP d'edge sert aussi d'autres sites ; pendant que le VPN est
  connecté, un site perso servi par la même IP passe aussi par le tunnel. Les sets sont vidés à
  chaque connexion du VPN.
- **Docker** : les conteneurs sur un réseau utilisateur (compose) sont couverts. Ceux du bridge
  par défaut utilisent un DNS public quand l'hôte est en `127.0.0.1` : leurs résolutions ne
  remplissent pas les sets.
- **Le serveur VPN** est lui-même sous un domaine listé : son port (`VPN_SERVER_PORT`) est exclu
  du marquage pour éviter une boucle.
- **`ipv4.dns-search`** de la connexion VPN appartient à ce dispositif : une valeur posée à la
  main est écrasée par `install` et vidée par `uninstall`.
