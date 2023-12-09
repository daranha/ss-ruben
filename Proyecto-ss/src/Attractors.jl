
#
# Determinista
#

function drawdeterministicattractorR2(ifs, K, rrB, rrA; ignoredcolor=RGB(1,1,1))
    
    rrBk = deepcopy(rrB) # Bk = B, para k = 0
    
    for k = 1:K
    
        H, W = size(rrBk.img)
 
        # Se crea una región rectangular donde se irán guardando las nuevas iteraciones del operador W
        rrWBk = RectangularRegion(rrA.xmin,rrA.xmax,rrA.ymin,rrA.ymax,width=width(rrA.img),height=height(rrA.img),color=ignoredcolor)
    
        for h in 1:H # Recorriendo la imagen
            for w in 1:W
            
                color = pixel(rrBk, w, h)

                # Si el punto está en Bk
                if color != ignoredcolor
                    p = pixeltopoint(rrBk, w, h)
                    
                    for wn in ifs
                        q = wn(p)
                
                        if containspoint(rrWBk, q)
                            pixq = pointtopixel(rrWBk, q)
                            pixel!(rrWBk, pixq, color)
                        end # if q=wn(p) ∈ WBk
                    end # for wn ∈ ifs
                end # if p ∈ Bk
            end # for width
        end # for height
    
        rrBk = deepcopy(rrWBk) # La reasignación requiere una copia profunda
    end # for k
    
    rrBk
end


function drawdeterministicattractorC(ifs, K, rrB, rrA; ignoredcolor=RGB(1,1,1))
    
    rrBk = deepcopy(rrB) # Bk = B, para k = 0
    
    for k = 1:K

        H, W = size(rrBk.img)
        
        # Se crea una región rectangular donde se irán guardando las nuevas iteraciones del operador W
        rrWBk = RectangularRegion(rrA.xmin,rrA.xmax,rrA.ymin,rrA.ymax,width=width(rrA.img),height=height(rrA.img),color=ignoredcolor)
        
        for h in 1:H # Recorriendo la imagen
            for w in 1:W
            
                color = pixel(rrBk, w, h)

                # Si el punto está en rrBk
                if color != ignoredcolor
                    p = pixeltocomplex(rrBk, w, h)
                    
                    for wn in ifs
                        q = wn(p)
                
                        if containscomplex(rrWBk, q)
                            pixq = complextopixel(rrWBk, q)
                            pixel!(rrWBk, pixq, color)
                        end # if q=wn(p) ∈ rrWBk
                    end # for wn ∈ ifs
                end # if p ∈ Bk
            end # for width
        end # for height
    
        rrBk = deepcopy(rrWBk)
    end # for k
    
    rrBk
end


#
# Juego del Caos, o de iteraciones aleatorias
#

function drawchaosgameattractorR2!(ifs, rrA; numiterations=100000, p0=[0,0], color=RGB(0,0,0))
    
    pn = p0
    
    for k = 1:numiterations
        
        n = rand(1:length(ifs))
        
        pn = ifs[n](pn)

        if containspoint(rrA, pn)
            pix = pointtopixel(rrA, pn)
            pixel!(rrA, pix, color)
        end # if pn ∈ A

    end # for k
    
    rrA
end


function drawchaosgameattractorC!(ifs, rrA; numiterations=100000, z0=0, color=RGB(0,0,0))
    
    zn = z0
    
    for k = 1:numiterations
        
        n = rand(1:length(ifs))
        
        zn = ifs[n](zn)

        if containscomplex(rrA, zn)
            pix = complextopixel(rrA, zn)
            pixel!(rrA, pix, color)
        end # if zn ∈ A

    end # for k
    
    rrA
end


function drawchaosgameattractorcolorsR2!(ifs, rrA, colors; numiterations=100000, p0=[0,0])
    
    if length(colors) < length(ifs)
        println("Faltan colores en la lista...")
        return
    end    
    
    pn = p0
    
    for k = 1:numiterations
        
        n = rand(1:length(ifs))
        
        pn = ifs[n](pn)

        if containspoint(rrA, pn)
            pix = pointtopixel(rrA, pn)
            pixel!(rrA, pix, colors[n])
        end # if pn ∈ A

    end # for k
    
    rrA
end


function drawchaosgameattractorcolorsC!(ifs, rrA, colors; numiterations=100000, z0=0)

    if length(colors) < length(ifs)
        println("Faltan colores en la lista...")
        return
    end    
    
    zn = z0
    
    for k = 1:numiterations
        
        n = rand(1:length(ifs))
        
        zn = ifs[n](zn)

        if containscomplex(rrA, zn)
            pix = complextopixel(rrA, zn)
            pixel!(rrA, pix, colors[n])
        end # if zn ∈ A

    end # for k
    
    rrA
end

