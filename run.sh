#! /bin/bash

set -eou pipefail

# if [ ! $(cat /proc/sys/kernel/perf_event_paranoid) -eq 0 ]; then
#   echo "host perf_event_paranoid is no good"
#   exit 1
# fi

if ! command -v podman >& /dev/null; then
  echo using docker
  DOCKER=docker
else
  echo using podman
  DOCKER=podman
fi

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

if [ ! -d kokkos-4.4-pr ]; then
    git clone git@github.com:cwpearson/kokkos.git kokkos-pr || true
    cp -r kokkos-pr kokkos-4.4-pr
    (cd kokkos-4.4-pr && git checkout fix/serial-bypass-region-mutex)
fi

versions=(
    9.5.0
    10.2.0
    10.5.0
    11.5.0
    12.4.0
    13.3.0
    14.2.0
)

for version in "${versions[@]}"; do
    $DOCKER build -f $version.dockerfile -t $version .
done

for version in "${versions[@]}"; do
    $DOCKER run --privileged --rm -it \
      --cap-add PERFMON \
      -v $(realpath kokkos-4.4-pr):/kokkos-4.4-pr \
      -v $(realpath kokkos-4.3):/kokkos-4.3 \
      -v $(realpath kokkos-4.4):/kokkos-4.4 \
      -v $(realpath kokkos-4.4-patched):/kokkos-4.4-patched \
      $version \
      /dockerConfigBuildRun.sh \
      2>&1 | tee $version.out
done

for version in "${versions[@]}"; do
    echo $version
    grep Time: $version.out
done