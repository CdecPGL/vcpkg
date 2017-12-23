# Specify version
set(VERSION "3.19")

include(vcpkg_common_functions)

# Currently, only support "x86-windows-static"
if(NOT ${TARGET_TRIPLET} MATCHES "x86-windows-static")
        message(FATAL_ERROR "A supported triplet is only x86-windows-static.")
endif()

# Prepair sources
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
file(GLOB INDLUDES ${SOURCE_PATH}/*.h)
file(INSTALL ${INDLUDES} DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/Release/DxLib.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(INSTALL ${SOURCE_PATH}/Debug/DxLib_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/DxLib.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/dxlib RENAME copyright)
