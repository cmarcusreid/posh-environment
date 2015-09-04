<#
	.SYNOPSIS 
	  Sets Visual Studio 12 environment variables from VsDevCmd.bat.
#>

param($config)

$visualStudioToolsPath = [System.Environment]::ExpandEnvironmentVariables($config.VisualStudioToolsPath)
if ([String]::IsNullOrEmpty($visualStudioToolsPath))
{
	return ($false, "Null or empty VisualStudioToolsPath.")
}

if (-not (Test-Path($visualStudioToolsPath)))
{
	return ($false, "Invalid VisualStudioToolsPath.")
}

# Based on http://stackoverflow.com/questions/2124753/how-i-can-use-powershell-with-the-visual-studio-command-prompt
pushd "$visualStudioToolsPath"
cmd /c "VsDevCmd.bat&set" | foreach {
	if ($_ -match "=")
	{
		$v = $_.split("=");
		Set-Item -force -path "ENV:\$($v[0])" -value "$($v[1])"
	}
}
popd

return $true