package org.d5.server
{
	import flash.display.Stage;
	import flash.display.Sprite;
	import org.d5.base.Player;
	
	public class D5server extends Sprite
	{
		public function D5server(d5:D5empire)
		{
			mainOther=d5;
		}
		public function userLogin(userinfo:Object):void
		{
			
		}
		
		public function userMove(userinfo:Object):void
		{
			//stage.getChildByName("output").text=userinfo.toString();
			//mainOther.getUser(userinfo[0]).addMoveTarget(new Array(userinfo[1][0],userinfo[1][1]));
		}
		
		public function userLogout(userinfo:Object):void
		{
			
		}
		
		private var mainOther:D5empire;
	}
}