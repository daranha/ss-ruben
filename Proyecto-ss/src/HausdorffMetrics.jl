
function distancepointtocompactR2(p,imgB,d=dE_R2)
    
    height, width = size(imgB.img)
    
    dmin = Inf
                
    for h in 1:height # Recorriendo otra vez la imagen, para encontrar min{d(p,q):q∈B}
        for w in 1:width

            # Si el punto está en B
            pix = pixel(imgB, w, h)
            if red(pix) + green(pix) + blue(pix) < 0.001
                q = pixeltopoint(imgB, w, h)
                        
                dis = d(p,q)
                        
                if dis < dmin # dmin aproximandose a la distancia mínima...
                    dmin = dis
                end
            end # if q ∈ B
        end # for width
    end # for height
    
    dmin # distancia de p a B
end


function distancecomplextocompactC(z,imgB,d=dE_C)
    
    height, width = size(imgB.img)
    
    dmin = Inf
                
    for h in 1:height # Recorriendo otra vez la imagen, para encontrar min{d(p,q):q∈B}
        for w in 1:width

            # Si el punto está en B                        
            pix = pixel(imgB, w, h)
            if red(pix) + green(pix) + blue(pix) < 0.001
                q = pixeltocomplex(imgB,w,h)
                        
                dis = d(z,q)
                        
                if dis < dmin # dmin aproximandose a la distancia mínima...
                    dmin = dis
                end
            end # if q ∈ B
        end # for width
    end # for height
    
    dmin # distancia de p a B
end


function distancecompactsR2(imgA,imgB,d=dE_R2)
    
    if size(imgA.img) != size(imgB.img)
        println("Las imagenes proporcionadas no son del mismo tamaño.")
        return
    end

    height, width = size(imgA.img)
    
    dmax = 0
                
    for h in 1:height # Recorriendo la imagen imgA
        for w in 1:width

            # Si el punto está en A
            pix = pixel(imgA,w,h)
            if red(pix) + green(pix) + blue(pix) < 0.001
                
                p = pixeltopoint(imgA,w,h)
                        
                dmin = distancepointtocompactR2(p,imgB,d)
                        
                if dmin > dmax # dmin aproximandose a la distancia mínima...
                    dmax = dmin
                end
            end # if q ∈ A
        end # for width
    end # for height
    
    dmax # distancia de A a B
end


function distancecompactsC(imgA,imgB,d=dE_C)
    
    if size(imgA.img) != size(imgB.img)
        println("Las imagenes proporcionadas no son del mismo tamaño.")
        return
    end

    height, width = size(imgA.img)
    
    dmax = 0
                
    for h in 1:height # Recorriendo la imagen imgA
        for w in 1:width

            # Si el punto está en A
            pix = pixel(imgA,w,h)
            if red(pix) + green(pix) + blue(pix) < 0.001
                
                p = pixeltocomplex(imgA,w,h)
                        
                dmin = distancecomplextocompactC(p,imgB,d)
                        
                if dmin > dmax # dmin aproximandose a la distancia mínima...
                    dmax = dmin
                end
            end # if q ∈ A
        end # for width
    end # for height
    
    dmax # distancia de A a B
end


distanceHausdorffR2(imgA,imgB,d=dE_R2) =
  max(
    distancecompactsR2(imgA,imgB,d),
    distancecompactsR2(imgB,imgA,d)
  )
  
distanceHausdorffC(imgA,imgB,d=dE_C) =
  max(
    distancecompactsC(imgA,imgB,d),
    distancecompactsC(imgB,imgA,d)
  )

