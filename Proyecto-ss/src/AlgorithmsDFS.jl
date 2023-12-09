
# Generador de un arreglo de arreglos conteniendo las listas de índices permitidos
function createindexesnotinverse(numgens::Int)
    inotinverse = []
    numtrans = 2numgens
    for k in 1:numtrans
        kinv = ((k + numgens - 1) % numtrans) + 1 # índice correspondiente a la inversa
        push!(inotinverse, append!(collect(kinv+1:numtrans), collect(1:(kinv-1)))) # índices que no corresponden a la inversa
    end
    inotinverse
end


# Functions diversas para dibujo, recibiendo color (útil en algoritmos DFS)

function drawpoints(Z::Vector, c, r::Real=0.02)
    setcolor(c)
    for z in Z
        circle(point(z), r, :fill)
    end
end

function drawdrsticklercolor(coords::Vector, c)
    setcolor(c)    
    drawdrstickler(coords)
end

function drawcircles(Z::Vector, c)
    setcolor(c)
    for c in Z
        c isa Circ ? drawcircle(c) : drawline(c)
    end
end

function drawdiscs(Z::Vector, c)
    setcolor(c)    
    for c in Z
        circle(point(c.center), c.radius, :fill)
    end
end

function drawpearls(Z::Vector, c)
    pblend = createindrablend(c)
    for c in Z
        drawpearl(c, pblend=pblend)
    end
end


# Functions de criterios de "terminación del recoorido de la rama del árbol (gráfica de Cayley)".

function terminationbranchpoints(Z::Vector, index::Int, level::Int, ε::Real=0.001)
    abs2(Z[1]-Z[end]) < ε # Si la distancia entre el primer punto y el último es muy pequeña regresar verdadero
end

function terminationbranchcircles(Z::Vector, index::Int, level::Int, ε::Real=0.001)
    terminate = true
    for c in Z
        if c isa Circ
            terminate &= c.radius < ε # Operador &: true & true = true, false & X = false
        else
            return false
        end
    end
    terminate
end


# Dibujo de la órbita de conjuntos de puntos o circulos o Dr Stickler, usando DFS
function draworbitDFSrecursive(generators::Vector, Z::Vector; maxlevel::Int=8,
        terminationbranch::Function=terminationbranchpoints,
        draw::Function=drawpoints, colormap::ColorScheme=colorschemes[:jet])
# Paso 1: "inicialización"
    numgenerators = length(generators)
    transformations = deepcopy(generators) # Para no modificar la lista de generadores original
    append!(transformations, [ inverse(T) for T in generators ]) # Arreglo de generadores y sus inversas
    numtransformations = length(transformations)    
    indexesnotinverse = createindexesnotinverse(numgenerators)
        
    # ¡Function dentro de function! y además es recursiva...
    function traverseforward(Z::Vector, index::Int, level::Int)
        if terminationbranch(Z, index, level) # Criterio de terminación de recorrido de la rama externo
            return
        end

        draw(Z, colormap[level/maxlevel]) # Function draw externa para dibujar el conjunto Z
    
        if level >= maxlevel # Criterio de terminación de recursión, con maxlevel externo
            return 
        end
    
        for k in indexesnotinverse[index] # Recorrido con vuelta a la izquierda, indexesnoinverse externo
            traverseforward(transformations[k].(Z), k, level+1) # Recursión, transformations externo
        end
    end
        
# Paso 2: Nivel 0
    draw(Z, colormap[0.0]) # Dibujar nivel 0
    if maxlevel == 0 # Si solo se quiere dibujar el nivel 0 salir...
        return
    end 
        
# Paso 3: recursión a los siguientes niveles, empezando por eln nivel 1 con las n ramas que salen de Id
    for k in 1:numtransformations
        traverseforward(transformations[k].(Z), k, 1)
    end
end


# Dibujo de órbitas de discos emparejados al estilo Schottky, usando DFS
# generators = [a,b], discs = [CA, CB, Ca, Cb]
function drawdiscsarrayorbitDFSrecursive(generators::Vector, discs::Vector; maxlevel::Int=8,
        terminationbranch::Function=terminationbranchpoints,
        draw::Function=drawdiscs, colormap::ColorScheme=colorschemes[:jet])
