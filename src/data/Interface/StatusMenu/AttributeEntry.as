package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;

   public class AttributeEntry extends MovieClip
   {
      public static const TIMER_PADDING:Number = 16;

      public var Name_mc:MovieClip;

      public var Value_mc:MovieClip;

      // public var Desc_mc:MovieClip;

      public function AttributeEntry()
      {
         super();
         this.Name_tf.autoSize = TextFieldAutoSize.LEFT;
         // this.Value_tf.autoSize = TextFieldAutoSize.LEFT;
         // this.Desc_tf.multiline = true;
         // this.Desc_tf.wordWrap = true;
         // this.Desc_tf.autoSize = TextFieldAutoSize.LEFT;
      }

      public function get Name_tf():TextField
      {
         return this.Name_mc.Text_tf;
      }

      public function get Value_tf():TextField
      {
         return this.Value_mc.Text_tf;
      }

      // public function get Desc_tf() : TextField
      // {
      // return this.Desc_mc.Text_tf;
      // }

      public function SetEntry(param1:Object):*
      {
         // var _loc3_:String = null;
         // var _loc4_:String = null;
         // var _loc2_:* = param1.sDescription.length > 0;

         gotoAndStop("Attribute");
         // if (_loc2_) {
         // _loc3_ = param1.sDescription.charAt(0);//!!param1.bPermanent ? "" : GlobalFunc.FormatTimeString(param1.fTimeRemaining);
         // }
         // if(!_loc2_ && _loc3_.length == 0)
         // {
         // GlobalFunc.SetText(this.Name_tf,param1.sName,true,true,42);
         // }
         // else
         // {
         GlobalFunc.SetText(this.Name_tf, param1.sName, true, true, 35);
         GlobalFunc.SetText(this.Value_tf, param1.sDescription);
         // var _loc5_:* = this.Name_tf.textWidth < 12;
         // if (_loc5_) {
         var _loc6_:Number = (12 - this.Name_tf.length);
         // GlobalFunc.SetText(this.Value_tf,param1.sDescription);
         this.Value_mc.x += TIMER_PADDING; // this.Name_mc.x + 5 + this.Name_tf.textWidth + TIMER_PADDING;
         // } else {
         // this.Value_mc.x = this.Name_mc.x + this.Name_tf.textWidth + TIMER_PADDING;
         // }
         // }
         // if(_loc2_)
         // {
         // if(param1.sDescription.charAt(0) == "%")
         // {
         // _loc4_ = param1.sDescription.replace(/[\%]/g,"");
         // GlobalFunc.SetText(this.Desc_tf,_loc4_,true);
         // }
         // else
         // {
         // GlobalFunc.SetText(this.Desc_tf,param1.sDescription,true);
         // }
         // }
         // var _loc3_:String = null;
         // var _loc4_:String = null;
         // var _loc2_:* = param1.sDescription.length > 0;

         // gotoAndStop("Attribute");
         // GlobalFunc.SetText(this.Name_tf,param1.sName,true,true,42);
         // GlobalFunc.SetText(this.Value_tf,param1.sDescription,true);
         // if(_loc2_)
         // {
         // if(param1.sDescription.charAt(0) == "%")
         // {
         // _loc4_ = param1.sDescription.replace(/[\%]/g,"");
         // GlobalFunc.SetText(this.Desc_tf,_loc4_);
         // }
         // else
         // {
         // GlobalFunc.SetText(this.Desc_tf,param1.sDescription,true);
         // }
         // }
      }
   }
}