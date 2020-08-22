# Code Skeleton for CMake/Qt Apps

This is a simple do-nothing application that comes with build scripts to create properly
codesigned packages for Windows.  If you wish to use this as a basis for your own package,
follow this process:

## Prerequisites
* [Python 3.8 or later](https://www.python.org)
* [CMake](https://www.cmake.org)
* [Qt](https://www.qt.io/download)
* For Windows only:
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

No matter which platform you're targeting, in `CMakeLists.txt` you'll need to:

* Set the project name and version properly
* Add any Qt5 modules you require
* Set the source code properly (including `.ui` files)
* `mkdir build`
* `cd build`

### Windows-specific

* Edit `template.wxs.in` and change the upgrade code to a unique UUID that will be constant over all versions of your product
* `cmake .. -DCMAKE_BUILD_TYPE=Release -G "NMake Makefiles"`
* `nmake`
* Your executable is placed in a subdirectory named after your project name and version number
* `python ..\windeploy.py`
* Enjoy your signed `.msi` package!

## Instructions for Fedora
* Edit `project.spec.in` and update it appropriately for your project
* `cmake .. -DCMAKE_BUILD_TYPE=Release`
* `make`
* Your executable is placed in a subdirectory named after your project name and version number
* `make package`
* If you have a GPG key, you may wish to set up your `~/.rpmmacros` file and then `rpm --addsign` it
* Enjoy your `.rpm` package!