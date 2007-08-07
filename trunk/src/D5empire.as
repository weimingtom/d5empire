package
{
	import org.d5.base.Player;
	public dynamic class D5empire
	{
		// 根据输入的用户名生成用户实体，并记录用户列表
		public function D5empire(userList:Array):void
		{
			
			for(var i:int=0;i<userList.length;i++)
			{
				// 生成Player实体
				this[userList[i]] = new Player(userList[i]);
				// 记录用户
				uList.push(userList[i]);
			}
			
		}
		
		// 增加新用户
		public function addUser(userName:String):void
		{
			this[userName] = new Player(userName);
			uList.push(userName);
		}
		
		// 用户退出
		public function deleteUser(userName:String):void
		{
			delete this[userName];
			for(var i:int=0;i<uList.length;i++)
			{
				if(uList[i]==userName) uList.splice(i,1);
			}
		}
		
		// 获取所有用户列表，返回以用户ID为数组
		public function getUserList():Array
		{
			return uList;
		}
		
		// 以用户ID为参数获取一个用户的实体
		public function getUser(p:String):Player
		{
			return this[p];
		}
		
		// 用户列表
		private var uList:Array=new Array();
	}
}