package
{
	import org.d5.base.Player;
	public dynamic class D5empire
	{
		public function D5empire(userList:Array):void
		{
			
			for(var i:int=0;i<userList.length;i++)
			{
				this[userList[i]] = new Player(userList[i],10*i,10*i);
				uList.push(userList[i]);
			}
			
		}
		
		public function getUserList():Array
		{
			return uList;
		}
		
		public function getUser(p:String):Player
		{
			return this[p];
		}
		
		private var uList:Array=new Array();
	}
}