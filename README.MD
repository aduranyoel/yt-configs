## Ingredients
- install chocolatey (https://chocolatey.org/install)
- `choco install gsudo`
- Install Powershell 7 from microsoft store(optional)

### Oh-My-Posh (https://ohmyposh.dev/docs/installation/windows)
- `winget install JanDeDobbeleer.OhMyPosh -s winget`
```
Install-Module posh-git -Scope CurrentUser -Force
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
Install-Module -Name z
```

### PSReadLine (https://github.com/PowerShell/PSReadLine)
```
Install-Module -Name PowerShellGet -Force
Install-Module PSReadLine
```
- `choco install fzf`
- `Install-Module -Name PSFzf -Scope CurrentUser -Force`

### Load user_profile.ps1
- set config in `$PROFILE`

```echo '. $env:USERPROFILE\Documents\yt-configs\powershell\user_profile.ps1' > $PROFILE```
- `choco install neovim`

### Install vim-plug (https://github.com/junegunn/vim-plug)
#### create symbolic link to vim config
```gsudo New-Item -ItemType SymbolicLink -Path C:\Users\[User]\AppData\Local\nvim -Target [absolute-nvim-config-PATH]```

### Install ripgrep (https://github.com/BurntSushi/ripgrep)
- `choco install ripgrep`

### PlugInstall
```
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force
```
- In `nvim` run `:PlugInstall`

### Coc plugins
- In `nvim` run:

```:CocInstall coc-html coc-css coc-tsserver coc-json coc-angular coc-tslint-plugin coc-snippets``` 

#### Coc marketplace
```:CocInstall coc-marketplace```
- use `:CocList marketplace` to install extensions
