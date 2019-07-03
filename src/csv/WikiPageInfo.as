package csv
{
	import csv.proto.Type2Number;
	
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;
	
	import protobuf.LinkVO;
	
	import utlis.HashList;
	
	public class WikiPageInfo
	{
		
		private static var optionsReg:RegExp = /option\s*\(\s*(.*)\s*\)\s*=\s*&quot;(.*)&quot;/gm;
		private static var msgBodyReg:RegExp = /(\/{2,5}(cmd\s*=\s*(\d+)\s*)*\|*(.*)\n)*\s*(message\s+(.+)|\w+){\s*\n*(.*?\n*)*}/gm;
		private static var linksReg:RegExp = /<a\s+href="(.*)"\s+class="wikilink1"\s+title="(.*)">\s*(.*)\s*<\/a>/gm;
		private static var domainRootReg:RegExp = /http:\/\/(.*?)\/|https:\/\/(.*?)\//;
		
		private var urlPrefix:String = "";
		public var url:String;
		
		public var desc:String;
		
		/**
		 * 定义在wiki头部的 options 
		 */		
		public var optionDic:Object = {};
		
		public var msgHeaderArr:Vector.<WikiMsgHeader> =new Vector.<WikiMsgHeader>();
		
		/**
		 * wiki里面的超链接 
		 */		
		public var linkDic:HashList =new HashList();
		
		
		public function WikiPageInfo()
		{
			
		}
		
		public function parseDomainRoot(url:String):void
		{
			this.url = decodeURI(url);
			var arr:Array = url.match(domainRootReg);
			
			if(arr.length <2)
			{
				return;
			}
			
			urlPrefix = arr[0];
		}
		
		
		
		public function parse(str:String):void
		{
			optionDic = {};
			linkDic = new HashList();
			
			var result:Object;
			
			var dic:Dictionary=new Dictionary();
			msgHeaderArr.length = 0;
			while (result=msgBodyReg.exec(str)) {
				var  cmd:String=result[3];
				var desc:String=result[4];
				var name:String=result[6];
				if(name==null){
					name=result[5];
					//如果长度太短
					if(name.length==1){
						if(cmd){
							name="F_"+cmd+"_"+name;
						}
					}
				}
				
				if(!desc){
					desc=dic[cmd];
				}else if(cmd){
					dic[cmd]=desc;
				}
				
				var header:WikiMsgHeader = WikiMsgHeader.create(cmd,desc,name);
				header.parserRaw(result[0]);
				msgHeaderArr.push(header);
			}
			
			while (result = optionsReg.exec(str)) {
				optionDic[result[1]] = result[2];
			}
			
			while (result = linksReg.exec(str)) {
				var linkURI:String = result[1];
				if(linkURI.indexOf(urlPrefix) == -1)
				{
					linkURI = urlPrefix + linkURI.substr(1);
				}
				linkURI=decodeURI(linkURI);
				
				var linkVO:LinkVO=new LinkVO(linkURI);
				linkVO.title=result[2];
				
				linkDic.set(linkVO.title,linkVO);
			}
		}
		
		public function getProtoName():String{
			var name:String= optionDic["file"];
			if(name){	
				if(name.indexOf(".proto")==-1){
					name+=".proto";
				}
				name=Type2Number.UpperFist(name);
			}
			return name;
		}
		
		
		public function getImportNs(): Vector.<String>{
			var list:Vector.<String>=new Vector.<String>();
			var m:String= optionDic["import"];
			if(m){
				var l:Array=m.split(",");
				for each(var i:String in l){
					var name:String=i.toLowerCase();
					if(name.indexOf(".proto")==-1){
						name+=".proto";
					}
					name=Type2Number.UpperFist(name);
					list.push(name);
				}
			}
			return list;
		}
		
		public function getServiceName():String
		{
			var name:String= getProtoName();
			if(name){
				name=name.split(".")[0];
			}
			return name;
		}
		
		
		private static var header:String ="import \"{0}\";\r\n";
		private static var optimize:String="option optimize_for = CODE_SIZE;\r\n";
		private static var common:String="Common.proto";
		
		
		public function getRawProtobufs(projectName:String=""):String
		{
			var protoName:String=this.getProtoName();
			
			var list:Vector.<String>=new Vector.<String>();
			for each(var item:WikiMsgHeader in msgHeaderArr){
				list.push(item.raw);
			}
			var result:String="";
			var imp:String;
			var contents:String = list.join("\r\n");
			
			list=this.getImportNs();
			
			if(protoName.toLowerCase() !=common.toLowerCase()){
				imp=common;
				if(projectName){
					imp=projectName+"/"+imp;
				}
				
				result=StringUtil.substitute(header,imp)+result;
			}
			for each(var p:String in list){
				imp=p;
				if(projectName){
					imp=projectName+"/"+p;
				}
				result +=StringUtil.substitute(header,imp);
			}
			result+=optimize+contents;
			return result;
		}
	}
}