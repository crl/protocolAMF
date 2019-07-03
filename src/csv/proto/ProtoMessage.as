package csv.proto
{
	public class ProtoMessage
	{
		public var name:String;
		
		//是否是一个proto的扩展语法;
		public var isImpl:Boolean=false;
		
		public var fields:Vector.<ProtoField>=new Vector.<ProtoField>();
		public function ProtoMessage()
		{
		}
		
		
		public function getRaw():String{
			var m:String="message "+this.name+"{\r\n";
			
			for each(var item:ProtoField in fields){
				m+=item.rule+" "+item.type+" "+item.name+"="+item.id+";";
				if(item.desc){
					m+="//"+item.desc;
				}
				m+="\r\n";
			}
			
			m+="}\r\n";
			return m;
		}
	}
}