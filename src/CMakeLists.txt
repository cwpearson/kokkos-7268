cmake_minimum_required(VERSION 3.29)
project(Repro LANGUAGES CXX)

find_package(Kokkos)

add_executable(repro repro.cpp)
target_link_libraries(repro Kokkos::kokkos)