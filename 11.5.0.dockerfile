FROM public.ecr.aws/docker/library/gcc:11.5.0

ADD cmake-3.29.8-linux-x86_64.sh /cmake.sh
RUN chmod +x /cmake.sh
RUN /cmake.sh --skip-license --prefix=/usr

ADD kokkos-4.3 /kokkos-4.3
ADD kokkos-4.4 /kokkos-4.4
ADD kokkos-4.4-patched /kokkos-4.4-patched

ADD src /src
ADD dockerConfigBuildRun.sh /dockerConfigBuildRun.sh
RUN chmod +x /dockerConfigBuildRun.sh

RUN apt-get update && apt-get install -y linux-perf valgrind
