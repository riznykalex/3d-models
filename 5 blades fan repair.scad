// === Fan parameters (thin blades for 5V) ===
blades = 5;                         
hub_radius = 19;                    
shaft_radius = 16.6;                  
fan_radius = 35;                  
blade_length = fan_radius - hub_radius;

height = 10;                        // Reduced blade thickness
twist = 35;                         // Smaller twist angle for thinner blades

// === Blade parameters (thinner) ===
blade_overlap = 2;                 
blade_base_width = 6;              // Half the previous value
blade_mid_width = 3;
blade_tip_width = 1.6;

// === Hub thickness check ===
wall_thickness = hub_radius - shaft_radius;
if (wall_thickness < 2)
    echo("⚠️ Warning: Thin hub (", wall_thickness, " mm)");

// === Blade module ===
module blade() {
    linear_extrude(height = height, twist = twist)
        polygon(points=[
            [hub_radius - blade_overlap, -blade_base_width/2],
            [hub_radius + blade_length * 0.4, -blade_mid_width/2],
            [hub_radius + blade_length, -blade_tip_width/2],
            [hub_radius + blade_length, blade_tip_width/2],
            [hub_radius + blade_length * 0.4, blade_mid_width/2],
            [hub_radius - blade_overlap, blade_base_width/2]
        ]);
}

// === Complete fan model ===
module fan_with_hub() {
    difference() {
        union() {
            cylinder(h = height, r = hub_radius, $fn = 100);
            for (i = [0 : 360/blades : 360 - 360/blades]) {
                rotate([0,0,i])
                    blade();
            }
        }
        cylinder(h = height + 0.1, r = shaft_radius, $fn = 100);
    }
}

fan_with_hub();
