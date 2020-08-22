# Code Skeleton for CMake/Qt Apps

This is a simple do-nothing application that comes with build scripts to create properly
codesigned packages for Windows.  If you wish to use this as a basis for your own package,
follow this process:

## Prerequisites
* [Python 3.8 or later](https://www.python.org)
* [CMake](https://www.cmake.org)
* [Qt](https://www.qt.io/download)
* [Microsoft Visual Studio 2019](https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=Community&rel=16)
* Add an environment variable, `Qt5_DIR`, set to the location of `FindQt5Config.cmake`
* Make sure that from a command line you can execute the following applications without specifying a full path:
  * `windeployqt.exe`
  * `cmake.exe`
  * `signtool.exe` (note: you'll need a code signing certificate)
  * `heat.exe`
  * `candle.exe`
  * `light.exe`
  * `python.exe`
  * `cl.exe` (64-bit for Qt 64-bit, 32-bit for Qt 32-bit)

## Instructions
1. In `CMakeLists.txt`:
    * Set the project name and version properly
    * Add any Qt5 modules you require
    * Set the source code properly (including `.ui` files)
2. Edit `template.wxs.in` and change the upgrade code to a unique UUID that will be constant over all versions of your product
3. Create the build infrastructure.
    * `mkdir build`
    * `cd build`
    * `cmake .. -DCMAKE_BUILD_TYPE=Release -G "NMake Makefiles"`
4. `nmake`
5. Your executable is placed in a subdirectory named after your project name and version number
6. If your package needs other files (documentation, etc.) copy that into the same directory as your finished executable
7. `python ..\windeploy.py`
8. Enjoy your signed `.msi` package!
