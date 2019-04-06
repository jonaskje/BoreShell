
param(
	[string] $RootDir = $pwd.providerPath
)

$PSVersion = "6.2.0"
$PsGalleryModules = "PowerLine", "PSEverything", "ClipboardText", "WindowsCompatibility", "Ships", "ThreadJob", "ImportExcel", "posh-git", "vim"
$BoreShellDir = "$RootDir\BoreShell"
$PsUri = "https://github.com/PowerShell/PowerShell/releases/download/v$PSVersion/PowerShell-$PSVersion-win-x64.zip"

if (Test-Path ($BoreShellDir)){
	Remove-Item $BoreShellDir -Recurse -Force
}

mkdir $BoreShellDir\Modules | out-null

$localZip = "$RootDir\packages\$PSVersion-win-x64.zip"
if (!(Test-Path $localZip)){
	mkdir (split-path $localZip) -ea:0
	Write-Progress -activity "Publish BoreShell" -Status "Download powershell" -CurrentOperation $PsUri -PercentComplete 0 -Id 1
	Invoke-WebRequest -Uri $PsUri -OutFile $localZip
}

Write-Progress -activity "Publish BoreShell" -Status "Expanding powershell" -CurrentOperation $localZip -PercentComplete 25 -Id 1
Expand-Archive -Path $localZip -DestinationPath $BoreShellDir

Write-Progress -activity "Publish BoreShell" -Status "Fetching modules" -CurrentOperation "$PsGalleryModules" -PercentComplete 50 -Id 1
Save-Module -Repository PSGallery -Name $PsGalleryModules -LiteralPath $BoreShellDir\Modules

Copy-Item $PSScriptRoot\Extra\* -Recurse -Destination $BoreShellDir\

Move-Item $BoreShellDir\pwsh.exe $BoreShellDir\BoreShell.exe


