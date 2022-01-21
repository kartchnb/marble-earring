include<shape_lib/2d.scad>



module Earring_Generate()
{
    difference()
    {
        union()
        {
            Earring_GenerateBody();
            Earring_GenerateHookRing();
            Earring_GenerateBall();
            Earring_GenerateStuds();
        }

        Earring_GenerateInsideCutout();
    }
}



module Earring_GenerateBody()
{
    rotate_extrude(angle=360)
        Earring_GenerateCrossSection();
}



module Earring_GenerateCrossSection()
{
    middle_diameter = Ring_Inner_Diameter + (Ring_Outer_Diameter - Ring_Inner_Diameter)/2;
    ring_angle = asin(Ring_Width/Ring_Inner_Diameter)*2;
    edge_diameter = Wall_Thickness;
    edge_offset = Ring_Outer_Diameter * Ridge_Ratio;
    
    rotate([0, 0, 90])
    {
        // Create the main cross-section of the ring
        difference()
        {
            ShapeLib_Semicircle(angle=ring_angle, d=Ring_Outer_Diameter);
            circle(d=Ring_Inner_Diameter);
        }

        // Round the edges of the ring
        for (edge_angle = [-ring_angle/2, 0, ring_angle/2])
        rotate([0, 0, edge_angle])
        translate([0, middle_diameter/2 + (edge_diameter - Wall_Thickness)/2])
        hull()
        {
            circle(d=edge_diameter);
            translate([0, edge_offset])
                circle(d=edge_diameter);
        }
    }
}



module Earring_GenerateHookRing()
{
    offset = Ring_Outer_Diameter/2 + Hook_Diameter/2 + Slide_Spacing + Ring_Outer_Diameter*Ridge_Ratio/2;

    translate([0, offset, 0])
    rotate_extrude(angle=360)
    translate([Wall_Thickness/2 + Hook_Diameter/2, 0])
        circle(d=Wall_Thickness);
}



module Earring_GenerateBall()
{
    diameter = Ring_Outer_Diameter * Ball_Ratio;
    offset = -Ring_Inner_Diameter/2;

    translate([0, offset, 0])
        sphere(d=diameter);
}



module Earring_GenerateStuds()
{
    for (angle = [0: 30: 150])
    for (flip = [0, 1])
        mirror([flip, 0, 0])
        rotate([0, 0, angle])
            Earring_GenerateStud();
}



module Earring_GenerateStud()
{
    diameter = Ring_Outer_Diameter * Stud_Ratio;
    offset = -Ring_Outer_Diameter/2;

    translate([0, offset, 0])
        sphere(d=diameter);
}



module Earring_GenerateInsideCutout()
{
    difference()
    {
        translate([0, 0, -Ring_Outer_Diameter])
            cylinder(d=Ring_Outer_Diameter, h=Ring_Outer_Diameter*2);

        Earring_GenerateBody();
    }
}