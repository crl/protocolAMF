declare namespace dto{
    /// <%=url%>
    <% 
    var ts={"int32":"number","int64":"number"};
    ts["bool"]="boolean";
    ts["float"]="number";
    ts["bytes"]="object";
    for(var i of al){
    %>
    /// <summary>
    /// <%=i.desc%> <%=i.cmd%>
    /// </summary>  
    interface <%=i.name%>{
        <%var fs=i.fields;for(var f of fs){%>
        //<%=f.desc%>
        //<%=f.rule%>
        <%=f.name%>:<%=(ts[f.type]?ts[f.type]:f.type)%><%=(f.rule=="repeated"?"[]":"")%>;
        <%}%>
    }
    <%}%>
    <%for(var i of dl){%>
    /// <summary>
    /// <%=i.desc%>
    /// </summary>  
    interface <%=i.name%>{
        <%var fs=i.fields;for(var f of fs){%>
        //<%=f.desc%>
        //<%=f.rule%>
        <%=f.name%>:<%=(ts[f.type]?ts[f.type]:f.type)%><%=(f.rule=="repeated"?"[]":"")%>;
        <%}%>
    }
    <%}%>
}
