package csv.core
{
	public class Loger
	{
		public function Loger()
		{
		}
		
		private static var _loger:Function;
		public static function init(value:Function):void{
			
			_loger=value;
		}
		
		
		public static function log(message:*,level:int=0):void{
			
			if(_loger!=null){
				_loger(message,level);
			}
			
		}
	}
}