if (APPLE)
    add_executable(${PROJECT_NAME} MACOSX_BUNDLE main.cpp mainwindow.cpp mainwindow.ui)
    add_custom_target(dmg)
    add_custom_command(TARGET dmg
        DEPENDS ${PROJECT_NAME}
        POST_BUILD
        COMMAND rm -f *.dmg
        COMMAND ${Qt5_DIR}/../../../bin/macdeployqt ${PROJECT_NAME}.app -always-overwrite -codesign=Robert\ Hansen
        COMMAND /usr/bin/hdiutil create -fs HFS+ -volname "${PROJECT_NAME}" -srcfolder "${PROJECT_NAME}.app" "${PROJECT_NAME}.dmg"
        COMMAND /usr/bin/codesign -s "Robert Hansen" "${PROJECT_NAME}.dmg"
        COMMAND mv "${PROJECT_NAME}.dmg" ..
        COMMAND rm -rf "${PROJECT_NAME}.app")
elseif (WIN32)
    add_executable(${PROJECT_NAME} WIN32 main.cpp mainwindow.cpp mainwindow.ui)
elseif(UNIX)
    add_executable(${PROJECT_NAME} main.cpp mainwindow.cpp mainwindow.ui)
endif(APPLE)

set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 14)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD_REQUIRED true)
target_link_libraries(${PROJECT_NAME} Qt5::Widgets)