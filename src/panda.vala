using SDL;

public class Panda : Darkcore.Sprite {
    public double velocity_x { get; set; default = 0.00; }
    public double velocity_y { get; set; default = 0.00; }
    public bool jumping { get; set; default = true; }
    public bool has_gun { get; set; default = false; }
    public Darkcore.Vector? jumping_from;
    
    public Panda (ref Darkcore.Engine engine) {
        base.from_file (engine, "resources/Panda_ClausKruuskopf.png");
        tile_width = 0.06640625;
        tile_height = 0.0859375;
        world = engine;
        x = 17;
        y = 22;
        width = 17;
        height = 22;
        velocity_y = -1.00;
        anima_normal(); 
    }
    
    public override void on_render () {
        //anima_normal ();
        
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
        // If they are jumping then only apply wind friction?
        else if (velocity_x < 0.00 && jumping) {
            velocity_x += 0.35;
        }
        else if (velocity_x > 0.00 && jumping) {
            velocity_x -= 0.35;
        }
        
        // Check the x-axis
        if (x + velocity_x + (width / 2) >= world.width) {
            velocity_x = 0;
        }
        else if (x + velocity_x - (width / 2) <= 0) {
            velocity_x = 0;
        }
        
        jumping = true;
        
        // Check the y-axis
        if (y + velocity_y + (height / 2) >= world.height) {
            velocity_y = 0;
        }
        else if (y + velocity_y - (height / 2) <= 0) {
            jumping = false;
            velocity_y = 0;
            y = 0;
            jumping_from = new Darkcore.Vector(2);
            jumping_from.set (0, x);
            jumping_from.set (1, y);
        }
        
        // Check Blocks for collision   
        var state = (GameState) world.gamestate;
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
            //anima_right ();
        }
        else if (velocity_x < 0.00) {
            //anima_left ();
        }
        
        y += velocity_y;
        x += velocity_x;
        
        // Make the camera follow the player!
        world.camera_x = -(x - world.width / 2.00);
        world.camera_y = -(y - world.height / 2.00);
    }

    public override void on_key_press() {
        if (jumping && jumping_from != null && y - jumping_from.get (1) >= 20) {
            jumping_from = null;
        }
        if (world.keys.w && jumping_from != null && y - jumping_from.get (1) < 20) {
           velocity_y += 1;
        }
        if (world.keys.s) {
            velocity_y -= 2;
        }
        if (world.keys.d && velocity_x < 9) {
            velocity_x += 3;
        }
        if (world.keys.a && velocity_x > -9) {
            velocity_x -= 3;
        }
        
        // Ensure Constant Velocity
        if (velocity_x > 9.00) {
            velocity_x = 9.00;
        }
        else if (velocity_x < -9.00) {
            velocity_x = -9.00;
        }
        
        if (world.keys.up && !has_gun) {
            has_gun = true;
            print("up\n");
            var gun = new Gun(world, this);
            world.sprites.add (gun);
        }
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
