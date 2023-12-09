# Functions útiles para crear grupos de Schottky que se besan (fuchisianos y casifuchsianos)


#
# Crea los generadores a y b, que emparejan circulos CA con Ca y CB con Cb
# dados por la "primera fórmula" para "grupos de Schottky que se besan",
# parametrizados por dos números reales positivos y y k.
#
function createfirstkissingSchottky(y::Real, k::Real)
    if !(y > 0 && k > 0)
        println("Error: y y k deben ser ambas mayores a 0.")
        return
    end
    
    x = sqrt(1+y^2)
    v = 2k/((k^2+1)*y)
    u = sqrt(1+v^2)
    
    MobT(u, im*k*v, -im*v/k, u), MobT(x, y, y, x),
    Circ(-im*k*u/v, k/v), Circ(im*k*u/v, k/v), Circ(-x/y, 1/y), Circ(x/y, 1/y)
end


# El conmutador [f,g]
commutator(f::AbstractMobiusTransformation, g::AbstractMobiusTransformation) = MobT(f∘g∘inverse(f)∘inverse(g))

