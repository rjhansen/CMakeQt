# Code Skeleton for CMake/Qt Apps

This is a simple do-nothing application that comes with build scripts to create properly codesigned packages for OS X and Windows.  If you wish to use this as a
basis for your own package, follow this process:

 1. Edit the toplevel CMakeLists.txt to refer to your own project name
 2. Edit the toplevel CMakeLists.txt to add any Qt5 modules you require
 3. Edit src/CMakeLists.txt.  Look for the lines containing "codesign".  Make sure they point to your codesigning identity.  (This walkthrough assumes you have codesign set up correctly.)
 4. Write your app.  (This may require modifying your CMakeLists files.  Particularly see any line with "add_executable" in it.)
 5. Confirm you can build and run your app
 6. On OS X, "make dmg" will make a bouncing baby disk image
 7. On Windows
    1. ensure 'signtool' will do the right thing by default
    2. edit makemsi.ps1 and edit the first six variables appropriately
    3. rename src/CMakeQt.wxs to src/YOUR-PROJECT-NAME.wxs
    4. edit src/YOUR-PROJECT-NAME.wxs
       * Change the three defines at the top of the file
       * Search through the file for the string "CHANGE ME" and change as necessary
    5. From a PowerShell prompt, type 'makemsi.ps1' and you're off to the races
