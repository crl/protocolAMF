package csv.tpl
{
	import csv.WikiMsgHeader;

	public class TplDataVO
	{
		public var cl:Vector.<WikiMsgHeader>;
		public var sl:Vector.<WikiMsgHeader>;
		
		public var al:Vector.<WikiMsgHeader>;
		
		public var dl:Vector.<WikiMsgHeader>;
		
		public var ns:Vector.<String>;
		
		public var name:String;
		
		public var url:String;
		
		public var isS:Boolean;
		
		public function TplDataVO()
		{
		}
		
		public function clone():TplDataVO{
			var data:TplDataVO=new TplDataVO();
			data.cl=this.cl;
			data.sl=this.sl;
			
			data.al=this.al;
			data.dl=this.dl;
			
			data.name=this.name;
			data.ns=this.ns;
			data.url=this.url;
			return data;
		}
	}
}