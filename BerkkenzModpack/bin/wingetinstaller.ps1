# Check if winget is already installed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    # Define the URL for the Microsoft store appx package
    $wingetAppxUrl = "https://winget.azureedge.net/cache/microsoft.winget.cli.appxbundle"

    # Define the path to download the appx package
    $downloadPath = "$env:TEMP\winget.appxbundle"

    # Download the appx package
    Invoke-WebRequest -Uri $wingetAppxUrl -OutFile $downloadPath

    # Install the appx package silently
    Add-AppxPackage -Path $downloadPath -Verbose -Quiet

    # Clean up the downloaded appx package
    Remove-Item -Path $downloadPath -Force
} else {
    Write-Output "Windows Package Manager (winget) is already installed."
}