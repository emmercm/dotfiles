# dotpack

A pack of OS, language, and tool-specific dotfiles. This directory will be symlinked to `$HOME` in its entirety.

## Naming

A numerical order has been established so that [`.everythingrc`](../.everythingrc) can source files in order:

- `.10_*.sh`: OS-specific files, to be handled before anything else
- `.20_*.sh`: programming language-specific files, to be handled before any tools
- `.30_*.sh`: tool/application-specific files
- `.90_*.sh`: terminal configuration/styling
