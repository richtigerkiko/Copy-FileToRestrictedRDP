<#
.SYNOPSIS
Lets you Copy Files via Base64String. Sourcepath will be C:\Temp\RestritedCopy_*ORIGINALFILENAME*

.DESCRIPTION
This Script Converts a File to a Base64 String and generates a powershell command to let you copy it via RDP to another Source PC

.PARAMETER Path
Absolute Filepath

.EXAMPLE
Copy-FileToRestrictedRDP C:\temp\certs.zip

.NOTES
General notes
#>
function Copy-FileToRestrictedRDP {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript( {
                if ( -Not ($_ | Test-Path) ) {
                    throw "File or folder does not exist"
                
                    if ((Get-Item $_).Length / 1mb -gt 64 ) {
                        throw "File to big, must be smaller than 64mb"
                    }
                }
                return $true
            })]
        [System.IO.FileInfo]$Path
    )
    
    process {
        # Get base64 String of file
        $base64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($Path))

        # Get command to copy in destination powershell
        $generatedCommand = "[IO.File]::WriteAllBytes(`"C:\temp\RestritedCopy_$($(Get-Item $Path).Name)`", [Convert]::FromBase64String(`"$base64`"))"

        $generatedCommand | Set-Clipboard
    }

    end {
        Write-Output "Generated Command: `n `n"
        Write-Host $generatedCommand
        Write-Output "`n`n its already copied to Clipboard!"
    }
}
