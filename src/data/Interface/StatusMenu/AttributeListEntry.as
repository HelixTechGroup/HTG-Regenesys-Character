package
{
	import Shared.AS3.BSContainerEntry;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol472")]
   public class AttributeListEntry extends BSContainerEntry
   {
      public static const BLE_ATTR:String = "Attribute";
      
      public static const BLE_DIVIDER:String = "Divider";
      
      public var Attribute_mc:AttributeEntry;
      
      public function AttributeListEntry()
      {
         super();
      }
      
      public function StatusListEntry() : *
      {
         stop();
      }
      
      override public function SetEntryText(param1:Object) : void
      {
         this.Attribute_mc.SetEntry(param1);
      }
      
      override public function onRollover() : void
      {
      }
      
      override public function onRollout() : void
      {
      }
   }
}

