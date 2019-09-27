package csv
{
	import flash.desktop.NativeProcess;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	
	import mx.utils.StringUtil;
	
	import csv.core.Loger;
	
	public class NativeProcessExt extends NativeProcess
	{
		public var charset:String="utf-8";
		public var name:String;
		protected var callBack:Function;
		
		protected var result:Object;
		public function NativeProcessExt(callBack:Function){
			this.callBack=callBack;
			
			addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			addEventListener(ProgressEvent.STANDARD_ERROR_DATA, errorHandle);
			addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, errorHandle);
			addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, errorHandle);
			
			addEventListener(NativeProcessExitEvent.EXIT, exitHandle);
		}
		
		protected function onOutputData(e:ProgressEvent):void {
			var msg:String;
			if(standardOutput.bytesAvailable){
				msg=standardOutput.readMultiByte(standardOutput.bytesAvailable,charset);
				msg=StringUtil.trim(msg);
				
				if(msg){
					Loger.log(msg);
				}
			}
		}
		
		private function errorHandle(e:Event):void{
			var msg:String;
			if (standardError.bytesAvailable)
			{
				msg=standardError.readMultiByte(standardError.bytesAvailable,charset);
				msg=StringUtil.trim(msg);
			}
			
			if(msg){
				Loger.log(msg,-1);
			}
			
		}
		
		protected function exitHandle(e:NativeProcessExitEvent):void{
			
			if (standardError.bytesAvailable)
			{
				var msg:String=standardError.readMultiByte(standardError.bytesAvailable,charset);
				msg=StringUtil.trim(msg);
				if(msg){
					Loger.log(msg,0);
				}
			}
			
			
			
			removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, errorHandle);
			removeEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, errorHandle);
			removeEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, errorHandle);
			
			removeEventListener(NativeProcessExitEvent.EXIT, exitHandle);
			
			dispatch();
		}
		
		public function dispatch():void{
			var old:Function=callBack;
			if(old!=null){
				callBack=null;
				old(name,result);
			}
		}
	}
}