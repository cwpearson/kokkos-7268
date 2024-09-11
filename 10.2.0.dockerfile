FROM public.ecr.aws/docker/library/gcc:10.2.0

ADD cmake-3.29.8-linux-x86_64.sh /cmake.sh
RUN chmod +x /cmake.sh
RUN /cmake.sh --skip-license --prefix=/usr
 
RUN wget --no-check-certificate https://sourceware.org/pub/valgrind/valgrind-3.23.0.tar.bz2 \
 && tar -xf valgrind-3.23.0.tar.bz2 \
 && (cd valgrind-3.23.0; ./configure) \
 && (cd valgrind-3.23.0; make -j$(nproc) install)
 
RUN apt-get update && apt-get install -y linux-perf
RUN cp /usr/bin/perf_* /usr/bin/perf_6.5

ADD kokkos-4.3 /kokkos-4.3
ADD kokkos-4.4 /kokkos-4.4
ADD kokkos-4.4-patched /kokkos-4.4-patched
 
ADD src /src
ADD dockerConfigBuildRun.sh /dockerConfigBuildRun.sh
RUN chmod +x /dockerConfigBuildRun.sh
