import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Time;

class omnitrixView extends WatchUi.WatchFace {

    private function getDayOfWeek(now) {
        var dayNames = [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ];
        return dayNames[((now.value / 86400) + 4) % 7];
    }

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.Properties.getValue("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
        var secondsString = clockTime.sec.format("%02d");

        // Date string
        var today = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$, $3$", [today.day_of_week, today.day.format("%02d"), today.year]);

        // Heart rate logic
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;
        var circleRadius = width * 0.18;
        var circleX = centerX + width * 0.25;
        var circleY = centerY;

        var hr = null;
        var zoneColor = Graphics.COLOR_WHITE;
        var activity = Activity.getActivityInfo();
        if (activity != null && activity.currentHeartRate != null) {
            hr = activity.currentHeartRate;
            // Calculate heart rate zone color
            var maxHr = 225; // Approximate max heart rate
            var percent = (hr * 100) / maxHr;
            if (percent < 60) {
                zoneColor = Graphics.COLOR_BLUE; // Resting
            } else if (percent < 70) {
                zoneColor = Graphics.COLOR_GREEN; // Light
            } else if (percent < 80) {
                zoneColor = Graphics.COLOR_YELLOW; // Moderate
            } else if (percent < 90) {
                zoneColor = Graphics.COLOR_ORANGE; // Hard
            } else {
                zoneColor = Graphics.COLOR_RED; // Maximum
            }
        }

        // Draw the background circle (custom drawing, not in layout)
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
        dc.fillCircle(circleX, circleY, circleRadius);

        // Update layout elements
        var timeLabel = View.findDrawableById("TimeLabel") as WatchUi.Text;
        if (timeLabel != null) { timeLabel.setText(timeString); }

        var secondsLabel = View.findDrawableById("SecondsLabel") as WatchUi.Text;
        if (secondsLabel != null) { secondsLabel.setText(secondsString); }

        var dateLabel = View.findDrawableById("DateLabel") as WatchUi.Text;
        if (dateLabel != null) { dateLabel.setText(dateString); }

        var heartRateLabel = View.findDrawableById("HeartRateLabel") as WatchUi.Text;
        var hrText = (hr != null) ? hr.toString() : "--";
        if (heartRateLabel != null) { heartRateLabel.setText(hrText); }

        // var stepsLabel = View.findDrawableById("StepsLabel") as WatchUi.Text;
        // var stepsText = (steps != null) ? steps.toString() : "--";
        // if (stepsLabel != null) { stepsLabel.setText(stepsText); }

        // Update the heart icon
        var heartIcon = View.findDrawableById("HeartIcon") as WatchUi.Drawable;
        var stepsIcon = View.findDrawableById("StepsIcon") as WatchUi.Drawable;

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
