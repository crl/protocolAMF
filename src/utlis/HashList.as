package utlis
{
	/**
	 * 有顺序的hash列表; 
	 * @author crl
	 * 
	 */	
	public class HashList extends HashMap
	{
		protected var list:Array;
		public function HashList(weakKeys:Boolean=false)
		{
			super(weakKeys);
			list=new Array();
		}
		
		override public function set(key:*, o:*):void{
			if(has(key)==false && o){
				//其它由super的dele操作;
				list.push(key);
			}
			super.set(key,o);
		}
		override public function dele(key:*):*{
			var index:int=list.indexOf(key);
			if(index !=-1){
				list.splice(index,1);
			}
			return super.dele(key);
		}
		
		override public function getKeyArray():Array{
			return list;
		}
		
		/**
		 * 有顺序数组; 
		 * @return 
		 * 
		 */		
		override public function getValueArray():Array{
			var len:int=list.length;
			var result:Array=new Array(len);
			var i:int;
			for each(var key:* in list){
				result[i++] = dic[key];
			}
			return result;
		}
		
		override public function clear():void{
			super.clear();
			list.length=0;
		}
		override public function dispose():void{
			super.dispose();
			list=null;
		}
		
		public function concat(hashList:HashList):void
		{
			var tmpKeys:Array = hashList.getKeyArray();
			var tmpValues:Array = hashList.getValueArray();
			var len:int = tmpKeys.length;
			for (var i:int = 0; i < len; i++) 
			{
				set(tmpKeys[i],tmpValues[i]);
			}
		}

	}
}