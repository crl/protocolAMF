package csv.proto
{
	import mx.utils.StringUtil;
	
	public class ProtoParser
	{
		static public function  ParseMessages(text:String):ProtoMessage
		{
			var list:Array=text.split("\n");
			var message:String=""
			for(var i:int=0;i<list.length;i++){
				var t:String=list[i];
				if(StringUtil.trim(t)==""){
					continue;
				}
				message+=list[i]+"\n";
			}
			
			var tr:TokenReader=new TokenReader(message);
			
			while (true)
			{
				var token:String = tr.readNextComment();
				if (ParseComment(token)){
					continue;
				}
				
				switch (token)
				{
					case ";":
						break;
					case "message":
						return ParseMessage(tr,null);
						break;
					
					default:
						var m:ProtoMessage= ParseMessage(tr,token);
						m.isImpl=true;
						return m;
						
						break;
				}
			}
			
			return null;
		}
		
		private static function ParseMessage(tr:TokenReader,name:String):ProtoMessage{
			var msg:ProtoMessage=new ProtoMessage();	
			
			if(!name){
				name=tr.readNext();
			}
			msg.name=name;
			
			tr.readNextOrThrow("{");
			
			while(ParseField(tr,msg)){
				continue;
			}
			
			return msg;
		}
		
		
		private static function ParseComment(token:String):Boolean{
			if (token.indexOf("//")==0)
			{
				return true;
			}
			if (token.indexOf("/*")==0)
			{
				return true;
			}
			return false;
		}
		
		private static function ParseField(tr:TokenReader,msg:ProtoMessage):Boolean{
			var rule:String = tr.readNextComment();
			while (true)
			{
				if (ParseComment(rule) == false)
					break;
				rule = tr.readNextComment();
			}
			
			var type:String;
			switch (rule)
			{
				case ";":
					return true;
				case "}":
					return false;
				case "required":
				case "optional":
				case "repeated":
					break;
				case "s":
					type="string";
					rule="required";
					break;
				case "i":
				case "l":
				case "long":
					type="int32";
					rule="required";
					break;
				case "b":
					type="bool";
					rule="required";
					break;
				case "f":
					type="float";
					rule="required";
				case "n":
					type="float";
					rule="required";
					break;
				case "o":
				case "g":
				case "bytes":
					type="bytes";
					rule="required";
					break
				
				default :
					var b:Boolean=true;
					switch(rule.charAt(0)){
						case "+":
							type=rule.substr(1);
							rule="required";
							b=false;
							break;
						case "-":
							type=rule.substr(1);
							rule="optional";
							b=false;
							break;
						case "*":
							type=rule.substr(1);
							rule="repeated";
							b=false;
							break;
					}
					if(b){
						return true;
					}
			}
			
			var f:ProtoField=new ProtoField();
			msg.fields.push(f);
			f.rule=rule;
			
			if(!type){
				type=tr.readNext();
			}else{
				switch(type)
				{
					case "s":
						type="string";
						break;
					case "i":
					case "l":
					case "long":
						type="int32";
						break;
					case "b":
						type="bool";
						break;
					case "f":
						type="float";
					case "n":
						type="float";
						break;
					case "o":
					case "g":
					case "bytes":
						type="bytes";
						break;
					default:
					{
						break;
					}
				}
			}
			f.type=type;
			f.name=tr.readNext();
			
			var text:String=tr.readNext(true);
			if(!text || text==""){
				f.id=msg.fields.length;
				return true;
			}
			
			if(text == "="){
				f.id=tr.readNumber(true);
			}else if(ParseComment(text)){
				f.desc=extra.substr(2);
			}
			
			var extra:String = tr.readNextComment(true);
			if (extra == ";"){
				extra =tr.readLine();
			}else if(extra=="}"){
				return false;
			}
			if(ParseComment(extra)){
				f.desc=extra.substr(2);
			}
			
			return true;
		}
	}
}