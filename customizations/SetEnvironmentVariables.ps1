<#
	.SYNOPSIS 
	  Sets environment variables specified in settings.
#>

param($config)

foreach ($environmentVariable in $config)
{
	if ([String]::IsNullOrEmpty($environmentVariable.Key))
	{
		return ($false, "Null or empty key.")
	}

	if ([String]::IsNullOrEmpty($environmentVariable.Value))
	{
		return ($false, "Null or empty value.")
	}

	[System.Environment]::SetEnvironmentVariable($environmentVariable.Key, [System.Environment]::ExpandEnvironmentVariables($environmentVariable.Value))
} 

return $true