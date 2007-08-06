package org.d5.server
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.Responder;
	import flash.events.NetStatusEvent;
	import flash.net.Responder;
	public class D5server extends NetConnection
	{
		// 构造函数
		// 参数u:用户的用户名（非昵称）
		public function D5server(u:String):void
		{
			init(u);
		}
		
		public function callServer(f:String,r:Array):void
		{
			this.call(f,serverRes,r);
		}
		
		public function callResult(re:Object):Object
		{
			return re;
		}
		
		public function callStatus(re:Object):Object
		{
			return re;
		}
		
		// 连接服务器
		// 参数u:用户的用户名（非昵称）
		private function init(u:String):void
		{
			this.connect(host,u);
			this.addEventListener(NetStatusEvent.NET_STATUS,netStatusControl);
		}
		
		// 连接监听
		private function netStatusControl(e:NetStatusEvent):void
		{
			trace(e.info.code.toString());
		}
		
		private var host:String="rtmp://localhost/d5empire";
		private var serverRes:Responder=new Responder(callResult,callStatus);;
	}
}