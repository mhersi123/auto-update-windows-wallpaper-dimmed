# Define paths
# Line 3 specifies where the current spotlight image is, the other two are where the output files will be placed
$lockscreenPath = "C:\ProgramData\Microsoft\Windows\SystemData\S-1-5-21-2447181992-457899513-1054615145-1001\ReadOnly\LockScreen_O"
$outputPath = "$env:USERPROFILE\Pictures\Spotlight_Wallpaper.jpg"
$dimmedPath = "$env:USERPROFILE\Pictures\Spotlight_Dimmed.jpg"

# Ensure the directory exists
if (-Not (Test-Path $lockscreenPath)) {
    Write-Host "LockScreen directory not found."
    Exit
}

# Get the latest lock screen image (largest file assuming it's the highest resolution)
$latestFile = Get-ChildItem $lockscreenPath | Sort-Object Length -Descending | Select-Object -First 1

# Copy and rename it to .jpg
if ($latestFile) {
    Copy-Item $latestFile.FullName $outputPath -Force
}

# Apply dim effect using ImageMagick (-modulate 70 reduces brightness to 70%)
$imagemagickPath = "magick"  # Assumes ImageMagick is in PATH
Invoke-Expression "$imagemagickPath `"$outputPath`" -modulate 35 `"$dimmedPath`""

# Set as wallpaper
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $dimmedPath, 3)

