package csv
{
	import csv.core.Loger;
	
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.filesystem.File;

	public class Protogen
	{
		public function Protogen()
		{
		}
		
		public static function progress(callBack:Function,...args):void{						
			var exe:File = File.applicationDirectory.resolvePath("assets/exe/protobuf-net/protogen.exe");
			
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();//启动参数
			info.executable = new File(exe.nativePath);
			var processArg:Vector.<String> = new Vector.<String>();
			
			var len:int=args.length;
			
			for(var i:int=0;i<len;i++){
				processArg[i] =args[i];
			}
			
			info.arguments= processArg;
			var process:NativeProcessExt = new NativeProcessExt(callBack);			
			try{			
				process.start(info);
			}catch(error:Error){
				process.dispatch();
				Loger.log(error.message,1);
			}
		}
	}
}