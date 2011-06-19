public class Ball : Darkcore.Sprite {
    public double velocity_x;
    public double velocity_y;
    private bool _paused { get; set; default = false; }
    public double acceleration {
        get; set; default = 0.100;
    }
    public unowned Darkcore.Sprite? left_paddle { get; set; default = null; }
    public unowned Darkcore.Sprite? right_paddle { get; set; default = null; }
    
    public Ball (ref Darkcore.Engine engine) {
        /* TODO: Dificulty, hard = smaller paddle */
        this.left_paddle = null;
        this.right_paddle = null;
        base.from_file (engine, "resources/ball.png");
        
        this.width = 64.00;
        this.height = 64.00;
        
        /* Place the ball in the middle of the screen */
        this.reset_location (engine);
        
        /* Set the inital ball velocity */
        this.velocity_x = 4.00;
        this.velocity_y = 4.00;
        
        this.on_render = (engine, ball) => {
            var gamestate = (GameState) engine.gamestate;
            var half_height = height / 2.00;
            var half_width = width / 2.00;
            
            /* If the ball goes beyound top of the window */
            if (y + half_height + velocity_y >= engine.height) {
                velocity_y = -Math.fabs(velocity_y);
            }
            /* If the ball goes beyound bottom of the window */
            if (y - half_height - velocity_y <= 0) {
                velocity_y = Math.fabs(velocity_y);
            }
            /* If the ball goes beyound right of the window */
            if (x + half_width + velocity_x >= engine.width) {
                velocity_x = -Math.fabs(velocity_x);
                /* The right player loses if this happens */
                gamestate.player1_add_point ();
                gamestate.fire_score ();
            }
            /* If the ball goes beyound left of the window */
            if (x - half_width - velocity_x <= 0) {
                velocity_x = Math.fabs(velocity_x);
                /* The left player loses if this happens */
                gamestate.player2_add_point ();
                gamestate.fire_score ();
            }
            
            /* Test for each paddle for collision */
            for (var i = 0; i < 2; i++) {
                unowned Darkcore.Sprite? paddle = null;
                
                /* Figure out which paddle we are testing for */
                if (i == 0 && left_paddle != null) {
                    paddle = left_paddle;
                }
                else if (i == 1 && right_paddle != null) {
                    paddle = right_paddle;
                }
                
                if (paddle != null && has_hit_paddle (paddle)) {
                    /* 
                     * This is the left paddle, Inverse the x-axis 
                     * (assume its negitive) and add more acceleration to it  
                     */
                    velocity_x = Math.fabs (velocity_x) + acceleration;
                    /*
                     * If this is the right paddle then we need to invert
                     * the velocity on the x-axis
                     */
                    if (paddle == right_paddle) {
                        velocity_x *= -1;
                    }
                    /* 
                     * Based on the ball's y position and paddle's center y
                     * position, should result in the ball's y axis being
                     * altered  
                     */
                    velocity_y = -((paddle.y - y) / half_height);
                    
                    engine.sounds[1].play ();
                
                }
            }
            
            if (!_paused) {
                /* Add any resulting velocity changes to the ball's position */
                x += velocity_x;
                y += velocity_y;
                
                /* Add a constant rotation */
                rotation += 1.0;
            }
            
            
        };
    }
    
    public void reset_location(Darkcore.Engine engine) {
        /* Place the ball in the middle of the screen */
        this.x = engine.width / 2;
        this.y = engine.height / 2;
    }
    
    public void pause () {
        _paused = true;
    }
    
    public void unpause() {
        _paused = false;
    }
    
    public bool is_paused () {
        return _paused;
    }
    
    public void timed_pause (Darkcore.Engine engine, int ticks) {
        engine.add_timer(() => {
            unpause ();
        }, 3000);
    }
    
    public bool has_hit_paddle (Darkcore.Sprite sprite) {
        var circle_vector = new Darkcore.Vector(2);
        circle_vector.set (0, x);
        circle_vector.set (1, y);
        
        
        var min_vector = new Darkcore.Vector(2);
        var max_vector = new Darkcore.Vector(2);
        
        // Bottom Left
        min_vector.set (0, sprite.x - (sprite.width / 2));
        min_vector.set (1, sprite.y - (sprite.height / 2));
        
        // Top Right
        max_vector.set (0, sprite.x + (sprite.width / 2));
        max_vector.set (1, sprite.y + (sprite.height / 2));
        
        var hit = Darkcore.Collision.circle_in_rectangle (
            min_vector,
            max_vector,
            circle_vector,
            width / 2.00
        );
        
        return hit;
    }
}
