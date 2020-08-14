// Gmsh project created on Mon Jul 06 22:56:48 2020
a = 2;
r = 0.0025;

E = 0.2;
e = 0.005;

Point(1) = {-a, -a, 0, E};
Point(2) = {-a, -r, 0, e};
Point(3) = {-a+0.2, -r, 0, e};
Point(4) = {-a+0.2, 0, 0, e};
Point(5) = {-a+0.2, r, 0, e};
Point(6) = {-a, r, 0, e};
Point(7) = {-a, a, 0, E};
Point(8) = {0, a, 0, E};
Point(9) = {0, 5*r, 0, e};
Point(10) = {0, -5*r, 0, e};
Point(11) = {0, -a, 0, E};

Point(12) = {-a+0.2, 5*r, 0, e};
Point(13) = {-a + 0.2, -5*r, 0, e};

Line(1) = {1, 2};
Line(2) = {2, 3};
Circle(3) = {3, 4, 5};
Line(4) = {5, 6};
Line(5) = {6, 7};
Line(6) = {7, 8};
Line(7) = {8, 9};
Line(8) = {9, 10};
Line(9) = {10, 11};
Line(10) = {11, 1};
Line(11) = {12, 9};
Line(12) = {13, 10};
Line Loop(1) = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

Plane Surface(1) = {1};
Line{11, 12} In Surface {1};

Physical Surface("all") = {1};
Physical Line("top") = {6};
Physical Line("bottom") = {10};
Physical Line("left") = {1, 5};
Physical Line("right") = {7, 8, 9};
Physical Line("crack_top") = {4};
Physical Line("crack_bottom") = {2};