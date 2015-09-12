# posh-environment

posh-environment provides a simple configuration-based approach to customizing PowerShell environments.
Customizations are automatically applied when launching PowerShell after one-time installation.

## Installation

posh-environment will automatically create a sample JSON configuration file and add an import for the module in your PowerShell $PROFILE.

1. Launch PowerShell and navigate to posh-environment's root.
2. Run Install.ps1.
3. Reload your shell or call ". $profile" to reload PowerShell with posh-environment.

After installation you can customize your environment by modifying the JSON configuration file.

	PS C:\Repositories\posh-environment> .\install.ps1
	Creating sample config file at "C:\Repositories\posh-environment\bin\machineName.json".
	Adding posh-environment to profile.
	posh-environment successfully installed!
	Please reload your profile for the changes to take effect:
		. $PROFILE
		
## Customizations

posh-environment customizations are simple PowerShell scripts in the customization directory. Customizations can be enabled and configured through the JSON configuration file.

posh-environment comes with a variety of customization scripts:

* CallScripts.ps1
* ImportModules.ps1
* SetAliases.ps1
* SetEnvironmentVariables.ps1
* SetFunctions.ps1
* SetStartPath.ps1
* SetVisualStudio12EnvironmentVariables.ps1

Additional customizations can be defined by providing a path to a script that takes in a settings object deserialized from the settings section in the JSON config. Customizations should return $true when successfully applied and $false with an error message on failure. See existing customizations for examples.

### CallScripts.ps1

Calls scripts provided in settings.

	{
		"Name": "load posh-git",
		"Description": "Calls script to load posh-git.",
		"Enabled": true,
		"Script": "CallScripts.ps1",
		"Settings":
        [
            {
                "Script": "C:\\repositories\\posh-git\\profile.example.ps1"
            }
        ]
	}

### ImportModules

Imports each module provided in settings.

    {
        "Name": "git-status-cache-posh-client module",
        "Description": "Imports git-status-cache-posh-client module.",
        "Enabled": true,
        "Script": "ImportModules.ps1",
        "Settings":
        [
            {
                "Module": "D:\\git-status-cache-posh-client\\GitStatusCachePoshClient.psm1"
            }
        ]
    },
	{
        "Name": "posh-navigation module",
        "Description": "Imports posh-navigation module.",
		"Enabled": true,
		"Script": "ImportModules.ps1",
		"Settings":
        [
            {
                    "Module": "D:\\posh-navigation\\PoshNavigation.psm1",
                    "ArgumentList": "D:\\roaming-settings\\posh-navigation\\settings.json"
            }
        ]
	}
	
### SetAliases.ps1

Registers an alias for each target.

	{
		"Name": "notepad++ alias",
		"Description": "Creates aliases specified in settings.",
		"Enabled": true,
		"Script": "SetAliases.ps1",
		"Settings":
		[
			{
				"Alias": "np",
				"Target": "%ProgramFiles(x86)%\\Notepad++\\notepad++.exe"
			},
			{
				"Alias": "ss",
				"Target": "D:\\path\\to\\someScript.bat"
			}
		]
	}

The below will open "myFile.txt" in notepad++.

    np myFile.txt

### SetFunctions.ps1

Registers a global function for each entry in settings. Useful for replacements that cannot be achieved with PowerShell aliases.

	{
		"Name": "TFS macros",
		"Description": "Creates functions for manipulating TFS shelvesets.",
		"Enabled": false,
		"Script": "SetFunctions.ps1",
		"Settings":
		[
			{
				"Name": "sp",
				"Text": "tf shelve $args"
			},
			{
				"Name": "sd",
				"Text": "tf shelve /noprompt /delete $args"
			},
			{
				"Name": "sa",
				"Text": "tf unshelve /noprompt $args"
			},
			{
				"Name": "slc",
				"Text": "tf shelvesets"
			}
		]
	}

The below will apply shelveset "addNewWalrus" to the current workspace.
	
	sa addNewWalrus
		
### SetEnvironmentVariables.ps1

Sets specified environment variables.

	{
		"Name": "environment variables",
		"Description": "Sets environment variables specified in the settings.",
		"Enabled": true,
		"Script": "SetEnvironmentVariablesInSettings.ps1",
		"Settings":
		[
            {
                "Key": "BOOST_ROOT",
                "Value": "C:\\boost_1_58_0"
            },
			{
				"Key": "PATH",
				"Value": "%PATH%;E:\\path\\to\\my\\scripts"
			}
		]
	}

### SetStartPath.ps1

Sets the start path for new PowerShell instances.

	{
		"Name": "start path",
		"Description": "Sets the starting location for the shell.",
		"Enabled": true,
		"Script": "SetStartPath.ps1",
		"Settings":
		{
			"Path": "E:\\projects\\posh-environment"
		}
	}

### SetVisualStudio12EnvironmentVariables.ps1

Parses VsDevCmd.bat and applies environment variables normally set by the batch script.

	{
		"Name": "vs variables",
		"Description": "Sets Visual Studio 12 environment variables from VsDevCmd.bat.",
		"Enabled": true,
		"Script": "SetVisualStudio12EnvironmentVariables.ps1",
		"Settings":
		{
			"VisualStudioToolsPath": "%VS120COMNTOOLS%"
		}
	}