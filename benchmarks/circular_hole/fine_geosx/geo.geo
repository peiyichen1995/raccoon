// Gmsh project created on Fri Jul 10 19:56:12 2020

L = 1;
R = 0.50;
h = 0.05;
H = 0.05;
sq = 0.70710678118;

Point(1) = {-1.5*L, -1.5*L, 0, H};
Point(2) = {-1.5*L,  1.5*L, 0, H};
Point(3) = { 1.5*L,  1.5*L, 0, H};
Point(4) = { 1.5*L, -1.5*L, 0, H};
Point(5) = { 0,  0, 0, H};
Point(6) = {-sq*R,  sq*R, 0, h};
Point(7) = { sq*R, -sq*R, 0, h};
Point(8) = { sq*R,  sq*R, 0, h};
Point(9) = {-sq*R, -sq*R, 0, h};

Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};
Circle(5) = {6,5,8};
Circle(6) = {8,5,7};
Circle(7) = {7,5,9};
Circle(8) = {9,5,6};
Line(9) = {2,6};
Line(10) = {9,1};
Line(11) = {7,4};
Line(12) = {8,3};

Transfinite Line {1,2,3,4} = 200 Using Progression 1;
Transfinite Line {5,6,7,8} = 200 Using Progression 1;
Transfinite Line {9,10,11,12} = 200 Using Progression 1;

Line Loop(13) = {1, 9, -8, 10};
Ruled Surface(14) = {13};
Transfinite Surface {14} = {1, 6, 9, 2};
Recombine Surface {14};

Line Loop(15) = {2, -12, -5, -9};
Ruled Surface(16) = {15};
Transfinite Surface {16} = {2, 3, 8, 6};
Recombine Surface {16};

Line Loop(17) = {3, -11, -6, 12};
Ruled Surface(18) = {17};
Transfinite Surface {18} = {3, 4, 7, 8};
Recombine Surface {18};

Line Loop(19) = {4, -10, -7, 11};
Ruled Surface(20) = {19};
Transfinite Surface {20} = {4, 1, 7, 9};
Recombine Surface {20};


//Line Loop(1) = {1, 2, 3, 4};
//Curve Loop(2) = {5,6,7,8};
//Plane Surface(2) = {1, 2};

out[] = Extrude {0, 0, 1} {Surface{14,16,18,20}; Layers{1}; Recombine;};

//Physical Volume("all") = {1,2,3,4};
//Physical Surface("top") = {51};
//Physical Surface("circle") = {37,59,81,103};

