namespace ly
{
	/// <summary>
   /// 参考：<%=url%>
   /// </summary>
   export class R<%=name%> extends AbSender
	{
      <%var ts={"int32":"number","int64":"number"};for(var i of cl){%>      
      <%var fs=i.fields;
      	var a=[];
      	for(let f of fs){
      		a.push(f.name+":"+(ts[f.type]?ts[f.type]:f.type)+(f.rule=="repeated"?"[]":""));
      	}%>
      

      /**
       * <%=i.desc%><%for(var f of fs){%>
       * @param <%=f.name%> <%=f.desc%><%}%>
       */
      static <%=i.lsName%>(<%=a.join(",")%>)
      {
      	var a=<<%=i.name%>>{};
         <%for(let f of i.fields){%>
         a.<%=f.name%>=<%=f.name%>;
         <%}%>
         this.send(<%=i.cmd%>,a);
      }<%}%>
	}
}
