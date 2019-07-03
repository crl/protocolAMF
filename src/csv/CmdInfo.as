package csv
{
	public class CmdInfo
	{
		public var desc:String;
		public var shortName:String;
		public var cmd:String;
		
		public function CmdInfo(cmd:String)
		{
			this.cmd=cmd;
		}
		
		public function replace(desc:String):void
		{
			if(desc){
				this.desc=desc;
			}
		}
	}
}