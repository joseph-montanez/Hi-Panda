public class Gun : Darkcore.Sprite {
    public double velocity_x { get; set; default = 0.00; }
    public double velocity_y { get; set; default = 0.00; }
    public bool jumping { get; set; default = true; }
    public bool has_gun { get; set; default = false; }
    public Darkcore.Vector? jumping_from;
    public Panda? parent;
    
    public Gun (Darkcore.Engine engine, Panda panda) {
        base.from_texture(engine, 1);
        this.parent = panda;
        
        this.width = 32;
        this.height = 32;
        
        this.on_key_press = (engine, self) => {
            if (engine.keys.mouse_left) {
                print("POW\n");
                var bullet = new Bullet();
                bullet.x = panda.x;
                bullet.y = panda.y;
                engine.sprites.add(bullet);
            }  
        };
        
        this.on_render = (engine, self) => {
            // Who ever said Pythagoras' Theorem is pointless!
            var a = engine.get_abs_mouse_x() - parent.x;
            var b = engine.get_abs_mouse_y() - parent.y;
            var c = Math.pow(a, 2) + Math.pow(b, 2);
            c = Math.sqrt(c);
            var radians = Math.sin(b / c);
            var degrees = radians * 57.2957795;
            
            this.coords_top_left_x     = 0.00;
            this.coords_top_left_y     = 0.00;
            this.coords_bottom_left_x  = 0.25;
            this.coords_bottom_left_y  = 0.00;
            this.coords_bottom_right_x = 0.25;
            this.coords_bottom_right_y = 0.25;
            this.coords_top_right_x    = 0.00;
            this.coords_top_right_y    = 0.25;
            
            if (a >= 0.00 && b >= 0.00) {
                degrees = degrees + 360.00;
            } 
            else if (a <= 0.00 && b >= 0.00) {
                degrees = 360.00 - degrees;
            } 
            else if (a <= 0.00 && b <= 0.00) {
                degrees = 360.00 - degrees;
            }
            else if (a >= 0.00 && b <= 0.00) {
                degrees = degrees + 360.00;
            }
            parent.anima_right();
            if (a < 0.00) {
                parent.anima_flip();
                this.anima_flip();
            }
            var mod_x = (parent.width / 2 * Math.cos(radians)) - (0 / 2 * Math.sin(radians));
            var mod_y = (parent.width / 2 * Math.sin(radians)) + (0 / 2 * Math.cos(radians));
            this.x = a < 0.00 ? parent.x - parent.width / 2 - mod_x * 2 : parent.x + parent.width / 2 + mod_x * 2;
            this.y = parent.y + mod_y * 2;
            
            this.rotation = degrees;
        };
    }
}
