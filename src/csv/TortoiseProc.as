package csv
{
	import csv.core.Loger;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	public class TortoiseProc
	{
		public function TortoiseProc()
		{
		}
		
		public static function progress(callBack:Function,...args):void{						
			var exe:File=new File("C:/Program Files/TortoiseSVN/bin/TortoiseProc.exe");
			
			if (!exe.exists)
			{
				exe=new File("D:/Program Files/TortoiseSVN/bin/TortoiseProc.exe");
			}
			if (!exe.exists)
			{
				exe=new File("E:/Program Files/TortoiseSVN/bin/TortoiseProc.exe");
			}
			if (!exe.exists)
			{
				exe=new File("F:/Program Files/TortoiseSVN/bin/TortoiseProc.exe");
			}
			if (!exe.exists)
			{
				exe=new File("G:/Program Files/TortoiseSVN/bin/TortoiseProc.exe");
			}
			if (!exe.exists)
			{
				exe=new File("H:/Program Files/TortoiseSVN/bin/TortoiseProc.exe");
			}
			
			if (!exe.exists)
			{
				exe=File.applicationDirectory.resolvePath("assets/exe/svnbin/TortoiseProc.exe");
			}
			
			var processArg:Vector.<String> = new Vector.<String>();
			var len:int=args.length;
			
			for(var i:int=0;i<len;i++){
				processArg[i] =args[i];
			}
			
			try{		
				var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();//启动参数
				info.executable = new File(exe.nativePath);
			
				info.arguments= processArg;
				var process:NativeProcessExt = new NativeProcessExt(callBack);			
				process.start(info);
			}catch(error:Error){
				process.dispatch();
				Loger.log(error.message,1);
			}
		}
	}
}


