#include <Kokkos_Core.hpp>
#include <Kokkos_DynRankView.hpp>
#include <iostream>

template <typename OutputViewType, typename leftInputViewType,
          typename rightInputViewType>
struct Functor {
  OutputViewType _output;
  const leftInputViewType _leftInput;
  const rightInputViewType _rightInput;

  const int _iend;
  const int _jend;

  using value_type = typename OutputViewType::value_type;

  KOKKOS_INLINE_FUNCTION
  Functor(OutputViewType output_, leftInputViewType leftInput_,
          rightInputViewType rightInput_)
      : _output(output_),
        _leftInput(leftInput_),
        _rightInput(rightInput_),
        _iend(output_.extent_int(3)),
        _jend(rightInput_.extent_int(3)) {}

  KOKKOS_INLINE_FUNCTION
  void operator()(const int cl, const int bf, const int pt) const {
    apply_matvec_product(cl, bf, pt);
  }

  KOKKOS_FORCEINLINE_FUNCTION
  void apply_matvec_product(const int& cl, const int& bf, const int& pt) const {
    for (int i = 0; i < _iend; ++i) {
      value_type tmp(0);
      for (int j = 0; j < _jend; ++j)
        tmp += _leftInput(cl, pt, j, i) * _rightInput(cl, bf, pt, j);
      _output(cl, bf, pt, i) = tmp;
    }
  }
};

template <typename Output, typename Left, typename Right>
void run(const Output& ov, const Left& lv, const Right& rv) {
  using Policy = Kokkos::MDRangePolicy<Kokkos::Serial, Kokkos::Rank<3>,
                                       Kokkos::IndexType<int>>;
  Policy policy({0, 0, 0}, {ov.extent(0), ov.extent(1), ov.extent(2)});
  Functor f(ov, lv, rv);
  Kokkos::parallel_for(policy, f);
}

int main(int argc, char* argv[]) {
  Kokkos::initialize(argc, argv);
  {
    using DRV =
        Kokkos::DynRankView<double,
                            Kokkos::Device<Kokkos::Serial, Kokkos::HostSpace>>;
    DRV output("output", 512, 8, 8, 3);
    DRV lv("lv", 512, 8, 3, 3);
    DRV rv("rv", 512, 8, 8, 3);
    Kokkos::Timer t;
    for (int i = 0; i < 6000; i++) run(output, lv, rv);
    double elapsed = t.seconds();
    std::cout << "Time: " << t.seconds() << '\n';
  }
  Kokkos::finalize();
  return 0;
}