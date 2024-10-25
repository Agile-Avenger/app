if(NOT TARGET fbjni::fbjni)
add_library(fbjni::fbjni SHARED IMPORTED)
set_target_properties(fbjni::fbjni PROPERTIES
    IMPORTED_LOCATION "C:/Users/ankit/.gradle/caches/8.10.2/transforms/3edf1a87345f97a0a10d63bef50c344e/transformed/fbjni-0.6.0/prefab/modules/fbjni/libs/android.armeabi-v7a/libfbjni.so"
    INTERFACE_INCLUDE_DIRECTORIES "C:/Users/ankit/.gradle/caches/8.10.2/transforms/3edf1a87345f97a0a10d63bef50c344e/transformed/fbjni-0.6.0/prefab/modules/fbjni/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

