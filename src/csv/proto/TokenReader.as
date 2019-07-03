package csv.proto
{
	public class TokenReader
	{
		private var text:String;
		
		private var whitespace:Array =[" ","\t","\r","\n"];
		private var newline:Array =["\r","\n"];
		private var numbers:Array =["-","0","1","2","3","4","5","6","7","8","9"];
		private var singletoken:Array = ["{","}","=","[","]",";",","];
		public function TokenReader(text:String)
		{
			this.text=text;
		}
		
		public function get parsed():String
		{
			return text.substring(0, offset);
			
		}
		
		public function readNextOrThrow(expect:String):void{
			var n:String = readNext();
			if (n != expect){
				throw new Error(n+"!="+expect);
			}
		}
		
		public function get nextCharacter():String
		{
			return text[offset];
		}
		
		public function readNumber(endNewLine:Boolean=false):Number
		{
			var c:String;
			var result:String="";
			while (true)
			{
				c=getChar();
				
				if(endNewLine && newline.indexOf(c)!=-1){
					offset -= 1;
					//直接为空
					break;
				}
				
				if(whitespace.indexOf(c)!=-1){
					continue;
				}
				
				if (numbers.indexOf(c)==-1){
					offset -= 1;
					break;
				}
				if(c=="-"){
					if(result.length>0){
						offset -= 1;
						break;
					}
				}
				result+=c;
			}
			
			return Number(result);
		}
		
		public function readNext(endNewLine:Boolean=false):String
		{
			while (true)
			{
				var token:String = readNextComment(endNewLine);
				if (token.indexOf("/")==0)	continue;
				return token;
			}
			
			return "";
		}
		
		public function readLine():String{
			var c:String;
			var result:String="";
			while(true){
				c=getChar();
				
				if(newline.indexOf(c)!=-1){
					break;
				}
				if(c){
					result+=c;
				}
			}
			return result;
		}
		
		public function readNextComment(endNewLine:Boolean=false):String{
			var c:String;
			while(true){
				c=getChar();
				
				if(endNewLine && newline.indexOf(c)!=-1){
					//直接为空
					return "";
				}
				
				if(whitespace.indexOf(c)!=-1){
					continue;
				}
				break;
			}
			
			if (singletoken.indexOf(c)!=-1){
				return c;
			}
			
			//Follow token
			var token:String = c;
			var parseString:Boolean = false;
			var parseLineComment:Boolean = false;
			var parseComment:Boolean = false;
			
			if (token == "/")
			{
				token += getChar();
				if (token == "//"){
					parseLineComment = true;
				}else if (token == "/*"){
					parseComment = true;
				}else{
					throw new Error("Badly formatted comment", this);
				}
			}
			if (token == "\"")
			{
				parseString = true;
				token = "";
			}
			
			while (true)
			{
				c = getChar();
				if (parseLineComment){
					if (c == "\r" || c == "\n")
						return token;
				}else if (parseComment){
					if (c == "/" && token.charAt(token.length - 1) == '*'){
						return token.substr(0, token.length - 1);
					}
				}else if (parseString){
					if (c == "\"")
						return token;
				}
				else if (whitespace.indexOf(c)!=-1 || singletoken.indexOf(c)!=-1)
				{
					offset -= 1;
					return token;
				}
				
				token += c;
			}
			return token;
		}
		
		
		private var offset:int=0;
		private function getChar():String
		{
			if (offset >= text.length){
				throw new Error("EndOfStream");
			}
			var c:String = text.charAt(offset);
			offset += 1;
			return c;
		}
		
	}
}