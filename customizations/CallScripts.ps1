<#
	.SYNOPSIS 
	  Calls scripts specified in settings.
#>

param($config)

foreach ($script in $config)
{
	$scriptPath = $script.Script
	if ([String]::IsNullOrEmpty($scriptPath))
	{
		return ($false, "Null or empty script path.")
	}

	$scriptPath = [System.Environment]::ExpandEnvironmentVariables($scriptPath)
	if ([String]::IsNullOrEmpty($scriptPath))
	{
		return ($false, "Null or empty script path.")
	}

	if (-not (Test-Path($scriptPath)))
	{
		return ($false, "Script is not a valid path.")
	}

	if ($script.ArgumentList -eq $null)
	{
		. $scriptPath
	}
	else
	{
		. $scriptPath $script.ArgumentList
	}
}

return $true