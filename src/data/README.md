class ProjectVO{
    //项目名 
    public var name:String;
    //过滤页面列表(主要为页面title,用逗号格开)
    public var titles:Vector.<String>=new Vector.<String>();
    //客户端模版路径
    public var sTemplate:String;
    //服务端模版路径
    public var cTemplate:String;
    // wiki域名根路径 
    public var domain:String;
    //协议列表路径 	
    public var rootUrl:LinkVO;
    //通用对像定义	
    public var commonUrl:LinkVO;
    //客户端代码生成路径 
    public var clientPath:String;
    //客户端代码生成路径 	
    public var serverPath:String;
    //客户端协议文件保存路径
    public var clientDicPath:String;
    //服务端协议文件保存路径
    public var serverDicPath:String;
    //服务端run.bat文件的路径 
    public var serverBatPath:String;
    //是否包含svn
    public var hasSVN:Boolean;
    //是否生成proto
    public var isCreateProto:Boolean;
}