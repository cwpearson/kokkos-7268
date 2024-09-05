#! /bin/bash

set -eou pipefail

wget --continue https://github.com/Kitware/CMake/releases/download/v3.29.8/cmake-3.29.8-linux-x86_64.sh

if [ ! -d kokkos-4.3 ]; then
    git clone git@github.com:kokkos/kokkos.git || true
    cp -r kokkos kokkos-4.3
    (cd kokkos-4.3 && git checkout 4.3.01)
fi
if [ ! -d kokkos-4.4 ]; then
    git clone git@github.com:kokkos/kokkos.git || true
    cp -r kokkos kokkos-4.4
    (cd kokkos-4.4 && git checkout 4.4.00)
fi


for f in *.dockerfile; do
    version=$(basename "$f" .dockerfile)
    docker build -f $f -t $version .
done

for f in *.dockerfile; do
    version=$(basename "$f" .dockerfile)

    docker run --rm -it \
      -v $(realpath kokkos-4.3):/kokkos \
      $version \
      /dockerConfigBuildRun.sh \
      2>&1 | tee $version.out
done