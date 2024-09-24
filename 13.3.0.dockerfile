FROM public.ecr.aws/docker/library/gcc:13.3.0

ADD cmake-3.29.8-linux-x86_64.sh /cmake.sh
RUN chmod +x /cmake.sh
RUN /cmake.sh --skip-license --prefix=/usr

RUN apt-get update && apt-get install -y linux-perf valgrind

ADD src /src
ADD dockerConfigBuildRun.sh /dockerConfigBuildRun.sh
RUN chmod +x /dockerConfigBuildRun.sh

