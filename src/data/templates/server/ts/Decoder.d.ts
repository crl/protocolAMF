declare namespace dto{
    interface Decoder<%=name%>
    {        
        <%
        var l=sl;
        if(isS){
            l=cl;
        }
        for(var i of l){%>
        /// <summary>
        /// <%=i.desc%>
        /// </summary>
        /// <param name="msg"></param>        
        //@CMD(<%=i.cmd%>)
        <%if(isS){%>
        <%=i.lsName%>(e:IStreamEventX,m:<%=i.name%>);
        <%}else{%>
        <%=i.lsName%>(e:rf.Stream,m:<%=i.name%>);
        <%}%>
        <%}%>
    }
}
