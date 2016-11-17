using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.UserProfile as Profile;

class LayoutsView extends Ui.DataField
{
   /** layouts for different watchface areas */
   const LAYOUT_ALL             = "All";
   const LAYOUT_TOP_HALF        = "TopHalf";
   const LAYOUT_BOT_HALF        = "BotHalf";
   const LAYOUT_TOP_THIRD       = "TopThird";
   const LAYOUT_MID_THIRD       = "MidThird";
   const LAYOUT_LEFT_MID_THIRD  = "LeftMidThird";
   const LAYOUT_RIGHT_MID_THIRD = "RightMidThird";
   const LAYOUT_BOT_THIRD       = "BotThird";
   const LAYOUT_TOP_LEFT_QUAD   = "TopLeftQuad";
   const LAYOUT_TOP_RIGHT_QUAD  = "TopRightQuad";
   const LAYOUT_BOT_LEFT_QUAD   = "BotLeftQuad";
   const LAYOUT_BOT_RIGHT_QUAD  = "BotRightQuad";
   const LAYOUT_UNKNOWN         = "Unknown";

   /** all possible obscurity flag values */
   const UNOBSCURED         = 0;  // 0000
   const OBSCURED_LEFT      = 1;  // 0001
   const OBSCURED_RIGHT     = 4;  // 0100
   const OBSCURED_LR        = 5;  // 0101
   const OBSCURED_TOP       = 2;  // 0010
   const OBSCURED_TOP_LEFT  = 3;  // 0011
   const OBSCURED_TOP_RIGHT = 6;  // 0110
   const OBSCURED_TOP_LR    = 7;  // 0111
   const OBSCURED_BOT       = 8;  // 1000
   const OBSCURED_BOT_LEFT  = 9;  // 1001
   const OBSCURED_BOT_RIGHT = 12; // 1100
   const OBSCURED_BOT_LR    = 13; // 1101
   const OBSCURED_TB        = 10; // 1010
   const OBSCURED_TB_LEFT   = 11; // 1011
   const OBSCURED_TB_RIGHT  = 14; // 1110
   const OBSCURED_ALL     = 15; // 1111

   /** screen dimensions */
   var screenWidth;
   var screenHeight;

   /** monitored heart rate */
   hidden var mHeartRate;

   /** drawable for value */
   hidden var value;

   /*-------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
   function initialize()
   {
      DataField.initialize();

      var deviceSettings = Sys.getDeviceSettings();
      screenWidth = deviceSettings.screenWidth;
      screenHeight = deviceSettings.screenHeight;

      mHeartRate = 0;
   }

   /*-------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
   function onLayout(dc)
   {
      var width = dc.getWidth();
      var height = dc.getHeight();
      var obscurityFlags = DataField.getObscurityFlags();

      var layout = setLayout(dc,screenWidth,screenHeight,width,height,obscurityFlags);

      var layoutId = 1000*obscurityFlags + width + height;
      Sys.println("layout: " + layoutId + " " + layout);

      value = View.findDrawableById("value");

      return true;
   }

   /*-------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    function compute(info)
    {
        // See Activity.Info in the documentation for available information.
        if(info has :currentHeartRate){
            if(info.currentHeartRate != null){
                mHeartRate = info.currentHeartRate;
            } else {
                mHeartRate = 0;
            }
        }
    }

   /*-------------------------------------------------------------------------
    * Display the value you computed here. This will be called
    * once a second when the data field is visible.
    *------------------------------------------------------------------------*/
    function onUpdate(dc)
    {
       dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_GREEN);
       dc.clear();

       dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_WHITE);

       /*
        * Draw the heart rate.
        */
