# hongzio/homebrew-tap

Homebrew formulae for my own tools.

```sh
brew trust hongzio/tap   # Homebrew 7 refuses to load untrusted third-party taps
brew tap hongzio/tap
```

`brew trust` has to come first. Tapping an untrusted tap fails with
"Cannot tap: invalid syntax in tap!", which says nothing about trust.

The repository is named `homebrew-tap` because `brew tap hongzio/tap` expands to
`https://github.com/hongzio/homebrew-tap`. A repository named anything else is a
*custom remote* tap, which can only be trusted by full URL.

## Formulae

| formula | what it is |
|---|---|
| [`imswitch`](https://github.com/hongzio/imswitch) | Forces the macOS input source from Neovim — locally, over SSH, or from a container |

```sh
brew install --HEAD imswitch
brew services start imswitch
```

## Casks

| cask | what it is |
|---|---|
| [`kbd`](https://github.com/hongzio/kbd) | Korean input method for developers — instant Hangul/roman toggle, shortcuts pass through as ABC keys, socket IPC |

```sh
brew install --cask kbd
```

Then add kbd in System Settings → Keyboard → Input Sources (log out and back in if it isn't listed).
