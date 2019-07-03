namespace gameSDK
{
	/// <summary>
   /// 参考：<%=url%>
   /// </summary>
   public class Request<%=name%>
	{
      <%
      var ts={"int32":"int"};
      for(var i of cl){%>
      
      <%var fs=i.fields;
      	var a=[];
      	var b=[];
      	for(var f of fs){
      		a.push(f.name+":"+(ts[f.type]?ts[f.type]:f.type));
      		b.push("a."+f.name+"="+f.name+";");
      	}
      	%>
      
      /// <summary>
      /// <%=i.desc%>
      /// </summary>
      public static <%=i.name%> <%=i.shortName%>(<%=a.join(",")%>)
      {
      	var a=new <%=i.name%>()
      	<%=b.join("\r\n\t\t\t")%>
         return a;
      }
      <%}%>
	}
}
