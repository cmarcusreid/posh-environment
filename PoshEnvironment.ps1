function Get-BinPath
{
    $scriptDirectory = Split-Path $PSCommandPath -Parent
    return Join-Path $scriptDirectory "bin"
}

function Get-CustomizationsPath
{
    $scriptDirectory = Split-Path $PSCommandPath -Parent
    return Join-Path $scriptDirectory "customizations"
}

function Get-SamplesPath
{
    $scriptDirectory = Split-Path $PSCommandPath -Parent
    return Join-Path $scriptDirectory "samples"
}

function Add-SampleConfiguration
{
    $computerName = $env:COMPUTERNAME.ToLower()
    $configPath = Get-BinPath
    $configFilePath = Join-Path $configPath "$computerName.json"

    if (-not (Test-Path $configFilePath))
    {
        $samplesPath = Get-SamplesPath
        $sampleFilePath = Join-Path $samplesPath "SampleConfig.json"
        Write-Host -ForegroundColor Green "Creating sample config file at ""$configFilePath""."
        New-Item $configFilePath -Force -Type File -ErrorAction Stop | Out-Null
        Copy-Item $sampleFilePath $configFilePath -Force -ErrorAction Stop | Out-Null
    }

    return $configFilePath
}

function Initialize-Customization($customization)
{
    Write-Host -NoNewline "Loading customization: $($customization.Name)... "
    $scriptPath = $customization.Script
    if (-not (Test-Path $scriptPath))
    {
        $customizationsPath = Get-CustomizationsPath
        $scriptPath = Join-Path  $customizationsPath $customization.Script
        if (-not (Test-Path $scriptPath))
        {
            Write-Host -ForegroundColor Red "FAILURE -- Could not find script at ""$scriptPath"""
            return
        }
    }

    $result = . $scriptPath $customization.Settings
    if ($result[0])
    {
        Write-Host -ForegroundColor Green "DONE"
    }
    else
    {
        Write-Host -ForegroundColor Red "FAILURE -- $($result[1])"
    }
}

function Initialize-Profile($configJsonPath)
{
    if ([String]::IsNullOrEmpty($configJsonPath) -or -not (Test-Path($configJsonPath)))
    {
        Write-Error "Initialize-Profile requires path to config json. $configJsonPath is not a valid path."
        return
    }

    Write-Host -NoNewline "Reading JSON configuration... "
    $config = (Get-Content $configJsonPath) -join "`n" | ConvertFrom-Json -ErrorAction Stop
    Write-Host -ForegroundColor Green "DONE"

    foreach ($customization in $config.Customizations | where { $_.Enabled -eq $true })
    {
        Initialize-Customization($customization)
    }

    Write-Host ""
}