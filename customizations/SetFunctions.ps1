<#
	.SYNOPSIS 
	  Creates functions specified in settings.
#>

param($config)

foreach ($macro in $config)
{
	if ([String]::IsNullOrEmpty($macro.Name))
	{
		return ($false, "Null or empty Name.")
	}

	if ([String]::IsNullOrEmpty($macro.Text))
	{
		return ($false, "Null or empty Text.")
	}
}

foreach ($macro in $config)
{
	Set-Item -path "function:global:$($macro.Name)" -value $macro.Text
}

return $true