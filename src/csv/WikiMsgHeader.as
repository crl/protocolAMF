package csv
{
	import csv.proto.ProtoField;
	import csv.proto.ProtoMessage;
	import csv.proto.ProtoParser;
	import csv.proto.Type2Number;
	
	import flash.globalization.StringTools;
	
	import mx.utils.StringUtil;
	
	public class WikiMsgHeader
	{
		private static var shortNameReg:RegExp = /(\w*)_c|(\w*)_s/i;
		
		public var raw:String;
		
		public var cmd:String;
		public var name:String;
		public var desc:String;
		public var sName:String;
		public var lsName:String;
		
		public var fields:Vector.<ProtoField>=new Vector.<ProtoField>();
		
		
		public static function create(cmd:String,desc:String,name:String):WikiMsgHeader
		{
			var msg:WikiMsgHeader = new WikiMsgHeader();
			msg.cmd = cmd;
			msg.desc = desc;
			msg.name = name;
			
			var result:Object = shortNameReg.exec(name);
			if(result != null)
			{
				msg.name=result[0];
				if(result[1])
				{
					msg.sName = result[1];
				}else{
					msg.sName = result[2];
				}
			}else{
				msg.sName=name;
			}
			msg.lsName =  Type2Number.LowerFist(msg.sName);
			
			return msg;
		}
		
		public function get isServer():Boolean{
			return name.toLowerCase().lastIndexOf("_s") != -1;
		}
		public function get isClient():Boolean{
			return name.toLowerCase().lastIndexOf("_c") != -1;
		}
		
		public function parserRaw(content:String):void
		{
			this.raw=content;
			var message:ProtoMessage=ProtoParser.ParseMessages(content);
			if(message){	
				this.fields=message.fields;
				if(message.isImpl){
					message.name=this.name;
					this.raw=message.getRaw();
				}
			}
		}
	}
}