Import-Module oh-my-posh
oh-my-posh --init --shell pwsh --config $env:USERPROFILE\Documents\yt-configs\powershell\yt-prompt.omp.json | Invoke-Expression

# PSReadLine
#Set-PSReadLineOption -EditMode Emacs
#Set-PSReadLineOption -BellStyle None
#Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
#Set-PSReadLineOption -PredictionSource History

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Git
Import-Module posh-git

# Icons
Import-Module Terminal-Icons

# Alias
Set-Alias v nvim
Set-Alias ll ls
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias grep findstr
Set-Alias .. cd..

