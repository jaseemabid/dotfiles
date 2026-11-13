# Copy URL

Firefox extension with two shortcuts:

- ⌘Y: Copy URL
- ⌘⇧Y: Copy as Markdown link

## Setup

1. Disable the existing keybinding

   `about:keyboard` > History > "Show all history" → unset

2. Load the extension

   `about:debugging#/runtime/this-firefox` > Load Temporary Add-on… > `manifest.json`

Temporary add-ons are removed when Firefox restarts.
