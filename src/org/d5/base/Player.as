package org.d5.base
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class Player extends Sprite
	{
		public function Player(name:String):void
		{
			/* ------ 数据初始化 ------ */
			main.x=0;			// X坐标
			main.y=0;			// Y坐标
			mainname=name;		// 用户ID
			
			/* ------ 加载角色  ------ */
			var url:URLRequest=new URLRequest(url);
			loadinfo = loader.contentLoaderInfo;
			loadinfo.addEventListener(Event.COMPLETE, buildPlayer);
			loader.load(url);
		}
		
		// 角色加载监听函数
		public function buildPlayer(e:Event):void
		{
			player=loadinfo.content as MovieClip;							// 获取MC
			player.addEventListener(Event.ENTER_FRAME,moveControler);
			playerMoveStop();												// 停止角色走动
			main.addChild(player);
			setGamename(mainname);
			this.addChild(main);
		}
		
		// 设置显示用户名
		public function setGamename(gname:String):void
		{
			gamename=gname;
			buildNameLabel();												// 初始化昵称
		}
		
		// 设置位置
		public function setXY(x:int,y:int):void
		{
			main.x=x;
			main.y=y;
		}
		
		// 添加移动目标
		public function addMoveTarget(target:Array):void
		{
			moveArr.push(target);
		}
		
		public function gotoAndPlay(frame:String):void
		{
			main.gotoAndPlay(frame);
		}
		
		public function gotoAndStop(frame:String):void
		{
			main.gotoAndStop(frame);
		}
		
		public function getX():int
		{
			return main.x;
		}
		// 测试用函数
		public function getTestData():Object
		{
			return moveArr;
		}
		
		
		// 移动控制程序
		private function moveControler(e:Event):void
		{
			if(moveArr[0]== undefined) return;
			var _direction:int;
			if(main.x!=getTarget("x"))
			{
				// 计算移动方向
				_direction=(getTarget("x")-main.x)>0 ? 1 : -1;
				// 设置移动方向
				if(_direction==-1)
				{
					set_playerDirection("left");
				}else{
					set_playerDirection("right");
				}
				main.x+=speed*_direction;
				if(Math.abs(getTarget("x")-main.x)<speed/2) main.x=getTarget("x");
			}
			
			if(main.y!=getTarget("y"))
			{
				// 计算移动方向
				_direction=(getTarget("y")-main.y)>0 ? 1 : -1;
				main.y+=speed*_direction;
				if(Math.abs(getTarget("y")-main.y)<speed/2) main.y=getTarget("y");
			}
			
			if(main.x==getTarget("x") && main.y==getTarget("y"))
			{
				// 清除目标坐标
				moveDone();
			}else if(!player.move_status){
				playerMoveAction();
			}
			
			
		}
		
		// 获取移动目的地
		// 参数：type - x 获取X的目标位置，y 获取Y的目标位置		
		private function getTarget(type:String):int
		{
			switch(type)
			{
				case "x":
					return moveArr[0][0];
					break;
				case "y":
					return moveArr[0][1];
					break;
				default:
					return -1;
					break;
			}
		}
		
		// 移动结束时进行的操作
		private function moveDone():void
		{
			// 删掉已完成移动的记录
			this.moveArr.shift();
			// 停止走动动作
			playerMoveStop();
		}
		// 建立用户昵称的显示
		private function buildNameLabel():void
		{
			username.text=gamename;
			username.selectable=false;
			main.addChild(username);
		}
		
		/* ------ 角色动画控制区 ------ */
		// 行走状态
		private function playerMoveAction():void
		{
			player.gotoAndPlay(player.playlab);
			player.move_status=true;
		}
		
		// 停止状态
		private function playerMoveStop():void
		{
			player.gotoAndStop(player.playlab);
			player.move_status=false;
		}
		
		// 设置角色当前的行走方向
		// 参数 d:行走方向，对应MC中的标签，分为left right
		private function set_playerDirection(d:String):void
		{
			player.playlab=d;
		}
		
		
		
		public var main:MovieClip=new MovieClip;
		public var mainname:String;
		public var gamename:String;
		public var player:MovieClip;
		public var username:TextField=new TextField();

		private var loader:Loader=new Loader();
		private var loadinfo:LoaderInfo;
		private var url:String="lib/player.swf";
		private var moveArr:Array=new Array();
		private var speed:int=3;
	}
}