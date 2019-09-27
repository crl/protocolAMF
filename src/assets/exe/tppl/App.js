"use strict";
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
var fs = __importStar(require("fs"));
var App = /** @class */ (function () {
    function App() {
        var html = "\nusing foundation;\nnamespace gameSDK\n{\n   public class <%=name%>Ext\n    {\n        public static void Fill(MessageFactory factory)\n        {\n            <%for(var i of sl){%>\n            factory.addMapping<<%=i.name%>>(<%=i.name%>.TYPE);\n            <%}%>\n        }\n    }\n\n\n    <%var a=sl;for(var i of a){%>\n    /// <summary>\n    /// <%=i.desc%>\n    /// </summary>\n    public partial class <%=i.name%> : IMessageExtensible\n    {\n        public const int TYPE = <%=i.cmd%>;\n\n        public int getMessageType()\n        {\n            return TYPE;\n        }\n    }\n    <%}%>\n}\n        ";
        var tppl = require("./tppl").tppl;
        var itemC = { name: "client", cmd: 3300 };
        var itemS = { name: "server", cmd: 3300 };
        var c = tppl(html, { cl: [itemC], sl: [itemS], name: "crl" });
        console.log(c);
    }
    return App;
}());
exports.App = App;
if (process && process.argv.length > 3) {
    console.log("begin js");
    var tp = process.argv[2];
    var cfg = process.argv[3];
    console.log(tp,cfg);
    var buf = fs.readFileSync(cfg);
    var json = JSON.parse(buf.toString("utf-8"));
    buf = fs.readFileSync(tp);
    var tpStr = buf.toString("utf-8");
    var tppl = require("./tppl").tppl;
    var base64 = require('./base64').Base64;
    var result = tppl(tpStr, json);
    var o = JSON.stringify({ c: 1, d: base64.encode(result), k: process.argv[4] });
    console.log(o);
}
else {
    console.log("argv.length <3");
    new App();
}
//# sourceMappingURL=App.js.map