# Paso 1: "inicialización"
    numgenerators = length(generators)
    transformations = deepcopy(generators) # Para no modificar la lista de generadores original
    append!(transformations, [ inverse(T) for T in generators ]) # Arreglo de generadores y sus inversas
    numtransformations = length(transformations)
    indexesnotinverse = createindexesnotinverse(numgenerators)
            
    # ¡Function dentro de function! y además es recursiva...
    function traverseforward(T::AbstractMobiusTransformation, index::Int, level::Int)
        Z = T.(discsdistr[index])
        
        if terminationbranch(Z, index, level) # Criterio de terminación de recorrido de la rama externo
            return
        end
    
        draw(Z, colormap[level/maxlevel]) # Function draw externa para dibujar el conjunto Z

        if level >= maxlevel # Criterio de terminación de recursión, con maxlevel externo
            return 
        end
    
        for k in indexesnotinverse[index] # Recorrido con vuelta a la izquierda, indexesnoinverse externo
            traverseforward(T∘transformations[k], k, level+1) # Recursión, transformations externo
        end
    end
        
# Paso 2: Nivel 0
    draw(discs, colormap[0.0]) # Dibujar nivel 0
    if maxlevel == 0 # Si solo se quiere dibujar el nivel 0 salir...
        return
    end 

# Paso 2.5: Creando el arreglo de arreglo de discos correctos
    discsdistr = []
    for k in 1:length(discs)
        push!(discsdistr, [])
        for j in 1:length(discs)
            if j != k
                push!(discsdistr[k], discs[j])
            end
        end
    end

# Paso 3: recursión a los siguientes niveles, empezando por las N ramas que salen de Id
    for k in numtransformations:-1:1
        traverseforward(transformations[k], k, 1)
    end
end


#Dibujo del conjunto límite como puntos fijos de las transformaciones, usando DFS.
# generators = [a,b]
function drawfixedpointslimitsetDFSrecursive(generators::Vector; maxlevel::Int=8,
        colormap::ColorScheme=colorschemes[:jet], onlyfinal::Bool=true, r::Real=0.01)
# Paso 1: "inicialización"
    numgenerators = length(generators)
    transformations = deepcopy(generators) # Para no modificar la lista de generadores original
    append!(transformations, [ inverse(T) for T in generators ]) # Arreglo de generadores y sus inversas
    numtransformations = length(transformations)
    indexesnotinverse = createindexesnotinverse(numgenerators)
            
    # ¡Function dentro de function! y además es recursiva...
    function traverseforward(T::AbstractMobiusTransformation, index::Int, level::Int)
        setcolor(colormap[level/maxlevel])
        for z in fixedpoints(T)
            circle(point(z), r, :fill)
        end

        if level >= maxlevel # Criterio de terminación de recursión, con maxlevel externo
            return 
        end
    
        for k in indexesnotinverse[index] # Recorrido con vuelta a la izquierda, indexesnoinverse externo
            traverseforward(T∘transformations[k], k, level+1) # Recursión, transformations externo
        end
    end
    
    # ¡Function dentro de function! y además es recursiva...
    function traverseforwardonlyfinal(T::AbstractMobiusTransformation, index::Int, level::Int)    
        if level >= maxlevel # Criterio de terminación de recursión, con maxlevel externo
            setcolor(colormap[(index-1)/(numtransformations)])
            for z in fixedpoints(T)
                circle(point(z), r, :fill)
            end
            return 
        end
    
        for k in indexesnotinverse[index] # Recorrido con vuelta a la izquierda, indexesnoinverse externo
            traverseforwardonlyfinal(T∘transformations[k], k, level+1) # Recursión, transformations externo
        end
    end 
    
    tf = onlyfinal ? traverseforwardonlyfinal : traverseforward
        
# Paso 2: Nivel 0,
# No hay nivel 0

# Paso 3: recursión a los siguientes niveles, empezando por las N ramas que salen de Id
    for k in numtransformations:-1:1
        tf(transformations[k], k, 1)
    end
end

