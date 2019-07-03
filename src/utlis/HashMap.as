package utlis
{
	import flash.utils.Dictionary;
	
	
	/**
	 * hash表;
	 * @author crl
	 * 
	 */	
	public class HashMap
	{
		protected var dic:Dictionary;
		
		protected var _length:int=0;
		
		protected var weakKeys:Boolean
		
		/**
		 * 用于方面索引及循环调用; 
		 * 如: dictionay 方便索引,但不方便取得大小;
		 * @param weakKeys
		 * 
		 */		
		public function HashMap(weakKeys:Boolean=false)
		{
			this.weakKeys=weakKeys;
			dic=new Dictionary(weakKeys);
			_length=0;
		}
		
		/**
		 * 清理; 
		 * 
		 */		
		public function clear():void{
			dic=new Dictionary(weakKeys);
			_length=0;
		}
		
		/**
		 * 回收 
		 * 
		 */		
		public function dispose():void{
			dic=null;
			_length=0;
		}
		
		/**
		 * 是否存在; 
		 * @param key
		 * @return 
		 * 
		 */		
		public function has(key:*):Boolean{
			return (key in dic);
		}
		
		/**
		 * 取得 
		 * @param key 键
		 * @return 
		 * 
		 */		
		public function get(key:*):*{
			return dic[key];
		}
		
		/**
		 * 存储; 
		 * @param key
		 * @param o
		 * 
		 */		
		public function set(key:*,o:*):void{
			if(dic[key]){
				if(o==null){
					dele(key);
				}else{
					dic[key]=o;
				}
				return;
			}
			
			if(o==null)return;
			
			dic[key]=o;
			_length++;
		}
		
		/**
		 * 删除; 
		 * @param key
		 * @return 
		 * 
		 */		
		public function dele(key:*):*{
			var item:*=dic[key];
			if(item){
				dic[key]=null;
				delete dic[key];
				_length--;
			}
			
			return item;
		}
		
		/**
		 * 取得内部数据; 
		 * @return 
		 * 
		 */		
		public function getDictionary():Dictionary{
			return dic;
		}
		
		
		/**
		 * 生成数组形式,不建议使用; 
		 * @return 
		 * 
		 */		
		public function getKeyArray():Array{
			var result:Array=[];
			for(var key:* in dic){
				result.push(key);
			}
			return result;
		}
		
		/**
		 * 生成数组形式,不建议使用; 
		 * @return 
		 * 
		 */		
		public function getValueArray():Array{
			var result:Array=[];
			for each(var item:* in dic){
				result.push(item);
			}
			return result;
		}
		
		/**
		 * 内部数据长度; 
		 * @return 
		 * 
		 */		
		public function get length():int{
			return _length;
		}
	}
}