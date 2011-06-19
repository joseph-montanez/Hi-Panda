public class Paddle : Darkcore.Sprite {
    public string up { get; set; default = "up"; }
    public string down { get; set; default = "down"; }
    
    public Paddle (ref Darkcore.Engine engine) {
        world = engine;
        this.x += 32;
        this.y += 100;
        this.height = 100;
        this.on_key_press = ((engine, player) => {
            var x = 0;
            var y = 0;
            if (up == "up" && engine.keys.up || up == "w" && engine.keys.w) {
                y += 4;
            }
            if (down == "down" && engine.keys.down || down == "s" && engine.keys.s) {
                y -= 4;
            }
            if (this.x + x + (width / 2) >= engine.width) {
                x = 0;
            }
            else if (this.x + x - (width / 2) <= 0) {
                x = 0;
            }
            if (this.y + y + (height / 2) >= engine.height) {
                y = 0;
            }
            else if (this.y + y - (height / 2) <= 0) {
                y = 0;
            }
            
            this.y += y;
        });    
    }
}
