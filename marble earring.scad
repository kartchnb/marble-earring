/* [General Parameters] */
// The diameter of the marble that will be used
Marble_Diameter = 16.001;

// The diameter of the earring hook
Hook_Diameter = 2.001;

// The size ratio of the ring ridges
Ridge_Ratio = 0.031;

// The size ratio of the ball at the bottom of the earring
Ball_Ratio = 0.401;

// The size ratio of the studs running along the earring
Stud_Ratio = 0.101;



/* [Model Generation] */
// Generate refences models for external hardware?
Generate_Reference_Models = true;



/* [Advanced] */
// The amount that the earring *ring* should overlap the marble to hold it in place
Marble_Lip_Size = 0.251;

// The minimum thickness of walls in the model
Wall_Thickness = 1.601;

// The amount of space to allow between parts intended to mate together
Mate_Spacing = 0.101;

// The amount of space to allow between parts intended to slide across or past each other
Slide_Spacing = 0.201;

// The value to use for creating the model preview (lower is faster)
Preview_Quality_Value = 32;

// The value to use for creating the final model render (higher is more detailed)
Render_Quality_Value = 128;



/* [Development Parameters] */
Cross_Section = "none"; // ["none", "x", "y", "z"]



// Calculated parameters

// Use Pythagorean's Theorem to calculate the radial width of the ring
c = Marble_Diameter/2 + Slide_Spacing;
b = c - Marble_Lip_Size;
a = sqrt(c^2 - b^2);
Ring_Width = a*2;

Ring_Inner_Diameter = Marble_Diameter + Slide_Spacing*2;
Ring_Outer_Diameter = Ring_Inner_Diameter + Wall_Thickness*2;



// Include external source files
include<source/earring.scad>
include<source/marble.scad>



module Generate()
{
    Earring_Generate();

    if (Generate_Reference_Models)
    {
        %Marble_Generate();
    }
}



// Global parameters
iota = 0.001;
$fn = $preview ? Preview_Quality_Value : Render_Quality_Value;



// Generate the model
difference()
{
    Generate();

    if (Cross_Section == "x")
        translate([-Marble_Diameter, 0, -Marble_Diameter])
            cube(Marble_Diameter*2);

    else if (Cross_Section == "y")
        translate([0, -Marble_Diameter, -Marble_Diameter])
            cube(Marble_Diameter*2);

    else if (Cross_Section == "z")
        translate([-Marble_Diameter, -Marble_Diameter, 0])
            cube(Marble_Diameter*2);
}
