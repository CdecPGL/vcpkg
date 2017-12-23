# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

# Currently, only support "x86-windows-static"
if(NOT ${TARGET_TRIPLET} MATCHES "x86-windows-static")
        message(FATAL_ERROR "A supported triplet is only x86-windows-static.")
endif()

# Specify version
set(VERSION "3.19")

# Prepair sources
include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/DxLibMake)
vcpkg_download_distfile(ARCHIVE
    URLS "http://dxlib.o.oo7.jp/DxLib/DxLibMake${VERSION}.zip"
    FILENAME "dxlib-${VERSION}.zip"
    SHA512 4f55c65097a7aabc5a934fe0f306dd3d205638a38e0332ffb869fe3ab9355f45345e3756150962849b483725077ae3971188a901e2bd21d27f5be7c449eb7d81
)
vcpkg_extract_source_archive(${ARCHIVE})

# Build
vcpkg_build_msbuild(
    PROJECT_PATH ${SOURCE_PATH}/DxLibMake.sln
    PLATFORM "Win32"
)

# Copy libraries
file(GLOB INDLUDES ${SOURCE_PATH}/*.h DESTINATION)
file(INSTALL ${INDLUDES} DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/Release/DxLib.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(INSTALL ${SOURCE_PATH}/Debug/DxLib_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/DxLib.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/dxlib RENAME copyright)
