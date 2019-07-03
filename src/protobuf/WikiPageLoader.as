package protobuf
{
	import csv.WikiPageInfo;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class WikiPageLoader
	{
		public var isProcess:Boolean;
		private var urlLoader:URLLoader = new URLLoader();
		private var callBack:Function;
		private var linkVO:LinkVO;
		
		public function load(linkVO:LinkVO,callBack:Function = null):void
		{
			this.linkVO = linkVO;
			this.callBack = callBack;
			
			this.isProcess = true;
			
			var request:URLRequest = new URLRequest(linkVO.url);
			urlLoader.addEventListener(Event.COMPLETE,onComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onComplete);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onComplete);
			
			urlLoader.load(request);
		}
		
		protected function onComplete(event:Event):void
		{
			this.isProcess = false;
			
			var pageInfo:WikiPageInfo;
			if(event.type==Event.COMPLETE){
				var content:String = urlLoader.data;
				pageInfo= new WikiPageInfo();
				pageInfo.desc=linkVO.title;
				pageInfo.parseDomainRoot(linkVO.url);
				pageInfo.parse(content);
			}
			
			if(callBack != null)
			{
				callBack(pageInfo);
			}
		}
	}
}