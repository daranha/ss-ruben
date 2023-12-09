# Pequeña biblioteca para transformaciones de Möbius, para el curso
# "Seminario de Geometría B - Grupos Kleinianos: Geometría y Visualización".
# Autor: Renato Leriche Vázquez

# Struct que representa a una transformación de Möbius en la esfera de Riemann
struct MobiusTransformation
    a::ComplexF64
    b::ComplexF64
    c::ComplexF64
    d::ComplexF64    
    
    # Constructor "normal"
    MobiusTransformation(a::Number, b::Number, c::Number, d::Number) = new(a,b,c,d)
    # Constructor para lineales y afines
    MobiusTransformation(a::Number, b::Number=0) = new(a,b,0,1)
    # Constructor con argumentos palabra clave
    MobiusTransformation(; a::Number=1, b::Number=0, c::Number=0, d::Number=1) = new(a,b,c,d)
    # Constructor copia
    MobiusTransformation(T::MobiusTransformation) = new(T.a,T.b,T.c,T.d)
end
    
# Alias de nombre de tipo para escribir menos
const MobT = MobiusTransformation 


# Constructor externo que crea la transformación de Möbius tal que
# z1 -> 1, z2 -> 0 y z3 -> Inf
function MobiusTransformation(z1::Number,z2::Number,z3::Number)
    if isinf(z1)
        return MobT(1,-z2,1,-z3) # Usando el constructor interno
    elseif isinf(z2)
        return MobT(0,z1-z3,1,-z3) # Usando el constructor interno
    elseif isinf(z3)
        return MobT(1,-z2,0,z1-z2) # Usando el constructor interno
    end
    MobT(z1-z3, -z2*(z1-z3), z1-z2, -z3*(z1-z2)) # Usando el constructor interno
end


# Constructor externo que crea la transformación de Möbius tal que
# z1 -> w1, z2 -> w2 y z3 -> w3
MobiusTransformation(z1::Number,z2::Number,z3::Number,w1::Number,w2::Number,w3::Number) = 
  inverse(MobT(w1,w2,w3)) ∘ MobT(z1,z2,z3)


# Functions útiles varias

# Verificador de coeficientes
coefficientsok(a::Number, b::Number, c::Number, d::Number) = !iszero(a*d - b*c)

# Matríz de GL(2,C) asociada
matrix(T::MobT) = [T.a T.b; T.c T.d]

# Matríz de SL(2,C) asociada, con "determinante" igual a 1
matrixSL2C(T::MobT) = [T.a T.b; T.c T.d]/sqrt(complex(T.a*T.d - T.b*T.c))

# "Determinante"
det(T::MobT) = T.a*T.d - T.b*T.d

# Inversa
inverse(T::MobT) = MobT(T.d, -T.b, -T.c, T.a)

# Polo
function pole(T::MobT)
    if iszero(T.c)
        return Inf
    end
    
    -T.d/T.c
end


# Evaluación de las transformaciones (usando la técnica de objeto función)
function (T::MobT)(z::Number)
    # Si c es 0, T es afín
    if iszero(T.c)
        if isinf(z)
            return Inf # No se maneja bien la operación Inf/(x+0im)
        end
        
        return (T.a*z + T.b)/T.d
    end
    
    # Si c no es cero, T no es afín
    
    # Si z es infinito
    if isinf(z)
        return T.a/T.c
    end

    Δ = T.c*z + T.d # El "denominador"
    
    # Si c es el polo
    if iszero(Δ) 
        return Inf
    end

    # Evaluación normal
    (T.a*z + T.b)/Δ
end


# Imagen de un círculo bajo un transformación de Möbius
function (T::MobT)(c::Circ)
    if iszero(T.c) # T de la forma az+b
        return Circ(T(c.center), abs(T.a/T.d)*c.radius)
    end
    
    zr = c.center + T.d/T.c # "radio"
    
    if iszero( abs(zr) - c.radius ) # Si el polo de T está en el círculo
        Tza = T(c.center + zr) # T(z_antipoda)
        Tzp = T(c.center + zr*im) # T(z_perpendicular_diametro)
        return Linc(Tza, angle(Tza-Tzp))
    end
    
    # Receta de la Abuela de las Perlas de Indra usando la inversión...
        
    if iszero(zr)
        z1 = T.a/T.c # Si el polo es el centro del círculo, el centro de T(C) es z_1=I_{T(C)}(Inf)=T(Inf)=a/c
    else
        z1 = T(c.center - (c.radius^2)/conj(zr)) # Usando la inversión
    end
    
    Circ(z1, abs(z1 - T(c.center + c.radius)))
end


# Operador composición de funciones
import Base: ∘

∘(T::MobT, S::MobT) = MobT(
    T.a*S.a + T.b*S.c, T.a*S.b + T.b*S.d,
    T.c*S.a + T.d*S.c, T.c*S.b + T.d*S.d
)

compose(T::MobT, S::MobT) = T∘S