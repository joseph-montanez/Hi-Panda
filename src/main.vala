public class GameState : Object {
    public unowned Panda panda;
    public Gee.ArrayList<Darkcore.Sprite> blocks;
    
    public GameState () {
        base();
        blocks = new Gee.ArrayList<Darkcore.Sprite>();
    }
}

public class GameDemo : Object {
    public static int main (string[] args) {
        var engine = new Darkcore.Engine(640, 480);
        var state = new GameState();
        engine.gamestate = state;
        
        engine.add_texture ("resources/font.png");
        engine.add_texture ("resources/Weapons_ThyLordRoot.png");
        
        var text = new Darkcore.SpriteNS.Text.from_texture(engine, 0);
        text.set_text ("Hello World!"); // Testing
        text.on_render = (engine, self) => {
            int fps = engine.frames_per_second;
            text.data = @"Frames per second: $fps";
        };
        engine.sprites.add (text);
        
        var block1 = new Darkcore.Sprite();
        block1.color_r = 1;
        block1.width = 100;
        block1.height = 100;
        block1.x = 300;
        block1.y = 100;
        engine.sprites.add(block1);
        state.blocks.add(block1);
        
        var block2 = new Darkcore.Sprite();
        block2.color_r = 1;
        block2.width = 100;
        block2.height = 15;
        block2.x = 100;
        block2.y = 50;
        engine.sprites.add(block2);
        state.blocks.add(block2);
        
        var block3 = new Darkcore.Sprite();
        block3.color_r = 50;
        block3.color_g = 50;
        block3.color_b = 0;
        block3.width = engine.width;
        block3.height = 20;
        block3.x = engine.width / 2;
        block3.y = -10;
        engine.sprites.add(block3);
        state.blocks.add(block3);
        
        var pandy = new Panda(ref engine);
        pandy.x = engine.width - 32;
        engine.sprites.add (pandy);

        state.panda = pandy;
        

        // Add an event to the renderer
        engine.add_event(Darkcore.EventTypes.Render, () => {
            //player2.x += 0.01;
        });
                
        engine.run ();

        return 0;
    }
}
