
dragonlevy_w1(z) = (exp(im*π/4)/√2)*z
dragonlevy_w2(z) = (exp(-im*π/4)/√2)*z + 0.5+0.5im
dragonlevy_ifs = [dragonlevy_w1, dragonlevy_w2]

dragonheighway_w1(z) = (exp(im*π/4)/√2)*z
dragonheighway_w2(z) = (exp(im*3π/4)/√2)*z + 1
dragonheighway_ifs = [dragonheighway_w1, dragonheighway_w2]

Δsierpinsky_w1(z) = 0.5*z
Δsierpinsky_w2(z) = 0.5*z + 0.5
Δsierpinsky_w3(z) = 0.5*z + 0.5im
Δsierpinsky_ifs = [Δsierpinsky_w1, Δsierpinsky_w2, Δsierpinsky_w3]

fern_w1(p) = [0 0; 0 0.16]*p
fern_w2(p) = [0.85 0.04; -0.04 0.85]*p + [0, 1.6]
fern_w3(p) = [0.2 -0.26; 0.23 0.22]*p + [0, 1.6]
fern_w4(p) = [-0.15 0.28; 0.26 0.24]*p + [0, 0.44]
fern_ifs = [fern_w1, fern_w2, fern_w3, fern_w4]

tree_w1(p) = [0 0; 0 0.5]*p
tree_w2(p) = [0.42 -0.42; 0.42 0.42]*p + [0, 2.1]
tree_w3(p) = [0.42 0.42; -0.42 0.42]*p + [0, 1.9]
tree_w4(p) = [0.1 0.0; 0.0 0.1]*p + [0, 0.2]
tree_ifs = [tree_w1, tree_w2, tree_w3, tree_w4]

αcloud = √2*0.25exp(im*pi/4)
βcloud = √2*0.5exp(-im*pi/4)
cloud_w1(z) = 0.25z
cloud_w2(z) = αcloud*z + 0.25
cloud_w3(z) = βcloud*z + 0.5 + 0.25im
cloud_w4(z) = βcloud*z + 0.25
cloud_w5(z) = αcloud*z + 0.5 - 0.25im
cloud_w6(z) = 0.25z + 0.75
cloud_ifs = [cloud_w1,cloud_w2,cloud_w3,cloud_w4,cloud_w5,cloud_w6]
