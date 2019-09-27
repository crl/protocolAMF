package protobuf
{
	import flash.filesystem.File;

	public class ProjectVO
	{
		public static var PROTO_OUTPUT_DIR:String;
		public static var PBMsgDict:String="PBMsgDict.json";
		
		
		public static function GetTempFile():File{
			var f:File=File.documentsDirectory.resolvePath("protobuff");
			
			return f; 
		}
		
		//项目名 
		public var name:String;
		//过滤页面列表(主要为页面title,用逗号格开)
		public var titles:Vector.<String>=new Vector.<String>();
		//客户端模版路径
		public var sTemplate:String;
		//服务端模版路径
		public var cTemplate:String;
		// wiki域名根路径 
		public var domain:String;
		//协议列表路径 	
		public var rootUrl:LinkVO;
		//通用对像定义	
		public var commonUrl:LinkVO;
		//客户端代码生成路径 
		public var clientPath:String;
		//客户端代码生成路径 	
		public var serverPath:String;
		//客户端协议文件保存路径
		public var clientDicPath:String;
		//服务端协议文件保存路径
		public var serverDicPath:String;
		//远程协议文件保存路径
		public var remoteDicPath:String;
		
	    //服务端run.bat文件的路径 
		public var serverBatPath:String;
		//是否包含svn
		public var hasSVN:Boolean;
		//是否生成proto
		public var isCreateProto:Boolean;
		
		
		public function parse(obj:Object):void
		{
			this.name = obj.name;
			this.domain = obj.domain;

			this.sTemplate=obj.sTemplate;
			this.cTemplate=obj.cTemplate;
			this.isCreateProto=obj.isCreateProto;
			
			var url:String =decodeURI(this.domain+obj.rootUrl);
			
			this.rootUrl=new LinkVO(url);
			this.rootUrl.title="主页";
			
			url=obj.commonUrl;
			if(url){
				url =decodeURI(this.domain+url);
				this.commonUrl=new LinkVO(url);
				this.commonUrl.title="通用DTO";
			}
			this.hasSVN=obj.hasSVN==undefined?true:obj.hasSVN;
			
			var titles:String=obj.titles;
			if(titles){
				var ls:Array=titles.split(",");
				for each(var item:String in ls){
					this.titles.push(item);
				}
			}
			
			this.clientPath = obj.clientPath;
			this.clientDicPath=obj.clientDicPath;
			
			this.serverBatPath = obj.serverBatPath;
			this.serverPath = obj.serverPath;
			this.serverDicPath = obj.serverDicPath;
			
			this.remoteDicPath=obj.remoteDicPath;
		}
		
		public function filterTitle(key:String):Boolean
		{
			if(this.titles.length==0){
				return true;
			}
			return this.titles.indexOf(key)!=-1;
		}
	}
}