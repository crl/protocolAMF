namespace ly
{
    /// <%=url%>
    <%for(var i of al){%>
    /// <summary>
    /// <%=i.desc%> <%=i.cmd%>
    /// </summary>  
    export interface <%=i.name%>{

        <%
        var ts={"int32":"number","int64":"number"};
        ts["bool"]="boolean";
        ts["float"]="number";
        
        var fs=i.fields;
        for(var f of fs){%>
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
    export interface <%=i.name%>{

        <%
        var ts={"int32":"number","int64":"number"};
        ts["bool"]="boolean";
        ts["float"]="number";
        
        var fs=i.fields;
        for(var f of fs){%>
        //<%=f.desc%>
        //<%=f.rule%>
        <%=f.name%>:<%=(ts[f.type]?ts[f.type]:f.type)%><%=(f.rule=="repeated"?"[]":"")%>;
        <%}%>
    
    }

    <%}%>
}