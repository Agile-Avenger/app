if(NOT TARGET hermes-engine::libhermes)
add_library(hermes-engine::libhermes SHARED IMPORTED)
set_target_properties(hermes-engine::libhermes PROPERTIES
    IMPORTED_LOCATION "C:/Users/ankit/.gradle/caches/8.10.2/transforms/61c52c4780efd0406fb73a343fa3f040/transformed/hermes-android-0.76.0-debug/prefab/modules/libhermes/libs/android.armeabi-v7a/libhermes.so"
    INTERFACE_INCLUDE_DIRECTORIES "C:/Users/ankit/.gradle/caches/8.10.2/transforms/61c52c4780efd0406fb73a343fa3f040/transformed/hermes-android-0.76.0-debug/prefab/modules/libhermes/include"
    INTERFACE_LINK_LIBRARIES ""
)
endif()