Sys.println("position: " + value.locX + "," + value.locY);
       value.setText(toStr(mHeartRate));
       //        value.setText(mHeartRate.format("%2f"));
       value.setColor(Gfx.COLOR_BLACK);
       value.setBackgroundColor(Gfx.COLOR_TRANSPARENT);
       value.draw(dc);
    }

   /*-------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
   function toStr(o) {
      if (o != null && o > 0) {
         return "" + o;
      } else {
         return "---";
      }
   }

   /*
   ************************
   forerunner layouts
   ------------------------
   all: 215,180 tbLR       = 1 (id=15395)
   ------------------------
   topHalf: 215, 89 tLR    = 2 (id=7304)
   botHalf: 215, 89 bLR    = 3 (id=13304)
   ------------------------
   topThird: 215, 55 tLR   = 4 (id=7270)
   midThird: 215, 66 LR    = 5 (id=5281)
   botThird: 215, 55 bLR   = 6 (id=13270)
   ------------------------
   topThird:  215, 55 tLR
   lMidThird: 107, 66 L    = 7 (id=1173)
   rMidThird: 107, 66 R    = 8 (id=4173)
   botThird:  215, 55 bLR
   ------------------------

   ************************
   fenix/bravo layouts
   ------------------------
   all:       218,218 tbLR = 1 (id=15436)
   ------------------------
   topHalf:   218,108 tLR  = 2 (id=7326)
   botHalf:   218,108 bLR  = 3 (id=13326)
   ------------------------
   topThird:  218, 70 tLR  = 4 (id=7288)
   midThird:  218, 74 LR   = 5 (id=5292)
   botThird:  218, 70 bLR  = 6 (id=13288)
   ------------------------
   topHalf:   218,108 tLR
   blQuad:    108,108 bL   = 9 (id=9216);
   brQuad:    108,108 bR   = 10 (id=12216);
   ------------------------
   topThird:  218, 70 tLR
   lMidThird: 108, 74 L    = 11 (id=1182);
   rMidThird: 108, 74 R    = 12 (id=4182);
   botThird:  218, 70 bLR
   ------------------------
   tlQuad:    108,108 tL   = 7 (id=3216);
   trQuad:    108,108 tR   = 8 (id=6216);
   blQuad:    108,108 bL
   brQuad:    108,108 bR
   ------------------------
   */

   /*-------------------------------------------------------------------------
    * Compact version, optimized for size.
    * Saves about 1kB of run-time memory.
    *------------------------------------------------------------------------*/
   function setLayout(dc,screenWidth,screenHeight,width,height,obscurity)
   {
      var id = 1000*obscurity + width + height;

      if (id == 15395 /*fr*/ || id == 15436 /*fx*/) {
            View.setLayout(Rez.Layouts.All(dc));
      }
      else if (id == 7304 /*fr*/ || id == 7326 /*fx*/) {
            View.setLayout(Rez.Layouts.TopHalf(dc));
      }
      else if (id == 13304 /*fr*/ || id == 13326 /*fx*/) {
            View.setLayout(Rez.Layouts.BotHalf(dc));
      }
      else if (id == 7270 /*fr*/ || id == 7288 /*fx*/) {
            View.setLayout(Rez.Layouts.TopThird(dc));
      }
      else if (id == 5281 /*fr*/ || id == 5292 /*fx*/) {
            View.setLayout(Rez.Layouts.MidThird(dc));
      }
      else if (id == 13270 /*fr*/ || id == 13288 /*fx*/) {
            View.setLayout(Rez.Layouts.BotThird(dc));
      }
      else if (id == 1173 /*fr*/ || id == 1182 /*fx*/) {
            View.setLayout(Rez.Layouts.LeftMidThird(dc));
      }
      else if (id == 4173 /*fr*/ || id == 4182 /*fx*/) {
            View.setLayout(Rez.Layouts.RightMidThird(dc));
      }
      else if (id == 3216 /*fx*/) {
            View.setLayout(Rez.Layouts.TopLeftQuad(dc));
      }
      else if (id == 6216 /*fx*/) {
            View.setLayout(Rez.Layouts.TopRightQuad(dc));
      }
      else if (id == 9216 /*fx*/) {
            View.setLayout(Rez.Layouts.BotLeftQuad(dc));
      }
      else if (id == 12216 /*fx*/) {
            View.setLayout(Rez.Layouts.BotRightQuad(dc));
      }
      else {
            View.setLayout(Rez.Layouts.All(dc));
      }
   }

   /*-------------------------------------------------------------------------
    * Full version, not optimized for size.
    *------------------------------------------------------------------------*/
