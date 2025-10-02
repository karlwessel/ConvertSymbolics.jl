module NemoExt
using Nemo
using ConvertSymbolics
AbstractAlgebraExt = Base.get_extension(ConvertSymbolics, :AbstractAlgebraExt)

function AbstractAlgebraExt.tonumber(x::CalciumFieldElem)
    r = AbstractAlgebraExt.tonumber(Nemo.QQ(real(x)))
    isreal(x) && return r
    im*AbstractAlgebraExt.tonumber(Nemo.QQ(imag(x)))
end
end
