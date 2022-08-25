set -ex

cmake \
    ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DENABLE_octave=OFF \
    -DENABLE_tcl=ON \
    -DENABLE_tk=ON \
    -DBUILD_TEST=ON \
    -B_build \
    -GNinja
 
cmake --build _build
cmake --install _build

