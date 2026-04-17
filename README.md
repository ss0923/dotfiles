macOS development environment

This repo is a **generated artifact** — a public rendering of my private chezmoi source tree. Don't edit files under `personal/` or `work/` directly; they're overwritten on every render.

<br/>

#### Layout

```
personal/   everything my personal Mac gets (.personal=true)
work/       everything my Manifest work Mac gets (.personal=false)
scripts/    the render script
```

The two subtrees show how the same templates render for each machine — e.g., different AeroSpace workspaces, different Brewfile casks, different tool installs.

<br/>

#### Updating

The source of truth is my private `chezmoi` repo. To refresh this public mirror from either Mac:

```sh
~/dev/other/dotfiles/scripts/render.sh
```

Then review the diff and commit.

<br/>

#### Licensing

Code is licensed under [MIT](./LICENSE).
