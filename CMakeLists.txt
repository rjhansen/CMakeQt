cmake_minimum_required(VERSION 3.15.0 FATAL_ERROR)
project(CMakeQt VERSION 1.0.0)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOQRC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION})
find_package(Qt5 COMPONENTS Core Widgets REQUIRED)

if (MSVC)
    set(SIGNTOOL "C:/Program Files (x86)/Microsoft SDKs/ClickOnce/SignTool/signtool.exe")
    set(WIXBINDIR "C:/Program Files (x86)/WiX Toolset v3.11/bin")
endif()

set(SOURCECODE src/main.cpp src/mainwindow.cpp src/mainwindow.ui)

if (APPLE)
    add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${SOURCECODE})
    add_custom_target(dmg)
    add_custom_command(TARGET dmg
            DEPENDS ${PROJECT_NAME}
            POST_BUILD
            COMMAND rm -f *.dmg
            COMMAND ${Qt5_DIR}/../../../bin/macdeployqt ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}/${PROJECT_NAME}.app -always-overwrite -codesign=Robert\ Hansen
            COMMAND /usr/bin/hdiutil create -fs HFS+ -volname "${PROJECT_NAME}" -srcfolder "${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}/${PROJECT_NAME}.app" "${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}/${PROJECT_NAME}.dmg"
            COMMAND /usr/bin/codesign -s "Robert Hansen" "${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}/${PROJECT_NAME}.dmg"
            COMMAND rm -rf "${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}/${PROJECT_NAME}.app")
elseif (MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL")
    set(HEAT ${WIXBINDIR}/heat.exe)
    set(CANDLE ${WIXBINDIR}/candle.exe)
    set(LIGHT ${WIXBINDIR}/light.exe)
    add_executable(${PROJECT_NAME} WIN32 ${SOURCECODE})
    add_custom_command(TARGET ${PROJECT_NAME}
            POST_BUILD
            COMMAND "${SIGNTOOL}" sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a "${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}/${PROJECT_NAME}.exe"
            COMMAND "${Qt5_DIR}/../../../bin/windeployqt.exe" --no-webkit2 --no-system-d3d-compiler --no-compiler-runtime --no-angle --no-opengl-sw --no-quick-import "${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}/${PROJECT_NAME}.exe")
    add_custom_target(msi DEPENDS ${PROJECT_NAME})
    add_custom_command(TARGET msi
            COMMAND ${HEAT} dir ${PROJECT_NAME}-${PROJECT_VERSION} -sreg -gg -sfrag -srd -template fragment -out directory.wxs -cg MainApp -dr AppDir -t ./HeatTransform.xslt
            COMMAND copy *.wxs ${PROJECT_NAME}-${PROJECT_VERSION}
            COMMAND copy license.rtf ${PROJECT_NAME}-${PROJECT_VERSION}
            COMMAND cd ${PROJECT_NAME}-${PROJECT_VERSION}
            COMMAND ${CANDLE} *.wxs
            COMMAND ${LIGHT} *.wixobj -o ../${PROJECT_NAME}-${PROJECT_VERSION}.msi -ext WixUIExtension
            COMMAND del *.wxs *.wixobj *.rtf
            COMMAND cd ..
            COMMAND "${SIGNTOOL}" sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a "${PROJECT_NAME}-${PROJECT_VERSION}.msi")
elseif(UNIX)
    add_executable(${PROJECT_NAME} ${SOURCECODE})
endif(APPLE)

set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 17)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD_REQUIRED true)
target_link_libraries(${PROJECT_NAME} Qt5::Widgets)