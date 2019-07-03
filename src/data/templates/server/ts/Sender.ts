namespace dto{
   /// <summary>
   /// 参考：<%=url%>
   /// </summary>
   export class Sender<%=name%>
   {
      <%var ts={
         "int32":"number",
         "int64":"number",
         "float":"number",
         "bool":"boolean",
         "bytes":"object"
      };
      var l=cl;
      if(isS){
         l=sl
      }
      l=l.concat(dl);
      
      for(var i of l){     
         var fs=i.fields;
         var a=[];
         if(isS && i.cmd){
            a.push("_s:ISender");
         }
         for(let f of fs){
            var s="";
            /*if(f.rule=="optional"){//可选参必须放最后,但这样顺序就会有问题
               s="?"
            }*/
            a.push(f.name+s+":"+(ts[f.type]?ts[f.type]:f.type)+(f.rule=="repeated"?"[]":""));
         }%>
      /**
       * <%=(isS?"回复":"请求")%> <%=i.desc%><%for(var f of fs){%>
       * @param <%=f.name%><%=(f.rule=="optional")?"?":""%>\t<%=f.desc%><%}%>
       */
      static <%=i.lsName%>(<%=a.join(",")%>)
      {
         var _=<<%=i.name%>>{};
         <%for(let f of i.fields){%>
         _.<%=f.name%>=<%=f.name%>;
         <%}%>
         <%if(!i.cmd){%>
         <%} else if(isS){%>
         if(_s)_s.send(<%=i.cmd%>,_);
         <%}else{%>
         rf.socket.send(<%=i.cmd%>,_);
         <%}%>
         return _;
      }<%}%>
   }
}

<%if(isS){%>
//require("./proto/Sender<%=name%>");
if (typeof global != "undefined") {
   var g=global,b=dto;
   if(g["dto"]==undefined) g["dto"]={};
   for (var key in b)g["dto"][key] = b[key];
}
<%}%>