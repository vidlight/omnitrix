import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable {

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc as Dc) as Void {
        // Get screen dimensions
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;

        System.println("centerX: " + centerX);
        System.println("centerY: " + centerY);

        // Fill background with red
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
        dc.fillRectangle(0, 0, width, height);

        // Draw two large black triangles to form the hourglass (negative space) on left and right
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        // Left triangle (covers left side)
        dc.fillPolygon([
            [0, 0],
            [0, height],
            [centerX-15, centerY]
        ]);
        // Right triangle (covers right side)
        dc.fillPolygon([
            [width, 0],
            [width, height],
            [centerX+15, centerY]
        ]);
    }

}
