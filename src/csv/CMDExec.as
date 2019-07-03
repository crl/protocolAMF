package csv
{
	import csv.core.Loger;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.filesystem.File;

	public class CMDExec
	{
		public static function progress(callBack:Function,...args):void{
			
			var exe:File=new File("C:/Windows/system32/cmd.exe");
			
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();//启动参数
			info.executable = new File(exe.nativePath);
			var processArg:Vector.<String> = new Vector.<String>();
			
			processArg[0] = "/c";//加上/c，是cmd的参数
			
			var len:int = args.length;
			
			for(var i:int=0 ;i<len;i++){
				processArg.push(args[i]);
			}
			
			info.arguments= processArg;
			var process:NativeProcessExt = new NativeProcessExt(callBack);	
			process.charset="gb2312";
			
			try{			
				process.start(info);
			}catch(error:Error){
			}
		}
	}
}