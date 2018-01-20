using Nemo, QuickTest, Base.Test
import QuickTest: generate_test_value
using Nemo: MatSpace


function generate_test_value(::Type{T}, size) where {T <: SetElem}
  parent = generate_test_value(parent_type(T), size)
  generate_test_value(parent, size)
end


generate_test_value(::Type{FlintIntegerRing}, size) = ZZ

function generate_test_value(::FlintIntegerRing, size)
  return ZZ(rand(-size:size))
end


generate_test_value(::Type{FlintRationalField}, size) = QQ

function generate_test_value(::FlintRationalField, size)
  num = rand(-size:size)
  den = rand(1:size)
  return QQ(num,den)
end


function generate_test_value(nf::AnticNumberField, size)
  poly_parent = parent(nf.pol)
  nf(poly_parent([generate_test_value(fmpq, size) for dx in 1:degree(nf)]))
end


function generate_test_value(::Type{M}, size) where {T <: SetElem, M <: MatSpace{T}}
  coeff_module = generate_test_value(parent_type(T), size)
  return MatrixSpace(coeff_module, rand(1:size), rand(1:size))
end

function generate_test_value(parent::M, size) where {T <: SetElem, M <: MatSpace{T}}
  parent([generate_test_value(base_ring(parent), size)
          for i in 1:parent.rows, j in 1:parent.cols])
end


function runtests_nemo()
  for coeffring in [ZZ, QQ, CyclotomicField(3,"zeta")[1]] 
    ms = MatrixSpace(coeffring, 3, 3)
    @testset "Matrix over $coeffring" begin
      @testprop 2  12 + A == A + 12  A::Elem{ms}
      @testprop 2  BigInt(11) + A == A + BigInt(11)  A::Elem{ms}
      @testprop 2  A - 3 == -(3 - A)  A::Elem{ms}
      @testprop 2  A - BigInt(7) == -(BigInt(7) - A)  A::Elem{ms}
      @testprop 2  3*A == A*3  A::Elem{ms}
      @testprop 2  BigInt(3)*A == A*BigInt(3)  A::Elem{ms}
    end
  end
end
