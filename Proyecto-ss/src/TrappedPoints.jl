#
# Functions para determinar si un punto ha escapado
#
function createhasescapedC(d, q, R)
    function hasescapedC(z)
        d(z,q) > R
    end
end

hasescapedB02C(z) = abs2(z) > 4


#
# Dibujo del conjunto de puntos atrapados de f
#
function drawtrappedpointsC!(f, rrImg; hasescaped=hasescapedB02C, maxiterations=100, cs=colorschemes[:jet])
    
    H, W = size(rrImg.img)
    
    for h in 1:H
        for w in 1:W
            
            z = pixeltocomplex(rrImg, w, h)
            
            n = maxiterations
            
            for k in 0:maxiterations
            
                if hasescaped(z)
                    n = k
                    break
                end # if hasescaped
                
                z = f(z)
            end # for k
            
            pixel!(rrImg, w, h, cs[n/maxiterations])
            
        end # for w
    end # for h
    
    rrImg
end


#
# Dibujo del conjunto de Mandelbrot (el asociado a la familia q_c(z)=z^2+c)
#
function drawMandelbrot!(rrImg; maxiterations=100, cs=colorschemes[:jet])
    
    H, W = size(rrImg.img)
    
    for h in 1:H
        for w in 1:W
            
            c = pixeltocomplex(rrImg, w, h)
            n = maxiterations
            z = 0
            
            for k in 0:maxiterations
            
                if abs2(z) > 4
                    n = k
                    break
                end # if hasescaped
                
                z = z^2 + c
            end # for k
            
            pixel!(rrImg, w, h, cs[n/maxiterations])
            
        end # for w
    end # for h
    
    rrImg
end


#
# Dibujo del conjunto de Mandelbrot generalizado de una familia P(c,z) con sus
# puntos críticos crits(c)
#
function drawgeneralMandelbrotC!(P, crits, rrImg; maxiterations=100, cs=colorschemes[:jet], R2=4)
    
    H, W = size(rrImg.img)
    
    for h in 1:H
        for w in 1:W
            
            c = pixeltocomplex(rrImg, w, h)
            zs = crits(c)
            n = maxiterations
            
            for z in zs
                for k in 0:maxiterations
            
                    if abs2(z) > R2
                        n = min(n,k)
                        break
                    end # if hasescaped
                
                    z = P(c,z)
                end # for k
            end # for zs
            
            pixel!(rrImg, w, h, cs[n/maxiterations])
            
        end # for w
    end # for h
    
    rrImg
end
