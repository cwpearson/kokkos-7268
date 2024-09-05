#! /bin/bash


## build and install kokkos 4.3
cmake -S /kokkos-4.3 -B /k-build-4.3 \
 -DKokkos_ENABLE_SERIAL=ON \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_INSTALL_PREFIX=/k-install-4.3
cmake --build /k-build-4.3 --target install -j $(nproc)

## build and install kokkos 4.4
cmake -S /kokkos-4.4 -B /k-build-4.4 \
 -DKokkos_ENABLE_SERIAL=ON \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_INSTALL_PREFIX=/k-install-4.4
cmake --build /k-build-4.4 --target install -j $(nproc)

## build and install patched kokkos 4.4
cmake -S /kokkos-4.4-patched -B /k-build-4.4-patched \
 -DKokkos_ENABLE_SERIAL=ON \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_INSTALL_PREFIX=/k-install-4.4-patched
cmake --build /k-build-4.4-patched --target install -j $(nproc)

## build repro against 4.3
cmake -S /src -B /build-4.3 \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DKokkos_ROOT=/k-install-4.3
VERBOSE=1 cmake --build /build-4.3

## build repro against 4.4
cmake -S /src -B /build-4.4 \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DKokkos_ROOT=/k-install-4.4
VERBOSE=1 cmake --build /build-4.4

## build repro against patched 4.4
cmake -S /src -B /build-4.4-patched \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DKokkos_ROOT=/k-install-4.4-patched
VERBOSE=1 cmake --build /build-4.4-patched

echo -n "4.3 "
/build-4.3/repro

echo -n "4.4 "
/build-4.4/repro

echo -n "4.4-patched "
/build-4.4-patched/repro