package protobuf
{
	import com.OpenFile;
	
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	
	import csv.WikiMsgHeader;
	import csv.WikiPageInfo;
	import csv.core.Loger;
	import csv.proto.Type2Number;
	
	import utlis.HashList;
	
	public class DicGen extends BaseGen
	{
		private var loader:WikiPageLoader = new WikiPageLoader();
		
		private var urls:Vector.<LinkVO> = new Vector.<LinkVO>();
		private var pageInfoList:Vector.<WikiPageInfo>=new Vector.<WikiPageInfo>();
		
		public function run(projectVO:ProjectVO, pageInfo:WikiPageInfo):void
		{
			if(urls.length > 0)
			{
				Alert.show("正在生成中。");
				return;
			}
			
			this.projectVO = projectVO;
			var urlList:Array = pageInfo.linkDic.getValueArray();
			for each (var linkVO:LinkVO in urlList) 
			{
				urls.push(linkVO);
			}
			
			pageInfoList.length=0;
			next();
		}
		
		private function next():void
		{
			if(urls.length == 0)
			{
				end();
				Alert.show("java文件生成好了");
				return;
			}
			
			loader.load(urls.shift(),succHandler);
		}
		
		
		private function end():void
		{
			Type2Number.Init();
			
			var gameMsgArr:Vector.<String> =new Vector.<String>;
			var comoMsgArr:Vector.<String> =new Vector.<String>;
			var dtoList:Vector.<WikiMsgHeader>=new Vector.<WikiMsgHeader>();
			var dic:HashList=new HashList();
			
			
			var file:File=File.applicationDirectory.resolvePath(ProjectVO.PROTO_OUTPUT_DIR);
			if(file.exists){
				file.deleteDirectory(true);
			}
			
			var item:WikiMsgHeader,cs:Object;
			for each (var pageInfo:WikiPageInfo in pageInfoList) 
			{
				if(pageInfo.msgHeaderArr.length == 0 )
				{
					continue;
				}
				var protoName:String=pageInfo.getProtoName();
				if(projectVO.isCreateProto){
					//一份给外部的Server端人员用;
					var filePath:String = projectVO.serverPath+protoName;
					var result:String= pageInfo.getRawProtobufs();
					OpenFile.write(result,filePath);
					Loger.log(filePath);
				}
				//重新写一份在工具的项目中,供其它的单个生成时的引用
				result = pageInfo.getRawProtobufs(this.projectVO.name);
				filePath=ProjectVO.PROTO_OUTPUT_DIR+protoName;
				OpenFile.write(result,filePath);
				Loger.log(filePath);
				
				for each(item in pageInfo.msgHeaderArr){
					//主要为了统一一个把dto放到最后面;
					if(item.cmd==null){
						if(item.name)dtoList.push(item);
						continue;
					}
					cs=dic.get(item.cmd);
					if(cs==null){
						cs={};
						dic.set(item.cmd,cs);
					}
					if(item.isClient){
						cs["c"]=Type2Number.FormatField(item.fields);
					}
					if(item.isServer){
						cs["s"]=Type2Number.FormatField(item.fields);
					}
				}
			}
			
			
			for each(item in dtoList ){
				cs=dic.get(item.name);
				if(cs==null){
					cs={};
					dic.set(item.name,cs);
				}
				cs["dto"]=Type2Number.FormatField(item.fields);
			}
			
			var contents:String="{\r\n";//JSON.stringify(dic);
			//format一个好看;
			for each(var key:String in dic.getKeyArray()){
				if(contents.length>3){
					contents+=",\r\n";
				}
				var value:String=JSON.stringify(dic.get(key));
				contents+="\""+key+"\":"+value;
			}
			contents+="\r\n}";
			
			this.writeDic(contents);
		}
		
		private var _filteTpl:String="";
		override protected function filteTpl(name:String):Boolean
		{
			if(!_filteTpl)return true;
			return _filteTpl==name;
		}
		
		private function getProtobuffRaw(list:Vector.<WikiMsgHeader>):Vector.<String>
		{
			var result:Vector.<String>=new Vector.<String>();
			for each(var item:WikiMsgHeader in list){
				result.push(item.raw);
			}
			return result;
		}		
		
	
		private function succHandler(pageInfo:WikiPageInfo):void
		{
			if(pageInfo){
				pageInfoList.push(pageInfo);	
			}
			next();
		}
		
	}
}