#!/usr/bin/env bash

set -ex

if [[ "$target_platform" == osx* ]]; then
    CMAKE_PLATFORM_FLAGS+=" -DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT}"
    # disable xcairo device on macOS, since conda-forge's cairo doesn't support X11
    # ref: https://github.com/conda-forge/cairo-feedstock/issues/22
    CMAKE_ARGS="${CMAKE_ARGS} -DPLD_xcairo=OFF "

    if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
       _MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET}
       unset MACOSX_DEPLOYMENT_TARGET
       cmake \
           -DCMAKE_C_COMPILER="${CC_FOR_BUILD}" \
           -DCMAKE_CXX_COMPILER="${CXX_FOR_BUILD}" \
           -DCMAKE_Fortran_COMPILER="${FC_FOR_BUILD}" \
           -DCMAKE_C_FLAGS="" \
           -DCMAKE_CXX_FLAGS="" \
           -DCMAKE_Fortran_FLAGS="" \
           -DCMAKE_EXE_LINKER_FLAGS="" \
           -DDEFAULT_NO_DEVICES=ON \
           -DDEFAULT_NO_BINDINGS=ON \
           -DPKG_CONFIG_EXECUTABLE=Not-Found \
           -DENABLE_octave=OFF \
           -DENABLE_tcl=ON \
           -DENABLE_tk=ON \
           -DPLD_xcairo=OFF \
           -DPLD_xwin=ON \
           -DBUILD_TEST=ON \
           -B_build_native \
           -GNinja
        cmake --build _build_native
        CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_NATIVE_BINARY_DIR=$PWD/_build_native"
        CMAKE_ARGS="${CMAKE_ARGS} -DNaNAwareCCompiler=ON"
        export MACOSX_DEPLOYMENT_TARGET=${_MACOSX_DEPLOYMENT_TARGET}
    fi
    CMAKE_PLATFORM_FLAGS+=" -DCMAKE_OSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET}"
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
    -DPLD_xwin=ON \
    -B_build \
    -GNinja
 
cmake --build _build
cmake --install _build
