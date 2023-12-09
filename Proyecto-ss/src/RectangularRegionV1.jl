
# Región rectangular [xmin,xmax]x[ymin,ymax] representada por img
struct RectangularRegion
    xmin
    xmax
    ymin
    ymax
    img

    RectangularRegion(x1, x2, y1, y2, img0) = new(x1, x2, y1, y2, img0)
    
    RectangularRegion(x1, x2, y1, y2; width=500, height=500, color=RGB(1,1,1)) =
      new(x1, x2, y1, y2, fill(color, height, width))    
end


# Functions útiles para trabajar con una RectangularRegion
draw(rectreg) = rectreg.img

lengthx(rectreg) = rectreg.xmax - rectreg.xmin
lengthy(rectreg) = rectreg.ymax - rectreg.ymin

pixel(rectreg, w, h) = rectreg.img[h,w]
pixel(rectreg, pix) = rectreg.img[pix[2],pix[1]]

function pixel!(rectreg, w, h, color)
    rectreg.img[h,w] = color
end

function pixel!(rectreg, pix, color)
    rectreg.img[pix[2],pix[1]] = color
end

# Conversiones entre coordenadas de puntos en R2 o C y pixeles de imagen.
pointtopixel(rectreg, x, y) =
  Int64(round((x - rectreg.xmin)*(width(rectreg.img)  - 1)/(rectreg.xmax - rectreg.xmin) + 1)),
  Int64(round((rectreg.ymax - y)*(height(rectreg.img) - 1)/(rectreg.ymax - rectreg.ymin) + 1))

pointtopixel(rectreg, p) =
  Int64(round((p[1] - rectreg.xmin)*(width(rectreg.img)  - 1)/(rectreg.xmax - rectreg.xmin) + 1)),
  Int64(round((rectreg.ymax - p[2])*(height(rectreg.img) - 1)/(rectreg.ymax - rectreg.ymin) + 1))

complextopixel(rectreg, z) =
  Int64(round((real(z) - rectreg.xmin)*(width(rectreg.img)  - 1)/(rectreg.xmax - rectreg.xmin) + 1)),
  Int64(round((rectreg.ymax - imag(z))*(height(rectreg.img) - 1)/(rectreg.ymax - rectreg.ymin) + 1))

pixeltopoint(rectreg, w, h) =
  [(w      - 1)*(rectreg.xmax - rectreg.xmin)/(width(rectreg.img) - 1) + rectreg.xmin,
  (height(rectreg.img) - h)*(rectreg.ymax - rectreg.ymin)/(height(rectreg.img) -1) + rectreg.ymin ]

  
pixeltopoint(rectreg, pix) =
  [(pix[1]      - 1)*(rectreg.xmax - rectreg.xmin)/(width(rectreg.img) - 1) + rectreg.xmin,
  (height(rectreg.img) - pix[2])*(rectreg.ymax - rectreg.ymin)/(height(rectreg.img) -1) + rectreg.ymin ]

pixeltocomplex(rectreg, w, h) =
  complex( (w      - 1)*(rectreg.xmax - rectreg.xmin)/(width(rectreg.img) - 1) + rectreg.xmin,
           (height(rectreg.img) - h)*(rectreg.ymax - rectreg.ymin)/(height(rectreg.img) -1) + rectreg.ymin )

pixeltocomplex(rectreg, pix) =
  complex( (pix[1]      - 1)*(rectreg.xmax - rectreg.xmin)/(width(rectreg.img) - 1) + rectreg.xmin,
           (height(rectreg.img) - pix[2])*(rectreg.ymax - rectreg.ymin)/(height(rectreg.img) -1) + rectreg.ymin )
           
           
# Dibujar ejes coordenados
function drawaxes!(rectreg; color=RGB(0,0,0))
    cpw, cph = pointtopixel(rectreg, 0, 0)
    H, W = size(rectreg.img)
    
    if 1 <= cph <= H # verificando que la coordenada de pixel no quede fuera de la imagen
        for w in 1:W
            rectreg.img[cph,w] = color
        end
    end
    
    if 1 <= cpw <= W # verificando que la coordenada de pixel no quede fuera de la imagen
        for h in 1:H
            rectreg.img[h,cpw] = color   
        end
    end
    
    rectreg
end


# Verificaciones de pertenencia de puntos, complejos o pixeles a regiones rectangulares
containspoint(rr, p) = ( (rr.xmin < p[1] < rr.xmax) && (rr.ymin < p[2] < rr.ymax))

containspoint(rr, x, y) = ( (rr.xmin < x < rr.xmax) && (rr.ymin < y < rr.ymax))

containscomplex(rr, z) = ( (rr.xmin < real(z) < rr.xmax) && (rr.ymin < imag(z) < rr.ymax))

containspixel(rr, pix) = ( (1 <= pix[1] <= width(rr.img)) && (1 <= pix[2] <= height(rr.img)) )

containspixel(rr, w, h) = ( (1 <= w <= width(rr.img)) && (1 <= h <= height(rr.img)) )

