# General instructions

## Code style

</THIS IS VERY IMPORTANT>
Whatever the language is, *NEVER OVER COMMENT CODE*. Clear variable and functions names should be enough to understand code intent in 99% cases. Keep comments for rare cases where either:
- The algorithmic logic is especially tricky
- The implementation is surprising, for instance when we're implementing a workaround instead of doing something proper

If we're not in one of those cases, a private function, or whatever resource the language can offer, with a proper name, will be better than a comment.
</THIS IS VERY IMPORTANT>

In object oriented languages, we hate to see constructors with too many arguments, it's not readable. 3 is ok; 4 is a lot and should be the absolute maximum when doing it another way is not convenient. Beyond that number, we absolutely want a builder pattern or something similar to keep things readable (typically in Java, Lombok is perfect to easily implement builders).

# Workflow

As a general rule of thumb, you can run test suites yourself to validate a code change didn't produce any regression, and run the app locally when appropriate.

Unless explicitly asked, don't implement tests yourself.

Never add a dependency or library to the project by yourself, always ask for permission first. Whenever suggesting a library, also suggest me alternatives. Any library you suggest should be *open source*, *popular* and *currently maintained*. Give me a short summary of all libraries you suggest (number of stars, last commit date, approximative release frequency, github repo link).
