using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class ADrawable extends Ui.Drawable {

    hidden var mBackColor;
    hidden var mBorderColor;
    hidden var mCenterX;
    hidden var mCenterY;
    hidden var mFont;

    function initialize(params)
    {
        Drawable.initialize(params);

//        var dictionary = {
//            :identifier => "ciqLayoutsDrawable"
//        };

        mCenterX = params.get(:center_x);
        mCenterY = params.get(:center_y);
        mFont = params.get(:font);
    }

    function setBackColor(color) {
        mBackColor = color;
    }

    function setBorderColor(color) {
        mBorderColor = color;
    }

    function draw(dc) {
        dc.setColor(Gfx.COLOR_TRANSPARENT, mBorderColor);
        dc.clear();
        dc.setColor(mBackColor,mBackColor);
//var height = Gfx.getFontHeight(mFont);
//var width = Gfx.getFontWidth(mFont);
var dims = dc.getTextDimensions("888", mFont);
Sys.println("TEXT w,h: " + dims[0] + "," + dims[1]);
//        dc.fillCircle(mCenterX,mCenterY,mFont);
    }

}
