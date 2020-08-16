H = 0.3;
h = 0.005;
l = 1e-3;
L = 4;
c = 0.2;

Point(1) = {-L/2, -L/2, 0, H};
//Point(2) = {-c, 0, 0, h};
//Point(3) = {0, -l, 0, h};
Point(4) = {-L/2, L/2, 0, H};
Point(5) = {L/2, L/2, 0, H};
//Point(6) = {c, 0, 0, h};
//Point(7) = {0, l, 0, h};
Point(8) = {L/2, -L/2, 0, H};

Point(9) = {-L/4, 0, 0, h};
Point(10) = {L/4, 0, 0, h};

//circle points
Point(11) = {-3*L/8, 0, 0, H};
Point(12) = {-L/8, l, 0, h};
Point(15) = {-L/8, -l, 0, h};
Point(13) = {3*L/8, 0, 0, H};
Point(14) = {L/8, l, 0, h};
Point(16) = {L/8, -l, 0, h};

Line(1) = {1, 4};
Line(2) = {4, 5};
Line(3) = {5, 8};
Line(4) = {8, 1};
Line(5) = {12, 14};
//Line(6) = {3, 14};
Line(7) = {16, 15};
//Line(8) = {7, 15};
//Line(9) = {9, 2};
//Line(10) = {6, 10};

Line Loop(1) = {1, 2, 3, 4};
//Line Loop(2) = {5, 6, 7, 8}; 


Circle(11) = {11, 9, 12};
Circle(12) = {15, 9, 11};

Circle(13) = {13, 10, 14};
Circle(14) = {16, 10, 13};

Curve Loop(3) = {11, 5, -13, -14, 7, 12};
//Curve Loop(4) = {13, 14};


Plane Surface(1) = {1,3};
//Line{5, 6, 7, 8} In Surface {1};
//Line{6, 8} In Surface {1};
//Line{9, 10} In Surface {1};

Physical Surface("all") = {1};
Physical Line("top") = {2};
Physical Line("bottom") = {4};
Physical Line("left") = {1};
Physical Line("right") = {3};
Physical Line("crack_top") = {5};
Physical Line("crack_bottom") = {7};

