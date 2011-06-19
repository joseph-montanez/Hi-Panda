public class Panda : Darkcore.Sprite {
    public double velocity_x { get; set; default = 0.00; }
    public double velocity_y { get; set; default = 0.00; }
    public double tile_width { get; set; default = 0.06640625; }
    public double tile_height { get; set; default = 0.0859375; }
    public bool jumping { get; set; default = true; }
    public Darkcore.Vector? jumping_from;
    
    public Panda (ref Darkcore.Engine engine) {
        base.from_file (engine, "resources/Panda_ClausKruuskopf.png");
        world = engine;
        x = 17;
        y = 22;
        width = 17;
        height = 22;
        velocity_y = -1.00;
        anima_normal();

        this.on_render = ((engine, player) => {
            
            anima_normal ();
            
            var gravity = 1.0;
            velocity_y -= gravity;
        
            // The down arrow produces -4, greater then gravities -1
            // If this happens they will be sitting, if not jumping.
            if (!jumping && velocity_y < -gravity) {
                anima_sit ();
            }
            
            // Prevent the player from twitching back and forth
            if (velocity_x < 1.50 && velocity_x > -1.50) {
                velocity_x = 0.00;
            }
            // If they are not jumping then only apply surface friction?
            else if (velocity_x > 0.00 && !jumping) {
                velocity_x -= 1.00;
            }
            else if (velocity_x < 0.00 && !jumping) {
                velocity_x += 1.00;
            }
            // If they are jumping then only apply wide friction?
            else if (velocity_x < 0.00 && jumping) {
                velocity_x += 0.35;
            }
            else if (velocity_x > 0.00 && jumping) {
                velocity_x -= 0.35;
            }
            
            // Check the x-axis
            if (x + velocity_x + (width / 2) >= engine.width) {
                velocity_x = 0;
            }
            else if (x + velocity_x - (width / 2) <= 0) {
                velocity_x = 0;
            }
            
            jumping = true;
            
            // Check the y-axis
            if (y + velocity_y + (height / 2) >= engine.height) {
                velocity_y = 0;
            }
            else if (y + velocity_y - (height / 2) <= 0) {
                jumping = false;
                velocity_y = 0;
                jumping_from = new Darkcore.Vector(2);
                jumping_from.set (0, x);
                jumping_from.set (1, y);
            }
            
            // Check Blocks for collision   
            var state = (GameState) engine.gamestate;
            var hit = false;
            foreach (var block in state.blocks) {
                var bounding_box1 = block.get_bounding_box();
                var bounding_box2 = get_bounding_box(velocity_x, velocity_y);
                var bounding_box3 = get_bounding_box();
                
                hit = 
                    (bounding_box1.get (0) < bounding_box2.get (2) &&
                     bounding_box1.get (2) > bounding_box2.get (0) &&
                     bounding_box1.get (1) < bounding_box2.get (3) &&
                     bounding_box1.get (3) > bounding_box2.get (1));
                if (hit) {
                    // Make the character kiss the right side the block
                    if (
                        velocity_x != 0.00 &&
                        bounding_box3.get (2) > bounding_box1.get (2) &&
                        bounding_box3.get (3) < bounding_box1.get (3)
                       ) {
                        velocity_x = 0;
                        x = bounding_box1.get (2) + (width / 2); 
                    }
                    // Make the character kiss the left side the block
                    else if (
                        bounding_box3.get (0) < bounding_box1.get (0) &&
                        bounding_box3.get (3) < bounding_box1.get (3)
                       ) {
                        velocity_x = 0;
                        x = bounding_box1.get (0) - (width / 2); 
                    }
                    // Make the character kiss the top the block
                    else if (block.y > y) {
                        // TODO:
                        // This will cause a bug if the gravity is set 
                        // higher
                        velocity_y = -gravity;
                        velocity_y = 0;
                        y = bounding_box1.get(1) - (height / 2); 
                    }
                    // Make the character kiss the bottom the block
                    else if (block.y < y) {
                        velocity_y = 0;
                        y = bounding_box1.get(3) + (height / 2); 
                        jumping_from = new Darkcore.Vector(2);
                        jumping_from.set (0, x);
                        jumping_from.set (1, y);
                        jumping = false;
                    }
                    break;
                }
            }
            
            if (velocity_x > 0.00) {
                anima_right ();
            }
            else if (velocity_x < 0.00) {
                anima_left ();
            }
            
            y += velocity_y;
            x += velocity_x;
            
            // Make the camera follow the player!
            engine.camera_x = -(x - engine.width / 2.00);
            engine.camera_y = -(y - engine.height / 2.00);
        });
        this.on_key_press = ((engine, player) => {
            if (jumping && jumping_from != null && y - jumping_from.get (1) >= 20) {
                jumping_from = null;
            }
            if (engine.keys.w && jumping_from != null && y - jumping_from.get (1) < 20) {
               velocity_y += 1;
            }
            if (engine.keys.s) {
                velocity_y -= 2;
            }
            if (engine.keys.d && velocity_x < 9) {
                velocity_x += 3;
            }
            if (engine.keys.a && velocity_x > -9) {
                velocity_x -= 3;
            }
            if (velocity_x > 9.00) {
                velocity_x = 9.00;
            }
            else if (velocity_x < -9.00) {
                velocity_x = -9.00;
            }
        });    
    }
    
    public void anima_tile (int x, int y) {
        coords_top_left_x     = 0.00 + (tile_width * x);
        coords_top_left_y     = 0.00 + (tile_height * y);
        coords_bottom_left_x  = tile_width + (tile_width * x);
        coords_bottom_left_y  = 0.00 + (tile_height * y);
        coords_bottom_right_x = tile_width + (tile_width * x);
        coords_bottom_right_y = tile_height + (tile_height * y);
        coords_top_right_x    = 0.00 + (tile_width * x);
        coords_top_right_y    = tile_height + (tile_height * y);
    }
    
    public void anima_flip() {
        var tmp_top_left_x     = this.coords_top_left_x;
        var tmp_top_left_y     = this.coords_top_left_y;
        var tmp_bottom_left_x  = this.coords_bottom_left_x;
        var tmp_bottom_left_y  = this.coords_bottom_left_y;
        var tmp_bottom_right_x = this.coords_bottom_right_x;
        var tmp_bottom_right_y = this.coords_bottom_right_y;
        var tmp_top_right_x    = this.coords_top_right_x;
        var tmp_top_right_y    = this.coords_top_right_y;
        
        this.coords_top_left_x     = tmp_bottom_left_x;
        this.coords_top_left_y     = tmp_bottom_left_y;
        this.coords_bottom_left_x  = tmp_top_left_x;
        this.coords_bottom_left_y  = tmp_top_left_y;
        this.coords_bottom_right_x = tmp_top_right_x;
        this.coords_bottom_right_y = tmp_top_right_y;
        this.coords_top_right_x    = tmp_bottom_right_x;
        this.coords_top_right_y    = tmp_bottom_right_y;
    }
    
    public void anima_normal () {
        anima_tile (0, 0);
    }
    
    public void anima_sit () {
        anima_tile (1, 2);
    }
    
    public void anima_right () {
        anima_tile (3, 3);
    }
    
    public void anima_left () {
        anima_right ();
        anima_flip ();
    }
}
