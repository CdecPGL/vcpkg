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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/EffekseerRuntime130)
vcpkg_download_distfile(ARCHIVE
    URLS "http://effekseer.sakura.ne.jp/Releases/EffekseerRuntime130.zip"
    FILENAME "effekseer-1.30.zip"
    SHA512 9708f7a1147e3be0d64be4114ece68a6af32d377ca8a95072472736f4da0342abfc3ec0a8172a7495c4038fb435d3706fa7c1a4c9a1200ca622c4454bb9335ae
)
vcpkg_extract_source_archive(${ARCHIVE})

# Copy libraries
file(GLOB INDLUDES ${SOURCE_PATH}/Compiled/include/*.h)
file(INSTALL ${INDLUDES} DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(GLOB REL_LIBS ${SOURCE_PATH}/Compiled/lib/VS2015/Release/*.lib)
file(INSTALL ${REL_LIBS} DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(GLOB DEB_LIBS ${SOURCE_PATH}/Compiled/lib/VS2015/Debug/*.lib)
file(INSTALL ${DEB_LIBS} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)

# Handle copyright
file(DOWNLOAD https://github.com/effekseer/Effekseer/blob/master/LICENSE ${SOURCE_PATH}/LICENSE)
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/effekseer RENAME copyright)
