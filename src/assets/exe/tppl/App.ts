import * as fs from "fs";
export class App {
    constructor() {

        let html = `
using foundation;
namespace gameSDK
{
   public class <%=name%>Ext
    {
        public static void Fill(MessageFactory factory)
        {
            <%for(var i of sl){%>
            factory.addMapping<<%=i.name%>>(<%=i.name%>.TYPE);
            <%}%>
        }
    }


    <%var a=sl;for(var i of a){%>
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
        `

        let tppl = require("./tppl").tppl;

        let itemC = { name: "client", cmd: 3300 };
        let itemS = { name: "server", cmd: 3300 };
        let c = tppl(html, { cl:[itemC],sl:[itemS], name: "crl" });



        console.log(c)
    }


}

if (process && process.argv.length > 3) {
   
    //console.log("begin js");
    let tp=process.argv[2];
    let cfg = process.argv[3];

    //console.log(tp,cfg);
   
    let buf=fs.readFileSync(cfg);
    var json=JSON.parse(buf.toString("utf-8"));

    buf=fs.readFileSync(tp);
    var tpStr=buf.toString("utf-8");

    let tppl = require("./tppl").tppl;
    var base64 = require('./base64').Base64;
    let result = tppl(tpStr, json);

    let o = JSON.stringify({ c: 1,d: base64.encode(result),k:process.argv[4]});
    console.log(o);
} else {
    console.log("argv.length <3")
    new App();
}