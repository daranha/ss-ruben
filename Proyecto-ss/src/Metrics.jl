
# Métricas euclidianas
dE_R(x,y) = abs(x-y)
dE_R2(p,q) = sqrt((p[1]-q[1])^2 + (p[2]-q[2])^2) # p y q son Vector
dE_C(z,w) = abs(z-w)


# Métricas "máximo" 
dMax_R2(p,q) = max(abs(p[1]-q[1]), abs(p[2]-q[2])) # p y q son Vector
dMax_C(z,w) = max(abs(real(z)-real(w)), abs(imag(z)-imag(w)))


# Métricas Manhattan
dM_R2(p,q) = abs(p[1]-q[1]) + abs(p[2]-q[2]) # p y q son Vector
dM_C(z,w) = abs(real(z)-real(w)) + abs(imag(z)-imag(w))


# Métrica cordal en C
dC_C(z,w) = 2abs(z-w)/sqrt((1+abs2(z))*(1+abs2(w)))

# Métrica cordal en la esfera de Riemann
function dC_RS(z,w) # RS es Riemann Sphere
    if isinf(w)
        return 2/sqrt(1+abs2(z))
    elseif isinf(z)
        return 2/sqrt(1+abs2(w))
    end    
    dC_C(z,w)
end


# Métrica hiperbólica en H2
function dH_H2(z,w)
    imagzw = imag(z)*imag(w)
    if imagzw <= 0 # Si los puntos no están en H2, la distancia es "infinita"
        return Inf
    end
    acosh(1+abs2(z-w)/(2imagzw))
end


# Métricas cordal e hiperbólica en R2
dC_R2(p,q) = dC_C(complex(p[1],p[2]), complex(q[1],q[2]))
dH_R2(p,q) = dH_H2(complex(p[1],p[2]), complex(q[1],q[2]))


# Dibujo de bolas con su centro y radio

function drawballR2!(img, p0, r, d=dE_R2; xmin=-2, xmax=2, ymin=-2, ymax=2, color=RGB(0,0,0))
    
    height, width = size(img)
    
    for h in 1:height
        for w in 1:width
            p = pixeltopoint(w,h,width,height,xmin,xmax,ymin,ymax)
            
            if d(p0,p) < r # Si (x,y) está en la bola, lo pintamos
                img[h,w] = color
            end # if
            
        end # for width
    end # for height
    
    img
end


function drawgradballR2!(img, p0, r, d=dE_R2; xmin=-2, xmax=2, ymin=-2, ymax=2,
        inicolor=RGB(1.,1.,1.), fincolor=RGB(0.,0.,0.))
    
    height, width = size(img)
    
    for h in 1:height
        for w in 1:width
            p = pixeltopoint(w,h,width,height,xmin,xmax,ymin,ymax)
            dis = d(p0,p)
            if dis < r # Si (x,y) está en la bola, lo pintamos
                img[h,w] = linterpRGB(inicolor, fincolor, dis/r)
            end # if
            
        end # for width
    end # for height
    
    img
end

