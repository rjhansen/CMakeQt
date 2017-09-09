# To use: adjust these six variables appropriately.  $EXECUTABLES
# is a comma-separated list of the executable names.

$SIGNTOOL="C:\Program Files (x86)\Microsoft SDKs\ClickOnce\SignTool\signtool.exe"
$WIXDIR="C:\Program Files (x86)\WiX Toolset v3.11\bin"
$WINDEPLOY="C:\Qt\Qt5.9.1\5.9.1\msvc2017_64\bin\windeployqt.exe"
$PROJECT_NAME="CMakeQt"
$VERSION="1.0"
$EXECUTABLES="CMakeQt.exe"

Remove-Item * -Include *.msi -Force -ErrorAction ignore
Push-Location src
Remove-Item -Recurse -Force -ErrorAction ignore package
New-Item -Path .\package -ItemType Directory
foreach ($exe in $EXECUTABLES) {
    & $SIGNTOOL sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a $exe
    Copy-Item -Path .\$exe -Destination package\$exe
}
Copy-Item -Path ..\license.rtf -Destination .\package\license.rtf
& $WINDEPLOY -release package
Push-Location .\package
foreach ($exe in $EXECUTABLES) {
    Remove-Item -Force $exe
}
Pop-Location

& $WIXDIR\heat.exe dir package -o package.wxs -scom -frag -srd -sreg -gg -cg $($PROJECT_NAME + "GroupId") -dr BIN_DIR_REF
& $WIXDIR\candle.exe -arch x64 $($PROJECT_NAME + ".wxs") package.wxs
& $WIXDIR\light.exe -ext WixUIExtension.dll -b package -o $($PROJECT_NAME + " " + $VERSION + ".msi") .\$($PROJECT_NAME + ".wixobj") .\package.wixobj
& $SIGNTOOL sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a $($PROJECT_NAME + " " + $VERSION + ".msi")

Move-Item -Path $($PROJECT_NAME + " " + $VERSION + ".msi") ..
Remove-Item package -Recurse -ErrorAction ignore -Force
Remove-Item * -Include *.wixobj -Force -ErrorAction ignore
Remove-Item * -Include *.wixpdb -Force -ErrorAction ignore
Remove-Item -Path package.wxs -Force -ErrorAction ignore
Pop-Location