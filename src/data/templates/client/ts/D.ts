namespace ly
{
    export interface D<%=name%>
    {        
        <%for(var i of sl){%>
        /// <summary>
        /// <%=i.desc%>
        /// </summary>
        /// <param name="msg"></param>        
        @CMD(<%=i.cmd%>)
        <%=i.lsName%>(m:<%=i.name%>);
        <%}%>
    }
}