//   function setLayout(dc,screenWidth,screenHeight,width,height,obscurity)
//   {
//      if (screenWidth == 215 && screenHeight == 180 ) {
//
//         if (obscurity == OBSCURED_ALL) {
//            View.setLayout(Rez.Layouts.All(dc));
//            return LAYOUT_ALL;
//         }
//         else if (obscurity == OBSCURED_TOP_LR && height == 89) {
//            View.setLayout(Rez.Layouts.TopHalf(dc));
//            return LAYOUT_TOP_HALF;
//         }
//         else if (obscurity == OBSCURED_BOT_LR && height == 89) {
//            View.setLayout(Rez.Layouts.BotHalf(dc));
//            return LAYOUT_BOT_HALF;
//         }
//         else if (obscurity == OBSCURED_TOP_LR /* && height == 55*/) {
//            View.setLayout(Rez.Layouts.TopThird(dc));
//            return LAYOUT_TOP_THIRD;
//         }
//         else if (obscurity == OBSCURED_LR) {
//            View.setLayout(Rez.Layouts.MidThird(dc));
//            return LAYOUT_MID_THIRD;
//         }
//         else if (obscurity == OBSCURED_BOT_LR /* && height == 55*/) {
//            View.setLayout(Rez.Layouts.BotThird(dc));
//            return LAYOUT_BOT_THIRD;
//         }
//         else if (obscurity == OBSCURED_LEFT) {
//            View.setLayout(Rez.Layouts.LeftMidThird(dc));
//            return LAYOUT_LEFT_MID_THIRD;
//         }
//         else if (obscurity == OBSCURED_RIGHT) {
//            View.setLayout(Rez.Layouts.RightMidThird(dc));
//            return LAYOUT_RIGHT_MID_THIRD;
//         }
//         else {
//            View.setLayout(Rez.Layouts.All(dc)); // TODO keep?
//            return LAYOUT_UNKNOWN;
//         }
//      }
//      else if (screenWidth == 218 && screenHeight == 218 ) {
//
//         if (obscurity == OBSCURED_ALL) {
//            View.setLayout(Rez.Layouts.All(dc));
//            return LAYOUT_ALL;
//         }
//         else if (obscurity == OBSCURED_TOP_LR && height == 108) {
//            View.setLayout(Rez.Layouts.TopHalf(dc));
//            return LAYOUT_TOP_HALF;
//         }
//         else if (obscurity == OBSCURED_BOT_LR && height == 108) {
//            View.setLayout(Rez.Layouts.BotHalf(dc));
//            return LAYOUT_BOT_HALF;
//         }
//         else if (obscurity == OBSCURED_TOP_LR /* && height == 70*/) {
//            View.setLayout(Rez.Layouts.TopThird(dc));
//            return LAYOUT_TOP_THIRD;
//         }
//         else if (obscurity == OBSCURED_LR) {
//            View.setLayout(Rez.Layouts.MidThird(dc));
//            return LAYOUT_MID_THIRD;
//         }
//         else if (obscurity == OBSCURED_BOT_LR /* && height == 70*/) {
//            View.setLayout(Rez.Layouts.BotThird(dc));
//            return LAYOUT_BOT_THIRD;
//         }
//         else if (obscurity == OBSCURED_LEFT) {
//            View.setLayout(Rez.Layouts.LeftMidThird(dc));
//            return LAYOUT_LEFT_MID_THIRD;
//         }
//         else if (obscurity == OBSCURED_RIGHT) {
//            View.setLayout(Rez.Layouts.RightMidThird(dc));
//            return LAYOUT_RIGHT_MID_THIRD ;
//         }
//         else if (obscurity == OBSCURED_TOP_LEFT) {
//            View.setLayout(Rez.Layouts.TopLeftQuad(dc));
//            return LAYOUT_TOP_LEFT_QUAD;
//         }
//         else if (obscurity == OBSCURED_TOP_RIGHT) {
//            View.setLayout(Rez.Layouts.TopRightQuad(dc));
//            return LAYOUT_TOP_RIGHT_QUAD;
//         }
//         else if (obscurity == OBSCURED_BOT_LEFT) {
//            View.setLayout(Rez.Layouts.BotLeftQuad(dc));
//            return LAYOUT_BOT_LEFT_QUAD;
//         }
//         else if (obscurity == OBSCURED_BOT_RIGHT) {
//            View.setLayout(Rez.Layouts.BotRightQuad(dc));
//            return LAYOUT_BOT_RIGHT_QUAD;
//         }
//         else {
//            View.setLayout(Rez.Layouts.All(dc)); // TODO keep?
//            return LAYOUT_UNKNOWN;
//         }
//      }
//
//      View.setLayout(Rez.Layouts.All(dc)); // TODO keep?
//      return LAYOUT_UNKNOWN;
//   }
}
