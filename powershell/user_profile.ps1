Import-Module oh-my-posh
oh-my-posh --init --shell pwsh --config $env:USERPROFILE\Documents\yt-configs\powershell\yt-prompt.omp.json | Invoke-Expression

# Alias
Set-Alias v nvim
Set-Alias g git
Set-Alias ll ls
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias grep findstr

