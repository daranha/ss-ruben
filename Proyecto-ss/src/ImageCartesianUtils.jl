
pointtopixel(x, y, xmin, xmax, ymin, ymax, width, height) =
  Int64(round((x - xmin)*(width  - 1)/(xmax - xmin) + 1)),
  Int64(round((ymax - y)*(height - 1)/(ymax - ymin) + 1))

complextopixel(z, xmin, xmax, ymin, ymax, width, height) =
  Int64(round((real(z) - xmin)*(width  - 1)/(xmax - xmin) + 1)),
  Int64(round((ymax - imag(z))*(height - 1)/(ymax - ymin) + 1))
  
pixeltopoint(w, h, width, height, xmin, xmax, ymin, ymax) =
  (w      - 1)*(xmax - xmin)/(width - 1) + xmin,
  (height - h)*(ymax - ymin)/(height -1) + ymin  

pixeltocomplex(w, h, width, height, xmin, xmax, ymin, ymax) =
  complex( (w      - 1)*(xmax - xmin)/(width - 1) + xmin,
           (height - h)*(ymax - ymin)/(height -1) + ymin  )



# Regresa una imagen de tamaño width x height de color de fondo bgcolor,
# representando el rectángulo [xmin,xmax]x[ymin,ymax], con ejes cartesianos de color fgcolor.
function createcartesianplane(; bgcolor=RGB(1,1,1), fgcolor=RGB(0,0,0), width=500, height=500,
    xmin=-2, xmax=2, ymin=-2, ymax=2)
    
    img = fill(bgcolor, height, width)
    
    cpw, cph = pointtopixel(0,0,xmin,xmax,ymin,ymax,width,height)
    
    if 1 <= cph <= height # verificando que la coordenada de pixel no quede fuera de la imagen
        for w in 1:width
            img[cph,w] = fgcolor
        end
    end
    
    if 1 <= cpw <= width # verificando que la coordenada de pixel no quede fuera de la imagen
        for h in 1:height
            img[h,cpw] = fgcolor   
        end
    end
    
    img
end


# Dibuja una curva parametrizada en una imagen que representa una región rectangular [xmin,xmax]x[ymin,ymax].
function drawcurve!(img, curve, tdom=0:0.01:1; color=RGB(0,0,0), xmin=-2, xmax=2, ymin=-2, ymax=2)
    height, width = size(img)
    for t in tdom
        x,y = curve(t)
        if xmin <= x <= xmax && ymin <= y <= ymax # Verificando que el punto está en la región
            w,h = pointtopixel(x, y, xmin, xmax, ymin, ymax, width, height)
            img[h,w] = color
        end
    end
    img
end
