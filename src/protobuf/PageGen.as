package protobuf
{
	import com.OpenFile;
	
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import csv.NodeJsExec;
	import csv.Protogen;
	import csv.WikiMsgHeader;
	import csv.WikiPageInfo;
	import csv.core.Loger;
	import csv.proto.Type2Number;
	import csv.tpl.TplDataVO;
	
	public class PageGen extends BaseGen
	{
		private var pageInfo:WikiPageInfo;
		
		public function run(currentProject:ProjectVO,	pageInfo:WikiPageInfo,projectHandle:Function):void
		{
			_filteTpl.length=0;
			
			this.projectVO=currentProject;
			this.pageInfo=pageInfo;
			
			
			var serviceName:String = pageInfo.getServiceName();
			if(!serviceName)
			{
				Loger.log(pageInfo.desc+",没有定义:option (file) = \"xxx.proto\";",-1)
				return;
			}
			
			var folder:String = currentProject.clientPath;
			
			var messsageFolderFile:File = new File(folder + "message/");
			if(!messsageFolderFile.exists)
			{
				messsageFolderFile.createDirectory();
			}
			
			//生成protobuf msg
			var protoName:String=pageInfo.getProtoName();
			Protogen.progress(projectHandle,
				"-i:"+ProjectVO.PROTO_OUTPUT_DIR+protoName,
				"-o:"+folder + "message/"+ serviceName+".cs",
				"-p:detectMissing",
				"-ns:gameSDK"
			);
			Loger.log("protobuff:写入"+folder + "message/"+ serviceName+".cs",1);
			
			
			var sList:Vector.<WikiMsgHeader>=new Vector.<WikiMsgHeader>();
			var cList:Vector.<WikiMsgHeader>=new Vector.<WikiMsgHeader>();
			var dList:Vector.<WikiMsgHeader>=new Vector.<WikiMsgHeader>();
			
			var dic:Dictionary=new Dictionary();
			var cs:Object;
			var key:String;
			for each (var item:WikiMsgHeader in pageInfo.msgHeaderArr) 
			{
				key=item.cmd;
				if(!key){
					key=item.name;
				}
				cs=dic[key];
				if(cs==null){
					cs={};
					dic[key]=cs;
				}
				
				if(item.cmd==null){
					dList.push(item);
					cs["dto"]=Type2Number.FormatField(item.fields);
					continue;
				}
				
				if(item.isServer)
				{
					sList.push(item);
					cs["c"]=Type2Number.FormatField(item.fields);
					continue;
				}
				
				if(item.isClient)
				{
					cList.push(item);
					cs["c"]=Type2Number.FormatField(item.fields);
					continue;
				}
			}
			
			if(sList.length==0 && cList.length==0){
				if(dList.length>0){
					_filteTpl.push("def");
					_filteTpl.push("m");
					_filteTpl.push("ms");
					_filteTpl.push("mc");
				}else{
					return;
				}
			}
			
			var path:String=projectVO.remoteDicPath+ ProjectVO.PBMsgDict;
			var file:File=File.applicationDirectory.resolvePath(path);
			if(file.exists==false){
				path=ProjectVO.PROTO_OUTPUT_DIR + ProjectVO.PBMsgDict;
				file=File.applicationDirectory.resolvePath(path);
			}
			if(file.exists){
				var content:String=OpenFile.openAsTxt(file);
				var oldDic:Object=JSON.parse(content);
				
				for(key in dic){
					oldDic[key]=dic[key];
				}
				content=JSON.stringify(oldDic);
				this.writeDic(content);
			}
			var data:TplDataVO=new TplDataVO();
			data.cl=cList;
			data.sl=sList;
			data.al=cList.concat(sList);
			data.dl=dList;
			data.name=serviceName;
			data.ns=pageInfo.getImportNs();
			data.url=pageInfo.url;
			data.isS=false;
			
			
			buildTPPL(serviceName,data);
			
			
			data=data.clone();
			data.isS=true;
			
			buildTPPL(serviceName,data);
			
			NodeJsExec.Next();
		}
		
		
		
		private var _filteTpl:Vector.<String>=new Vector.<String>();
		override protected function filteTpl(name:String):Boolean
		{
			if(_filteTpl.length==0)return true;
			return _filteTpl.indexOf(name.toLowerCase())!=-1;
		}
		
	}
}

