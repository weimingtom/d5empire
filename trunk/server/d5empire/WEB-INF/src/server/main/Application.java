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
	
	//����ʱ�����ĺ��������屾�����е�username
	public boolean appConnect(IConnection conn, Object[] params)
	{
		username=(String)params[0];
		//����ʱ������ID��������Ϣ�γɶ�Ӧ��ϵ�����������б�
		String link_id=conn.getClient().getId();
		onLineClient.put(link_id, conn);
		return true;
	}
	
	//�û��Ͽ����ӵ�ʱ�򴥷�,ˢ�������б�,ȥ������MAP�еļ�¼
	//֪ͨ�ͻ��˸��������б�
	public void appDisconnect(IConnection conn)
	{
		String dis_link_id=conn.getClient().getId();
		//����IDɾ����Ӧ���߼�¼
		onLineClient.remove(dis_link_id);
		//ȡ���µ������б��㲥��ȥ
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
    	//���ID
    	String myid=myconn.getClient().getId();
    	//��������б�
    	String onliner=getOnlineList();
    	//�㲥�����б�
    	BroadcastOnlineList(onliner,0);
		
		//��������
    	return myid;
    }
    
    //ȡ�������б������ߵĿͻ��˽��б���������ʾ��
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
        //����fid����û���
    	IConnection searchClient=onLineClient.get(fid);
    	String from_name=searchClient.getClient().getAttribute("username").toString();
    	callClient(uid,"getMsg",new Object[]{msg,fid,from_name});

    }
    
    /*
     * ˽�к�������
     * ���º������������ⲿֱ�ӵ���,�����ڲ�����ʹ��
     */
    
    //�㲥�����б�
    //0-ȫ���㲥 1-���һ�����ӵĲ��㲥
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
        		
        		//����ǰ�û��㲥�����б�
        		if(!uname.equals(username)) callClient(uid,"makeOnlineList",new Object[]{onLineList});
    		}
    	}
    }
    
    //���пͻ��˺���
    //uidΪ�ͻ��˵�����ID��method_nameΪ������,objΪ���ݵĲ���
    private boolean callClient(String uid, String method_name,Object[] obj)
    {
    
        IConnection toClient=onLineClient.get(uid);
        if (toClient instanceof IServiceCapableConnection)
        {
            //ת����Ϣ
        	IServiceCapableConnection sc = (IServiceCapableConnection) toClient;
            sc.invoke(method_name, obj);
            return true;
        }

    	return true;
    }
    
    /*
     * ���Զ�����
     * ��������Ϊ���������ԵĶ���
     */
    
	private IScope appScope;
	private String username="";			// �û���
	private int mypoint[]=new int[2];	// ��ǰ����
	private Map<String,IConnection> onLineClient=new HashMap<String,IConnection>();
}