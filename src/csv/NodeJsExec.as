package csv
{
	import com.OpenFile;
	import com.sociodox.utils.Base64;
	
	import csv.core.Loger;
	import csv.tpl.TplVO;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import mx.logging.Log;
	import mx.utils.Base64Decoder;
	import mx.utils.StringUtil;
	
	public class NodeJsExec
	{
		public static var C:int=0;
		private static var DataList:Vector.<TplVO>;
		private static var List:Array=[];
		public static function Push(name:String,callBack:Function,data:TplVO,nodejs:String,tp:String):NativeProcessNode{
			
			if(DataList==null){
				DataList=new Vector.<TplVO>();
			}
			
			var exe:File=new File("C:/Program Files/nodejs/node.exe");
			
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();//启动参数
			info.executable = new File(exe.nativePath);
			var processArg:Vector.<String> = new Vector.<String>();
			
			
			processArg.push(nodejs);
			processArg.push(tp);
			processArg.push(getNodejsConfigPath());
			
			
			var index:int=DataList.push(data);
			processArg.push(index-1);
			
			info.arguments= processArg;
			var process:NativeProcessNode = new NativeProcessNode(callBack,info);
			process.data=data;
			process.name=name+"Nodejs"+(C++);
			
			List.push(process);
			
			return process;
		}
		
		private static function saveNodejsConfig(json:Object):Boolean{
			var content:String=JSON.stringify(json);
			OpenFile.writeAsTxt(content,getNodejsConfigPath(),"utf-8");
			return true;
		}
		
		private static function getNodejsConfigPath():String{
			
			var file:File=File.applicationDirectory.resolvePath("data/nodeCFG.json");
			return file.nativePath;
		}
		
		
		private static var current:NativeProcessNode;
		public static function Next():Boolean{
			if(List.length==0){
				DataList=null;
				return false;
			}
			
			if(current && current.isRunning){
				return false;
			}
			
			current=List.shift();
			saveNodejsConfig(current.data.jsonData);
			
			current.run();
			return true;
		}
		
		public static function Get(index:int):TplVO
		{
			return DataList[index];
		}
		
		public static function Clear(index:int):void
		{
			DataList[index]=null;
		}
	}
}
import com.sociodox.utils.Base64;

import csv.NativeProcessExt;
import csv.core.Loger;
import csv.tpl.TplVO;

import flash.desktop.NativeProcessStartupInfo;
import flash.events.Event;
import flash.events.NativeProcessExitEvent;
import flash.events.ProgressEvent;
import flash.utils.ByteArray;

import mx.utils.Base64Decoder;
import mx.utils.StringUtil;

class NativeProcessNode extends NativeProcessExt{	
	public var data:TplVO;
	public var isRunning:Boolean=false;
	private var info:NativeProcessStartupInfo;
	public function NativeProcessNode(callBack:Function,info:NativeProcessStartupInfo){
		super(callBack);
		
		this.info=info;
		
		//removeEventListener(NativeProcessExitEvent.EXIT, exitHandle);
	}
	
	public function run():void{
		trace("start:"+this.name);
		
		isRunning=true;
		try{			
			this.start(info);
		}catch(error:Error){
			isRunning=false;
			Loger.log(error,-1);
			dispatch();
		}
	}
	
	private  var fullMessage:String="";
	override protected function onOutputData(e:ProgressEvent):void{
		//为什么这么写，因为它有可能会恶心的产生粘包
		if(this.standardOutput.bytesAvailable){
			var msg:String=this.standardOutput.readUTFBytes(this.standardOutput.bytesAvailable);
			if(msg){
				fullMessage+=msg;
			}
		}
		
		var ml:Array=fullMessage.split("\n");
		
		for each(var item:String in ml){
			
			if(item=="")continue;
			
			try{
				this.result=JSON.parse(item);
				if(	this.result.c==1){
					fullMessage="";
					
					var bytes:ByteArray=Base64.decode(this.result.d);
					bytes.position=0;
					this.result.d=bytes.readMultiByte(bytes.bytesAvailable,"utf-8");
				}
			}catch(e:Error){
				
			}
		}
		
		if(ml.length>1){
			if(fullMessage){
				for(var i:int=0;i<ml.length-1;i++){
					Loger.log(ml[i]);
				}
			}
			fullMessage=ml[ml.length-1];
			ml.length=0;
		}
	}
	
	
	override protected function exitHandle(e:NativeProcessExitEvent):void{
		this.isRunning=false;
		trace("end:"+this.name);
		super.exitHandle(e);		
	}
}