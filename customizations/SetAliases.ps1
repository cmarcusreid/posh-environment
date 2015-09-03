<#
	.SYNOPSIS 
	  Creates aliases specified in settings.
#>

param($config)

foreach ($invocationShortcut in $config)
{
	if ([String]::IsNullOrEmpty($invocationShortcut.Alias))
	{
		return ($false, "Null or empty alias.")
	}

	$target = [System.Environment]::ExpandEnvironmentVariables($invocationShortcut.Value)
	if ([String]::IsNullOrEmpty($target))
	{
		return ($false, "Null or empty value.")
	}
}

foreach ($invocationShortcut in $config)
{
	$value = [System.Environment]::ExpandEnvironmentVariables($invocationShortcut.Value)
	Set-Alias -Name $invocationShortcut.Alias -Value $value -Scope "Global"
}

return $true