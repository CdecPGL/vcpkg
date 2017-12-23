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

include(vcpkg_common_functions)

# Currently, only support "x86-windows-static"
if(NOT ${TARGET_TRIPLET} MATCHES "x86-windows-static")
        message(FATAL_ERROR "A supported triplet is only x86-windows-static.")
endif()

# Prepair sources
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/EffekseerForDXLib_132_318e/プロジェクトに追加すべきファイル_VC用)
vcpkg_download_distfile(ARCHIVE
    URLS "http://effekseer.sakura.ne.jp/Releases/EffekseerForDXLib_132_318e.zip"
    FILENAME "effekseer-for-dxlib-1.32.zip"
    SHA512 bce70708ac59aaa93d6d02a1c795a8bfbd76adb588aa59f2a6e22af273261aabdff4a712d662ab4e5985f64c477bf14d544f7f3a7fe3f8ca9a65d3654383f005
)
vcpkg_extract_source_archive(${ARCHIVE})

# Copy libraries
file(INSTALL ${SOURCE_PATH}/EffekseerForDXLib.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)

file(INSTALL ${SOURCE_PATH}/Effekseer_vs2015_x86.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(INSTALL ${SOURCE_PATH}/EffekseerRendererDX9_vs2015_x86.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(INSTALL ${SOURCE_PATH}/EffekseerRendererDX11_vs2015_x86.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(INSTALL ${SOURCE_PATH}/EffekseerForDXLib_vs2015_x86.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)

file(INSTALL ${SOURCE_PATH}/Effekseer_vs2015_x86_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
file(INSTALL ${SOURCE_PATH}/EffekseerRendererDX9_vs2015_x86_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
file(INSTALL ${SOURCE_PATH}/EffekseerRendererDX11_vs2015_x86_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
file(INSTALL ${SOURCE_PATH}/EffekseerForDXLib_vs2015_x86_d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)

# Handle copyright (EffekseerForDXLibのリポジトリにLICENSEがないので、Effekseerのもので代用)
file(DOWNLOAD https://github.com/effekseer/Effekseer/blob/master/LICENSE ${SOURCE_PATH}/LICENSE)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/effekseer-for-dxlib RENAME copyright)
