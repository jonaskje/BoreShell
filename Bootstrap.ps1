
# iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/jonaskje/BoreShell/master/Bootstrap.ps1')

function InstallScoop() {
	if (Test-Path "$env:USERPROFILE\scoop\apps\scoop") {
		scoop update
	} else {
		Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')
	}

	# Must have git in order to add buckets and clone the rest of the boreshell project
	scoop install git-with-openssh
}

$BoreHome = "$env:USERPROFILE\BoreShell"
if (Test-Path $BoreHome) {
	Write-Warning "Skipping Boreshell install because $BoreHome already exists"
} else {
	InstallScoop
	git clone https://github.com/jonaskje/BoreShell $BoreHome
	cd $BoreHome
	& "$BoreHome\Build.ps1"
}

