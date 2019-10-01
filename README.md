# Code Skeleton for CMake/Qt Apps

This is a simple do-nothing application that comes with build scripts to create properly
codesigned packages for OS X and Windows.  If you wish to use this as a basis for your 
own package, follow this process:

 1. In CMakeLists.txt:
     1. Set the project name and version properly
     2. Add any Qt5 modules you require
     3. Set the source code properly (including `.ui` files)
     4. On Windows, specify paths to `signtool.exe` and the WiX `bin/` directory
 2. Write your app
 3. Confirm you can build and run your app
 4. On OS X, "make dmg" will make a bouncing baby disk image
 5. On Windows
    1. ensure 'signtool' will do the right thing by default
    2. Edit `template.wxs.in` and **CHANGE GUIDS AS NECESSARY**
    3. `nmake msi` will make an MSI package for you