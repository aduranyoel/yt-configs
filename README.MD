### Ingredients
- Install Powershell 7 from microsoft store
- Install-Module oh-my-posh -Scope CurrentUser -Force
- Install-Module posh-git -Scope CurrentUser -Force
- Install-Module -Name Terminal-Icons -Repository PSGallery -Force
- Install-Module -Name z
<!--- Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck-->
- install chocolatey (https://chocolatey.org/install)
- choco install gsudo
- choco install fzf
- Install-Module -Name PSFzf -Scope CurrentUser -Force
- load user_profile.ps1 (. <url>)
- choco install neovim
- install vim-plug (https://github.com/junegunn/vim-plug)
- insrtall ripgrep (https://github.com/BurntSushi/ripgrep)
- create symbolic link to vim config (gsudo New-Item -ItemType SymbolicLink -Path C:\Users\[User]\AppData\Local\nvim -Target [absolute-nvim-config-path])
- :PlugInstall
