using foundation;
namespace gameSDK
{
   public class Ext<%=name%>
    {
        public static void Fill(MessageFactory factory)
        {
            <%for(var i of sl){%>
            factory.addMapping<<%=i.name%>>(<%=i.name%>.TYPE);
            <%}%>
        }
    }


    <%var a=sl.concat(cl);for(var i of a){%>
    /// <summary>
    /// <%=i.desc%>
    /// </summary>
    public partial class <%=i.name%> : IMessageExtensible
    {
        public const int TYPE = <%=i.cmd%>;

        public int getMessageType()
        {
            return TYPE;
        }
    }
    <%}%>
}