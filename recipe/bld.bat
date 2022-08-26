setlocal EnableExtensions EnableDelayedExpansion
@echo on

:: set pkg-config path so that host deps can be found
:: (set as env var so it's used by both meson and during build with g-ir-scanner)
set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig;%BUILD_PREFIX%\Library\lib\pkgconfig"

:: set compilers to clang-cl
set "CC=clang-cl"
set "CXX=clang-cl"

:: cmake options
set ^"CMAKE_OPTIONS=^
       -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
       -DCMAKE_BUILD_TYPE=Release ^
       -DENABLE_octave=OFF ^
       -DENABLE_tcl=ON ^
       -DENABLE_tk=ON ^
       -DBUILD_TEST=ON ^
       -DENABLE_DYNDRIVERS=OFF ^
       -DENABLE_qt=OFF ^
       -B_build ^
       -GNinja "

cmake !CMAKE_OPTIONS!
if errorlevel 1 exit 1

cmake --build _build
if errorlevel 1 exit 1

cmake --install _build
if errorlevel 1 exit 1
