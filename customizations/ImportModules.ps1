<#
	.SYNOPSIS 
	  Loads modules specified in settings.
#>

param($config)

foreach ($module in $config)
{
	$modulePath = $module.Module
	if ([String]::IsNullOrEmpty($modulePath))
	{
		return ($false, "Null or empty module path.")
	}

	$modulePath = [System.Environment]::ExpandEnvironmentVariables($modulePath)
	if ([String]::IsNullOrEmpty($modulePath))
	{
		return ($false, "Null or empty module path.")
	}

	if (-not (Test-Path($modulePath)))
	{
		return ($false, "Module path is not a valid path.")
	}

	if ($module.ArgumentList -eq $null)
	{
		Import-Module -Global $modulePath
	}
	else
	{
		Import-Module -Global $modulePath -ArgumentList $module.ArgumentList
	}
}

return $true