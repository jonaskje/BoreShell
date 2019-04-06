Set-Variable -Name BoreShell -Value $true -Scope Global -Option Readonly

# make BoreShell first in module path

&{
	$userPowerShell = split-path $PROFILE.CurrentUserAllHosts
	$env:psmodulepath = "$pshome\modules;$userPowerShell\modules;C:\Program Files\PowerShell\Modules"

	$currentUserBoreShellScripts = "$userPowerShell\BoreShellScripts"
	if (-not (Test-Path $currentUserBoreShellScripts)) {
		mkdir $currentUserBoreShellScripts | out-null
	}
	if ($env:Path -notlike "*$currentUserBoreShellScripts*") {
		$env:Path += ";$currentUserBoreShellScripts"
	}
	if (-not (Test-Path $userPowerShell\boreshell_profile.ps1)) {
		Set-Content -LiteralPath $userPowerShell\boreshell_profile.ps1 -Value ""
	}
	$profile.psobject.Properties.Add([System.Management.Automation.PSNoteProperty]::new("CurrentUserBoreShell", "$userPowerShell\boreshell_profile.ps1"))
}

foreach ($dir in "D:\", "C:\") {
	if (Test-Path -PathType Container -LiteralPath $dir) {
		Set-Location -LiteralPath $dir
		break
	}
}

Set-Alias gvim "$env:USERPROFILE\scoop\shims\gvim.exe"

Import-Module posh-git
Import-Module vim

. $PSScriptRoot\powerlineprompt.ps1

Set-PSReadLineOption -ShowToolTips

function Test-IsAdmin{
	$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
	$principal = [Security.Principal.WindowsPrincipal]::new($identity)
	return $principal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator )
}

Set-Variable -Name IsAdmin -Value (Test-ISAdmin) -Scope Global -Option ReadOnly

. $profile.CurrentUserBoreShell

