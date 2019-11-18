[string]$RootDir = $PSScriptRoot
[DateTime]$TimeStamp = (Get-ChildItem "$RootDir\Build.ps1").LastWriteTime
[string]$BoreShellDir = "$RootDir\BoreShell"
[string]$BoreShellExe = "$BoreShellDir\BoreShell.exe"

function InstallScoopApplications() {
    scoop bucket add shelmangroup https://github.com/shelmangroup/scoops
    scoop bucket add extras
    scoop install oidc-agent
    scoop install extras/vcredist2015
    scoop install extras/vcredist2017
    scoop install extras/vcredist2019
    scoop install everything
    #scoop install neovim 
    scoop install totalcommander
    #scoop install alacritty
    scoop update *
}

function BuildBoreShell() {
    $PSVersion = "7.0.0-preview.5"
    $PsGalleryModules = "PowerLine", "PSEverything", "ClipboardText", "WindowsCompatibility", "Ships", "ThreadJob", "ImportExcel", "posh-git", "vim"
    $PsUri = "https://github.com/PowerShell/PowerShell/releases/download/v$PSVersion/PowerShell-$PSVersion-win-x64.zip"

    if (Test-Path ($BoreShellExe)) {
        $BoreShellTimeStamp = (Get-ChildItem $BoreShellExe).LastWriteTime
        if ($BoreShellTimeStamp -ge $TimeStamp) {
            Write-Host "Skipping BoreShell build because no changes were detected"
            return
        }
    }

    if (Test-Path ($BoreShellDir)) {
        Remove-Item $BoreShellDir -Recurse -Force
    }

    mkdir $BoreShellDir\Modules | out-null

    $localZip = "$RootDir\packages\$PSVersion-win-x64.zip"
    if (!(Test-Path $localZip)) {
        mkdir (split-path $localZip) -ea:0
        Write-Progress -activity "Publish BoreShell" -Status "Download powershell" -CurrentOperation $PsUri -PercentComplete 0 -Id 1
        Invoke-WebRequest -Uri $PsUri -OutFile $localZip
    }

    Write-Progress -activity "Publish BoreShell" -Status "Expanding powershell" -CurrentOperation $localZip -PercentComplete 25 -Id 1
    Expand-Archive -Path $localZip -DestinationPath $BoreShellDir

    Write-Progress -activity "Publish BoreShell" -Status "Fetching modules" -CurrentOperation "$PsGalleryModules" -PercentComplete 50 -Id 1
    Save-Module -Repository PSGallery -Name $PsGalleryModules -LiteralPath $BoreShellDir\Modules

    Copy-Item $PSScriptRoot\Extra\* -Recurse -Destination $BoreShellDir\

    Move-Item $BoreShellDir\pwsh.exe $BoreShellExe
    (Get-ChildItem $BoreShellExe).LastWriteTime = Get-Date
}

& "$RootDir\Add-Font.ps1" -path "$RootDir\Extra\Fonts\"
InstallScoopApplications
BuildBoreShell

# mkdir "$env:APPDATA\alacritty" -ErrorAction SilentlyContinue
# (get-content "$RootDir\appdata\alacritty\alacritty.yml") -Replace "@@@BORESHELL@@@",$BoreShellExe | Out-File -Force -Encoding ascii -FilePath "$env:APPDATA\alacritty\alacritty.yml"

cp -Force "$RootDir\scoop\persist\totalcommander\wincmd.ini" "$env:USERPROFILE\scoop\persist\totalcommander\wincmd.ini"

# http://karuppuswamy.com/wordpress/2014/08/13/how-to-use-robocopy-in-windows-for-backup-and-sync-like-rsync-in-linux/
# ROBOCOPY "$RootDir\.config" "$env:HOME\.config" /DCOPY:DA /MIR /FFT /Z /XA:SH /R:0 /TEE /XJD 

