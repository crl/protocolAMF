using System;
using clayui;
using foundation;
using UnityEngine;

namespace gameSDK
{
    public partial class Decoder<%=name%> : AbstractDecoder, ISocketDecoder
    {        
        <%for(var i of sl){%>
        /// <summary>
        /// <%=i.desc%>
        /// </summary>
        /// <param name="msg"></param>        
        [CMD(code=<%=i.name%>.TYPE)]
        public void <%=i.shortName%>(<%=i.name%> m)
        {
            this.on<%=i.shortName%>(m);
        }
        <%}%>
    }
}