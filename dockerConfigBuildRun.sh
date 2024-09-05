#! /bin/bash

cmake -S /kokkos-4.3 -B /k-build-4.3 \
 -DKokkos_ENABLE_SERIAL=ON \
 -DKokkos_ARCH_NATIVE=ON \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_INSTALL_PREFIX=/k-install-4.3

cmake --build /k-build-4.3 --target install -j $(nproc)

cmake -S /src -B /build-4.3 \
 -DCMAKE_BUILD_TYPE=Release \
 -DKokkos_ROOT=/k-install-4.3

cmake --build /build-4.3

cmake -S /kokkos-4.4 -B /k-build-4.4 \
 -DKokkos_ENABLE_SERIAL=ON \
 -DKokkos_ARCH_NATIVE=ON \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_INSTALL_PREFIX=/k-install-4.4

cmake --build /k-build-4.4 --target install -j $(nproc)

cmake -S /src -B /build-4.4 \
 -DCMAKE_BUILD_TYPE=Release \
 -DKokkos_ROOT=/k-install-4.4

cmake --build /build-4.4

echo -n "4.3 "
/build-4.3/repro

echo -n "4.4 "
/build-4.4/repro