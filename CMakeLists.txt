cmake_minimum_required(VERSION 3.15.0 FATAL_ERROR)

project(CMakeQt VERSION 1.0.0)
set(SOURCECODE src/main.cpp src/mainwindow.cpp src/mainwindow.ui)
find_package(Qt5 COMPONENTS Core Widgets REQUIRED)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOQRC ON)

if (MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL")
    add_executable(${PROJECT_NAME} WIN32 ${SOURCECODE})
    target_link_libraries(${PROJECT_NAME} Qt5::Widgets)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        CXX_STANDARD 17
        CXX_STANDARD_REQUIRED true
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}")
    configure_file("template.wxs.in" "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.wxs")
endif(MSVC)
