public class GameState : Object {
    public unowned Panda panda;
    
    public GameState () {
        base();
    }
}

public class GameDemo : Object {
    public static int main (string[] args) {
        var engine = new Darkcore.Engine(640, 480);
        var state = new GameState();
        
        engine.add_texture ("resources/font.png");
        
        var text = new Darkcore.SpriteNS.Text.from_texture(engine, 0);
        text.set_text ("Hello World!"); // Testing
        text.on_render = (engine, self) => {
            int fps = engine.frames_per_second;
            text.data = @"Frames per second: $fps";
        };
        engine.sprites.add (text);
        
        var pandy = new Panda(ref engine);
        pandy.x = engine.width - 32;
        engine.sprites.add (pandy);

        state.panda = pandy;
        
        engine.gamestate = state;

        // Add an event to the renderer
        engine.add_event(Darkcore.EventTypes.Render, () => {
            //player2.x += 0.01;
        });
                
        engine.run ();

        return 0;
    }
}
