<#
	.SYNOPSIS 
	  Sets the starting location for the shell.
#>

param($config)

$startPath = [System.Environment]::ExpandEnvironmentVariables($config.Path)
if ([String]::IsNullOrEmpty($startPath))
{
	return ($false, "Null or empty Path.")
}

if (-not (Test-Path($startPath)))
{
	return ($false, "Invalid Path.")
}

cd $startPath

return $true