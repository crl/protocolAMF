package csv.proto
{
	import flash.utils.Dictionary;

	public class Type2Number
	{
		private static var rules:Dictionary=new Dictionary();
		private static var t:Dictionary=new Dictionary();
		public static function Init():void{
			rules["optional"]=1;
			rules["required"]=2;
			rules["repeated"]=3;
			
			
			t["double"] = 1;
			t["float"] = 2;
			t["int64"] = 3;
			t["uint64"] = 4;
			t["int32"] = 5;
			t["fixed64"] = 6;
			t["fixed32"] = 7;
			t["bool"] = 8;
			t["string"] = 9;
			t["group"] = 10;
			t["message"] = 11;
			t["bytes"] = 12;
			t["uint32"] = 13;
			t["enum"] = 14;
			t["sfixed32"] = 15;
			t["sfixed64"] = 16;
			t["sint32"] = 17;
			t["sint64"] = 18;
		}
		
		public static function UpperFist(value:String):String{
			return value.charAt(0).toUpperCase() + value.substr(1);
		}
		public static function LowerFist(value:String):String{
			return value.charAt(0).toLowerCase() + value.substr(1);
		}
		
		public static function GetRuleType(v:String):int{
			if(rules.hasOwnProperty(v)==false){
				return 1;
			}
			trace(v);
			return rules[v];
		}
		
		public static function FormatField(fields:Vector.<ProtoField>):Object
		{
			var result:Object={};
			for each(var field:ProtoField in fields){
				
				var type:int = Type2Number.GetType(field.type);
				var def:Object = field.options.deft;
				if (def !== null) {
					var t:String = typeof def;
					if (t === "object") {//不支持对象类型默认值
						def = null;
					}
				}
				
				var list:Array=[field.name,Type2Number.GetRuleType(field.rule),type];
				
				if (type == 0) {// message类型不支持默认值
					type = 11;// message
					list[2]=type;
					list[3]=field.type;
				} else if (def !== null) {
					list[3]=null;
					list[4]=def;
				}
				
				result[field.id]=list;
			}
			return result;
		}
		
		public static function GetType(v:String):int{

			if(t.hasOwnProperty(v)==false){
				return 0;
			}
			return  t[v];
		}
	}
}