package protobuf
{
	import com.OpenFile;
	
	import csv.CMDExec;
	import csv.NodeJsExec;
	import csv.core.Loger;
	import csv.tpl.TplDataVO;
	import csv.tpl.TplVO;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class BaseGen
	{
		protected var projectVO:ProjectVO;
		public function BaseGen()
		{
		}
		
		
		public function buildTPPL(serviceName:String,jsonData:TplDataVO):void
		{	
			var templatesPrefix:String;
			var prefix:String="data/templates/";
			var side:String="client/";
			
			templatesPrefix=projectVO.cTemplate;
			if(jsonData.isS){
				side="server/";
				templatesPrefix=projectVO.sTemplate;
			}
			
			if(!templatesPrefix)
			{
				return;
			}
			var file:File;
			file= File.applicationDirectory.resolvePath(prefix+side+templatesPrefix);
			if(file.exists==false){
				Loger.log("路径下不存在自动处理:"+file.url)
				return;
			}
			
			var files:Array = file.getDirectoryListing();
			if(files.length==0){
				Loger.log("路径下存在0个自动处理:"+file.url);
				return;
			}
			
			var count:int=0;
			for each(var item:File in files){
				if(item.isDirectory){
					continue;
				}
				
				var names:Array=item.name.split(".");
				var name:String=names[0];
				if(filteTpl(name)==false){
					continue;
				}
				names.shift();
				var extension:String=names.join(".");
				
				count++;
				var data:TplVO=new TplVO();
				data.fileName=name;
				data.serviceName=serviceName;
				data.jsonData=jsonData;
				data.extension=extension;
				
				var nodeJS:String=File.applicationDirectory.resolvePath("assets/exe/tppl/App").nativePath;
				NodeJsExec.Push(name,messageFactoryCallback,data,nodeJS,item.nativePath);
			}
			
			Loger.log("TPPL:"+file.url+" 自动处理 "+count+" 个文件!");
		}
		
		protected function filteTpl(name:String):Boolean
		{
			return true;
		}
		
		private function messageFactoryCallback(name:String,o:Object):void{
			if(o==null){
				Loger.log(name+" 好像没处理成功",-1);
				NodeJsExec.Next();
				return;
			}
			var index:int=o["k"];
			var cfg:TplVO =NodeJsExec.Get(index);
			if(cfg){
				NodeJsExec.Clear(index);
			}
			var content:String=o.d;
			
			var fileName:String=cfg.fileName;
			var extension:String=cfg.extension;
			var list:Array=fileName.split("-");
			
			var folder:String =projectVO.clientPath;
			if(cfg.jsonData.isS){
				folder=projectVO.serverPath;
			}
			
			var prefix:String=folder;

			if(list.length>1){
				fileName=list.pop();
				prefix+=list.join("/");
			}
			
			var serviceName:String =cfg.serviceName;
			
			var fullPath:String=prefix+fileName+serviceName+"."+extension;
			OpenFile.writeAsTxt(content,fullPath,"utf-8");
			
			Loger.log("TPPL:写入"+fullPath,1);
			
			NodeJsExec.Next();
		}
		
		
		
		public function writeDic(contents:String):void{
			var path:String;
			
			//一份存在编辑器里面
			path=projectVO.remoteDicPath+ ProjectVO.PBMsgDict;
			file=File.applicationDirectory.resolvePath(path);
			if(file.exists==false){
				path=ProjectVO.PROTO_OUTPUT_DIR + ProjectVO.PBMsgDict;;
				file=File.applicationDirectory.resolvePath(path);
			}
			OpenFile.write(contents,path);
			Loger.log(path);
			
			//写PBMsgDict
			path=projectVO.clientDicPath;
			var file:File=File.applicationDirectory.resolvePath(path);
			if(file.exists==false){
				path=projectVO.clientPath;
				file=File.applicationDirectory.resolvePath(path);
			}
			if(file.exists){
				path=path + ProjectVO.PBMsgDict;
				OpenFile.write(contents,path);
				Loger.log(path);
			}
			
			//一份给服务端
			path=projectVO.serverDicPath;
			file=File.applicationDirectory.resolvePath(path);
			if(file.exists==false){
				path=projectVO.serverPath;;
				file=File.applicationDirectory.resolvePath(path);
			}
			if(file.exists){
				path=path +ProjectVO.PBMsgDict;
				OpenFile.write(contents,path);
				Loger.log(path);
			}
			
			//调用java run.bat
			var batPath:String = projectVO.serverBatPath;
			if(batPath && File.applicationDirectory.resolvePath(batPath).exists){
				Loger.log(batPath);
				CMDExec.progress(cmdCallback,batPath);
			}
		}
		
		private function cmdCallback(name:String,event:Event):void{
		}
		
	}
}
