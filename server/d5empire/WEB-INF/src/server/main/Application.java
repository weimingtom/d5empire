package server.main;

import org.red5.server.adapter.ApplicationAdapter;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.Red5;
import org.d5.lib.*;
import java.util.*;

public class Application extends ApplicationAdapter {
	
	public boolean appStart(IScope app) {
		appScope = app;
		return true;
	}
	
	//连接时触发的函数，定义本过程中的username
	public boolean appConnect(IConnection conn, Object[] params)
	{
		username=(String)params[0];
		//登入时将连接ID和连接信息形成对应关系并存入在线列表
		String link_id=conn.getClient().getId();
		onLineClient.put(link_id, conn);
		return true;
	}
	
	//用户断开连接的时候触发,刷新在线列表,去除在线MAP中的记录
	//通知客户端更新在线列表
	public void appDisconnect(IConnection conn)
	{
		String dis_link_id=conn.getClient().getId();
		//根据ID删除对应在线记录
		onLineClient.remove(dis_link_id);
		//取得新的在线列表并广播出去
		BroadcastOnlineList(getOnlineList(),0);
	}
	
	//
	public boolean appJoin(IClient client, IScope app)
	{
		client.setAttribute("username",username);
		return true;
	}
	
    public String login(int _x,int _y)
    {
    	IConnection myconn=Red5.getConnectionLocal();
    	//获得ID
    	String myid=myconn.getClient().getId();
    	//获得在线列表
    	String onliner=getOnlineList();
    	//广播在线列表
    	BroadcastOnlineList(onliner,0);
		
		//返回数据
    	return myid;
    }
    
    //取得在线列表，对在线的客户端进行遍历，并显示。
    public String getOnlineList()
    {
    	Iterator<IConnection> it=appScope.getConnections();
    	String onLineList="";
    	while(it.hasNext())
    	{
    		IConnection this_conn=it.next();
    		IClient ic=this_conn.getClient();
    		String u=ic.getAttribute("username").toString();
    		int where[]=(int[])ic.getAttribute("mypoint");
    		
    		onLineList+=ic.getId()+","+u+","+where[0]+","+where[1]+";";
    	}
    	return onLineList;
    }
    
        
    public void sendMSG(String uid,String msg,String fid)
    {
        //根据fid获得用户名
    	IConnection searchClient=onLineClient.get(fid);
    	String from_name=searchClient.getClient().getAttribute("username").toString();
    	callClient(uid,"getMsg",new Object[]{msg,fid,from_name});

    }
    
    /*
     * 私有函数区域
     * 以下函数均不可在外部直接调用,属于内部处理使用
     */
    
    //广播在线列表
    //0-全部广播 1-最后一次连接的不广播
    private void BroadcastOnlineList(String onLineList,Integer mode)
    {
    	Iterator<String> bc_id=onLineClient.keySet().iterator();
    	while(bc_id.hasNext())
    	{
    		String key=bc_id.next();
    		IConnection bc_conn=onLineClient.get(key);
    		IClient bc_ic=bc_conn.getClient();
    		String uid=bc_ic.getId();
    		
    		if(mode==0)
    		{
    			callClient(uid,"makeOnlineList",new Object[]{onLineList});
    		}else{
        		String uname=bc_ic.getAttribute("username").toString();
        		
        		//不向当前用户广播在线列表
        		if(!uname.equals(username)) callClient(uid,"makeOnlineList",new Object[]{onLineList});
    		}
    	}
    }
    
    //呼叫客户端函数
    //uid为客户端的连接ID，method_name为函数名,obj为传递的参数
    private boolean callClient(String uid, String method_name,Object[] obj)
    {
    
        IConnection toClient=onLineClient.get(uid);
        if (toClient instanceof IServiceCapableConnection)
        {
            //转发消息
        	IServiceCapableConnection sc = (IServiceCapableConnection) toClient;
            sc.invoke(method_name, obj);
            return true;
        }

    	return true;
    }
    
    /*
     * 属性定义区
     * 以下内容为本类内属性的定义
     */
    
	private IScope appScope;
	private String username="";			// 用户名
	private int mypoint[]=new int[2];	// 当前坐标
	private Map<String,IConnection> onLineClient=new HashMap<String,IConnection>();
}