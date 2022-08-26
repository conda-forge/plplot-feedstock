set -ex

if [[ $(uname) == "Darwin" ]] ; then
    # disable xcairo device on macOS, since conda-forge's cairo doesn't support X11
    CMAKE_ARGS="${CMAKE_ARGS} -DPLD_xcairo=OFF "
fi

# since plplot overrides the CMAKE_INSTALL_* variables, we need to cleanup what is set by conda
CMAKE_ARGS=${CMAKE_ARGS//-DCMAKE_INSTALL_LIBDIR=lib/}

cmake \
    ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_octave=OFF \
    -DENABLE_tcl=ON \
    -DENABLE_tk=ON \
    -DBUILD_TEST=ON \
    -B_build \
    -GNinja
 
cmake --build _build
cmake --install _build

