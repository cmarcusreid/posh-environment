param($configJsonPath)

if (Get-Module PoshEnvironment) { return }

if (-not (Get-Module Microsoft.Powershell.Utility))
{
	Import-Module Microsoft.Powershell.Utility
}

Push-Location $psScriptRoot
. .\PoshEnvironment.ps1
Pop-Location

Export-ModuleMember -Function @('Add-SampleConfiguration')
Export-ModuleMember -Function @('Initialize-Profile')

if (-not ([String]::IsNullOrEmpty($configJsonPath)) -and (Test-Path $configJsonPath))
{
	Initialize-Profile $configJsonPath
}