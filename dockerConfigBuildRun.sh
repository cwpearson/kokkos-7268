#! /bin/bash

set -eou pipefail

## build and install patched kokkos 4.4
cmake -S /kokkos-4.4-patched -B /k-build-4.4-patched \
 -DKokkos_ENABLE_SERIAL=ON \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_INSTALL_PREFIX=/k-install-4.4-patched
cmake --build /k-build-4.4-patched --target install -j $(nproc)

## build repro against patched 4.4
cmake -S /src -B /build-4.4-patched \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DKokkos_ROOT=/k-install-4.4-patched
VERBOSE=1 cmake --build /build-4.4-patched

## build and install kokkos 4.3
cmake -S /kokkos-4.3 -B /k-build-4.3 \
 -DKokkos_ENABLE_SERIAL=ON \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_INSTALL_PREFIX=/k-install-4.3
cmake --build /k-build-4.3 --target install -j $(nproc)

## build repro against 4.3
cmake -S /src -B /build-4.3 \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DKokkos_ROOT=/k-install-4.3
VERBOSE=1 cmake --build /build-4.3

## build and install kokkos 4.4
cmake -S /kokkos-4.4 -B /k-build-4.4 \
 -DKokkos_ENABLE_SERIAL=ON \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_INSTALL_PREFIX=/k-install-4.4
cmake --build /k-build-4.4 --target install -j $(nproc)

## build repro against 4.4
cmake -S /src -B /build-4.4 \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DKokkos_ROOT=/k-install-4.4
VERBOSE=1 cmake --build /build-4.4

## build and install kokkos 4.4-pr
cmake -S /kokkos-4.4-pr -B /k-build-4.4-pr \
 -DKokkos_ENABLE_SERIAL=ON \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DCMAKE_BUILD_TYPE=Release \
 -DKokkos_ENABLE_ATOMICS_BYPASS=ON \
 -DCMAKE_INSTALL_PREFIX=/k-install-4.4-pr
cmake --build /k-build-4.4-pr --target install -j $(nproc)

## build repro against 4.4-pr
cmake -S /src -B /build-4.4-pr \
 -DCMAKE_BUILD_TYPE=Release \
 -DCMAKE_CXX_FLAGS="-march=native -mtune=native" \
 -DKokkos_ROOT=/k-install-4.4-pr
VERBOSE=1 cmake --build /build-4.4-pr

PERF_EVENTS="cpu-clock,context-switches,cycles,instructions,branch-misses,cache-references,cache-misses,ref-cycles,bus-cycles,cpu/mem-loads-aux/,cpu/mem-stores/,LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses,L1-icache-load-misses,iTLB-load-misses,node-load-misses,node-loads"

for i in {0..3}; do
echo -n "4.3 "
/build-4.3/repro
done
# perf record -F 8000 /build-4.3/repro
# perf annotate -d /build-4.3/repro --stdio2 --stdio-color=never | tee
# rm -f perf.data

for i in {0..3}; do
echo -n "4.4 "
/build-4.4/repro
done
# perf record -F 8000 /build-4.4/repro
# perf annotate -d /build-4.4/repro --stdio2 --stdio-color=never | tee
# rm -f perf.data

for i in {0..3}; do
echo -n "4.4-patched "
/build-4.4-patched/repro
done
# perf record -F 8000 /build-4.4-patched/repro
# perf annotate -d /build-4.4-patched/repro --stdio2 --stdio-color=never | tee
# rm -f perf.data

for i in {0..3}; do
echo -n "4.4-pr "
/build-4.4-pr/repro
done
