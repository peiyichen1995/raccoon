H = 0.3;
h = 0.005;
l = 2e-2;
L = 4;
c = 0.2;

Point(1) = {-L/2, -L/2, 0, H};
Point(2) = {-c, h/8, 0, h};
Point(3) = {-c, -h/8, 0, h};
Point(4) = {-L/2, L/2, 0, H};
Point(5) = {L/2, L/2, 0, H};
Point(6) = {c, h/8, 0, h};
Point(7) = {c, -h/8, 0, h};
Point(8) = {L/2, -L/2, 0, H};

Point(9) = {-L/4, 0, 0, h};
Point(10) = {L/4, 0, 0, h};

//circle points
Point(11) = {-3*L/8, 0, 0, H};
Point(12) = {-L/8, 0, 0, h};
Point(13) = {3*L/8, 0, 0, H};
Point(14) = {L/8, 0, 0, h};

//refinement region
Point(15) = {-L/8, l, 0, h};
Point(16) = {-L/8, -l, 0, h};
Point(17) = {L/8, l, 0, h};
Point(18) = {L/8, -l, 0, h};


Line(1) = {1, 4};
Line(2) = {4, 5};
Line(3) = {5, 8};
Line(4) = {8, 1};
Line(5) = {2, 6};
Line(6) = {3, 7};
Line(7) = {15, 17};
Line(8) = {16, 18};


Line Loop(1) = {1, 2, 3, 4};
//Line Loop(2) = {5, 6, 7, 8}; 


Circle(11) = {11, 9, 12};
Circle(12) = {12, 9, 11};

Circle(13) = {13, 10, 14};
Circle(14) = {14, 10, 13};

Curve Loop(3) = {11, 12};
Curve Loop(4) = {13, 14};


Plane Surface(1) = {1,3,4};
Line{5, 6, 7, 8} In Surface {1};
//Line{9, 10} In Surface {1};

Physical Surface("all") = {1};
Physical Line("top") = {2};
Physical Line("bottom") = {4};
Physical Line("left") = {1};
Physical Line("right") = {3};
Physical Line("crack") = {5,6,7,8};

