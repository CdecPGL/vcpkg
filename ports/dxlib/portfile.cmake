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

# Build DXLibrary
vcpkg_build_msbuild(
    PROJECT_PATH ${SOURCE_PATH}/DxLibMake.sln
    PLATFORM "Win32"
)

# Copy DXLibrary's libraries
file(INSTALL ${SOURCE_PATH}/Release/DxLib.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib RENAME DxLib_vs2015_x86.lib)
file(INSTALL ${SOURCE_PATH}/Debug/DxLib_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib RENAME DxLib_vs2015_x86_d.lib)

# Upgrade the solusion to build DirectX draw functions because the format of it is vcproj, which are not available for current MSBuild
message(STATUS "Downloading vswhere.exe")
file(DOWNLOAD https://github.com/Microsoft/vswhere/releases/download/2.2.11/vswhere.exe ${SOURCE_PATH}/vswhere.exe)
execute_process(
  COMMAND ./vswhere.exe -latest -property productPath -format value
  WORKING_DIRECTORY ${SOURCE_PATH}
  OUTPUT_VARIABLE DEVENV_PATH
)
string(STRIP ${DEVENV_PATH} DEVENV_PATH)
message(STATUS "Upgrading DxDrawFuncMake.sln")
vcpkg_execute_required_process(
    COMMAND ${DEVENV_PATH} DxDrawFuncMake.sln /upgrade
    WORKING_DIRECTORY ${SOURCE_PATH}
    LOGNAME build-${TARGET_TRIPLET}-upgrade-solusion
)

# Build DirectX draw functions
vcpkg_build_msbuild(
    PROJECT_PATH ${SOURCE_PATH}/DxDrawFuncMake.sln
    PLATFORM "Win32"
)

# Copy DirectX draw functions's libraries
file(INSTALL ${SOURCE_PATH}/DrawFunc_Release/DxDrawFunc.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib RENAME DxDrawFunc_vs2015_x86.lib)
file(INSTALL ${SOURCE_PATH}/DrawFunc_Debug/DxDrawFunc_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib RENAME DxDrawFunc_vs2015_x86_d.lib)

# Copy includes
file(GLOB INDLUDES ${SOURCE_PATH}/*.h)
file(INSTALL ${INDLUDES} DESTINATION ${CURRENT_PACKAGES_DIR}/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/DxLib.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/dxlib RENAME copyright)

vcpkg_copy_pdbs()