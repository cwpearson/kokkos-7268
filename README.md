# kokkos-7268

Experiments / reproducer for https://github.com/kokkos/kokkos/issues/7268

```bash
chmod +x run.sh
./run.sh
```

* no difference between std_mutex.h in gcc 10.2 and 9.5

With Kokkos_ARCH_NATIVE=ON
```
/usr/local/bin/c++ -O3 -DNDEBUG -DKOKKOS_DEPENDENCE -march=native -mtune=native CMakeFiles/repro.dir/repro.cpp.o -o repro  /k-install-4.4-patched/lib/libkokkoscontainers.a /k-install-4.4-patched/lib/libkokkoscore.a -ldl /k-install-4.4-patched/lib/libkokkossimd.a
```
```
4.3 Time: 3.57041
4.4 Time: 4.24672
4.4-patched Time: 4.29894
10.2.0
4.3 Time: 3.57041
4.4 Time: 4.24672
4.4-patched Time: 4.29894
```

With Kokkos_ARCH_NATIVE=OFF CMAKE_CXX_FLAGS="-march=native -mtune=native"
```
4.3 Time: 3.2483
4.4 Time: 3.59825
4.4-patched Time: 3.5324
10.2.0
4.3 Time: 3.2483
4.4 Time: 3.59825
4.4-patched Time: 3.5324
```

With Kokkos_ARCH_NATIVE=ON and SET(KOKKOS_ARCH_AVX512XEON OFF)
```
[100%] Built target repro
4.3 Time: 3.60511
4.4 Time: 4.22094
4.4-patched Time: 4.206
10.2.0
4.3 Time: 3.60511
4.4 Time: 4.22094
4.4-patched Time: 4.206
```

`cooperlake` on the repro binaries:
```
4.3 Time: 3.45178
4.4 Time: 3.66214
4.4-patched Time: 3.79439
10.2.0
4.3 Time: 3.45178
4.4 Time: 3.66214
4.4-patched Time: 3.79439
```
```
-march=cooperlake -mtune=cooperlake
```

`native` on the repro binaries
```
4.3 Time: 3.64086
4.4 Time: 4.39913
4.4-patched Time: 4.32175
```
```
-march=cooperlake -mmmx -mno-3dnow -msse -msse2 -msse3 -mssse3 -mno-sse4a -mcx16 -msahf -mmovbe -maes -msha -mpclmul -mpopcnt -mabm -mno-lwp -mfma -mno-fma4 -mno-xop -mbmi -mno-sgx -mbmi2 -mpconfig -mwbnoinvd -mno-tbm -mavx -mavx2 -msse4.2 -msse4.1 -mlzcnt -mno-rtm -mno-hle -mrdrnd -mf16c -mfsgsbase -mrdseed -mprfchw -madx -mfxsr -mxsave -mxsaveopt -mavx512f -mno-avx512er -mavx512cd -mno-avx512pf -mno-prefetchwt1 -mclflushopt -mxsavec -mxsaves -mavx512dq -mavx512bw -mavx512vl -mavx512ifma -mavx512vbmi -mno-avx5124fmaps -mno-avx5124vnniw -mclwb -mno-mwaitx -mno-clzero -mpku -mrdpid -mgfni -mshstk -mavx512vbmi2 -mavx512vnni -mvaes -mvpclmulqdq -mavx512bitalg -mavx512vpopcntdq -mmovdiri -mmovdir64b -mwaitpkg -mcldemote -mptwrite -mavx512bf16 -menqcmd -mno-avx512vp2intersect --param l1-cache-size=48 --param l1-cache-line-size=64 --param l2-cache-size=76800 -mtune=generic
```