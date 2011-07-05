using GL;

public class Bullet : Darkcore.Sprite {
    public Bullet () {
        base();
        color_r = 0;
        color_g = 0;
        color_b = 0;
    }
    
    public override void on_render () {
        x += 1.25;
        if (x > 100) {
        	world.remove_sprite(this); //sprites.remove_at(world.sprites.size - 1);
        }
    }
    
    public override void render () {

        glPushMatrix ();
        glTranslated (x, y, 0.00);
        
        if (scale_x != 1.00 || scale_y != 1.00) {
            glScaled (scale_x, scale_y, 1.00);
        }
        
        if (rotation != 0.00) {
            glRotated (rotation, 0.00, 0.00, 1.00);
        }
        
        glColor3ub ((GLubyte) color_r, (GLubyte) color_g, (GLubyte) color_b);
        
        glLineWidth ((GL.GLfloat) 3.00);
        
        glBegin(GL_LINE);
        glVertex2d(x - 4, y - 4);
        glVertex2d(x + 4, y + 4);
        glEnd ();
        
        glPopMatrix ();
    } 
}
