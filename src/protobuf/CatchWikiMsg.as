package protobuf
{
	import com.OpenFile;
	
	import csv.WikiPageInfo;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.utils.StringUtil;
	
	public class CatchWikiMsg
	{
		public var isProcess:Boolean;
		
		private var loader:URLLoader
		
		private var callBack:Function;
		
		private var projectVO:ProjectVO;
		private var pageType:String;
		private var linkVO:LinkVO;
		
		public function load(projectVO:ProjectVO,linkVO:LinkVO,callBack:Function = null):void
		{
			this.projectVO = projectVO;
			this.linkVO = linkVO;
			this.callBack = callBack;
			
			isProcess = true;
			
			var request:URLRequest = new URLRequest(linkVO.url);
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onComplete);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onComplete)
			loader.load(request);
		}
		
		protected function onComplete(event:Event):void
		{
			isProcess = false;
			
			var pageInfo:WikiPageInfo;
			
			if(event.type==Event.COMPLETE){
				
				pageInfo= new WikiPageInfo();
				pageInfo.desc=linkVO.title;
				pageInfo.parseDomainRoot(linkVO.url);
				pageInfo.parse(loader.data);
				
				if(pageInfo.msgHeaderArr.length > 0 )
				{
					var protoName:String=pageInfo.getProtoName();
					if(protoName){
						var filePath:String = ProjectVO.PROTO_OUTPUT_DIR+protoName;
						var contents:String = pageInfo.getRawProtobufs(this.projectVO.name);
						OpenFile.write(contents,filePath);
					}
				}
			}
			
			if(callBack != null)
			{
				callBack(pageInfo);
			}
			
		}
	}
}