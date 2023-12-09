
# Colores aleatorios
randGray() = Gray(rand())
randGrayA() = GrayA(rand(), rand())
randRGB() = RGB(rand(), rand(), rand())
randRGBA() = RGBA(rand(), rand(), rand(), rand())

# Colores con números 0 ... 255
RGB255(n1, n2, n3) = RGB(n1/255, n2/255, n3/255)
RGBA255(n1, n2, n3, n4) = RGB(n1/255, n2/255, n3/255, n4/255)

# Interpolación lineal de valores
linterp(a,b,t) = a + (b - a)*t

# Interpolación de colores
linterpRGB(rgb1, rgb2, t) = RGB(
    linterp(red(rgb1),   red(rgb2),   t),
    linterp(green(rgb1), green(rgb2), t),
    linterp(blue(rgb1),  blue(rgb2),  t))

linterpRGBA(rgb1, rgb2, t) = RGB(
    linterp(red(rgb1),   red(rgb2),   t),
    linterp(green(rgb1), green(rgb2), t),
    linterp(blue(rgb1),  blue(rgb2),  t),
    linterp(alpha(rgb1), alpha(rgb2), t))


