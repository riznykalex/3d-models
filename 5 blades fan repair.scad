// === Параметри вентилятора (тонкі лопаті для 5В мотора) ===
blades = 5;                         
hub_radius = 27;                    
shaft_radius = 24;                  
fan_radius = 52.5;                  
blade_length = fan_radius - hub_radius;

height = 14;                        // Зменшена товщина лопаті
twist = 40
;                       // Менший кут крутки для тонших лопатей

// === Параметри лопаті (тонші) ===
blade_overlap = 2;                 
blade_base_width = 8;             // Вдвічі менше, ніж раніше
blade_mid_width = 5;
blade_tip_width = 2;

// === Перевірка втулки ===
wall_thickness = hub_radius - shaft_radius;
if (wall_thickness < 2)
    echo("⚠️ Увага: тонка втулка (", wall_thickness, " мм)");

// === Модуль лопаті ===
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

// === Повна модель вентилятора ===
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