FROM gcc:9.5.0

ADD cmake-3.29.8-linux-x86_64.sh /cmake.sh
RUN chmod +x /cmake.sh
RUN /cmake.sh --skip-license --prefix=/usr

ADD kokkos-4.3 /kokkos-4.3
ADD kokkos-4.4 /kokkos-4.4

ADD src /src
ADD dockerConfigBuildRun.sh /dockerConfigBuildRun.sh
RUN chmod +x /dockerConfigBuildRun.sh