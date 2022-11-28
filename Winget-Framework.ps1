<#
Auther
    Matthew Maher
Date
    10/11/2022
Purpose
    Install and Uninstall Fuctions for Winget Packages for Intune
Version
     1.2 - Added Uninstallation Function
#>


[CmdletBinding()]
Param (
    [Parameter(mandatory,ValueFromPipelineByPropertyName)][string] $WingetPackageExactID,
    [Parameter(ValueFromPipelineByPropertyName)][switch] $Uninstall
)

begin {
    ### Log Start
    $ScriptName = "WingetPackageDeployment.ps1"
    Start-Transcript -Path "C:\OSInst\Transcripts\$ScriptName.log" -Append

    ### Functions
    function Get-WingetPath {
        ### Find Winget Path & Change to it
        $ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
        if ($ResolveWingetPath){
            $WingetPath = $ResolveWingetPath[-1].Path
        }
        $wingetexe = "$ResolveWingetPath\winget.exe"
        if (Test-path $wingetexe) { Write-Output "Found Winget"}
        Set-Location $wingetpath
    }

    function Install-WingetPackage {
        [CmdletBinding()]
        Param (
            [Parameter(Position=0,mandatory=$true)][string] $WingetPackageExactID
        )
        ### Change Directory to Winget
        Get-WingetPath
        ### Install
        .\winget.exe install --id=$WingetPackageExactID --silent --exact --source winget --accept-package-agreements --accept-source-agreements
    }

    function Uninstall-WingetPackage {
        [CmdletBinding()]
        Param (
            [Parameter(Position=0,mandatory=$true)][string] $WingetPackageExactID
        )
        ### Change Directory to Winget
        Get-WingetPath
        ### Uninstall
        .\winget.exe uninstall --id=$WingetPackageExactID --silent --exact --source winget --accept-source-agreements
    }
}
process {
    if ($Uninstall){
        Uninstall-WingetPackage -WingetPackageExactID $WingetPackageExactID
    }
    else {
        Install-WingetPackage -WingetPackageExactID $WingetPackageExactID
    }
}
end {
    ### Log End
    Stop-Transcript
}
