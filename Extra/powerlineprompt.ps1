Import-Module PowerLine

$title = {"$(if ($IsAdmin){"Admin " })BoreShell - $pwd"}

Set-PowerLinePrompt -PowerLineFont -Title $title -FullColor -SetCurrentDirectory -RestoreVirtualTerminal -Colors "#C0C0C0", "#303030" -Prompt @(
	{$MyInvocation.HistoryId}
	{Get-SegmentedPath -SegmentLimit 7}
	{"`t"}
	{Get-Elapsed}
	{Get-Date -f "T"}
	{"`n"}
	{"PS "}
)

Set-PSReadLineOption -PromptText "`e[38;2;48;48;48m"

