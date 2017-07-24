if (APPLE)
    add_executable(${PROJECT_NAME} MACOSX_BUNDLE main.cpp mainwindow.cpp mainwindow.ui)
    add_custom_target(${PROJECT_NAME}.dmg)
    add_custom_command(TARGET ${PROJECT_NAME}.dmg
        DEPENDS ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${Qt5_DIR}/../../../bin/macdeployqt ${PROJECT_NAME}.app
        COMMAND /usr/bin/codesign -s "Robert Hansen" -i com.roberthansen.CMakeQt --deep "${PROJECT_NAME}.app"
        COMMAND /usr/bin/hdiutil create -fs HFS+ -volname "${PROJECT_NAME}" -srcfolder "${PROJECT_NAME}.app" "${PROJECT_NAME}.dmg"
        COMMAND /usr/bin/codesign -s "Robert Hansen" "${PROJECT_NAME}.dmg")
elseif (WIN32)
    add_executable(${PROJECT_NAME} WIN32 main.cpp mainwindow.cpp mainwindow.ui)
    add_custom_target(msi)
    add_custom_command(TARGET msi
        DEPENDS ${PROJECT_NAME}
        POST_BUILD
        COMMAND rmdir /s /q package
        COMMAND mkdir package
        COMMAND copy ${PROJECT_NAME}.exe package\${PROJECT_NAME}.exe
        COMMAND ${Qt5_DIR}/../../../bin/windeployqt --release package
        COMMAND ${SIGNTOOL} sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a package\${PROJECT_NAME}.exe
        COMMAND copy license.rtf package\license.rtf
        COMMAND ${WIXDIR}\heat.exe dir package -o package.wxs -scom -frag -srd -sreg -gg -cg ${PROJECT_NAME}GroupId -dr BIN_DIR_REF
        COMMAND ${WIXDIR}\candle.exe ${PROJECT_NAME}.wxs package.wxs
        COMMAND ${WIXDIR}\light.exe ${PROJECT_NAME}.wixobj -b package
        COMMAND ${SIGNTOOL} sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a package\${PROJECT_NAME}.msi
        COMMAND rmdir /s /q package
        )
elseif(UNIX)
    add_executable(${PROJECT_NAME} main.cpp mainwindow.cpp mainwindow.ui)
endif(UNIX)

set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 14)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD_REQUIRED true)
target_link_libraries(${PROJECT_NAME} Qt5::Widgets)