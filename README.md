Run the command below in Powershell to set everything up. The salt in the query string is just for preventing webclient to return a cached version of the Bootstrap.ps1 file.

`iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/jonaskje/BoreShell/master/Bootstrap.ps1?salt=$([DateTime]::Now.Ticks)')`
