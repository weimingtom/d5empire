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
		public function Player(name:String,x:int,y:int):void
		{
			// 数据初始化
			main.x=x;
			main.y=y;
			main_name=name;
			
			// 加载角色
			var url:URLRequest=new URLRequest(url);
			var t_info : LoaderInfo = loader.contentLoaderInfo;
			t_info.addEventListener(Event.COMPLETE, buildPlayer);
			loader.load(url);
		}
		
		public function buildPlayer(e:Event):void
		{
			var loadinfo:LoaderInfo=loader.contentLoaderInfo;
			player=loadinfo.content as MovieClip;
			player.addEventListener(Event.ENTER_FRAME,moveControler);
			playerMoveStop();												//停止角色走动
			main.addChild(player);
			buildNameLabel(main_name);
			this.addChild(main);
		}
		
		private function moveControler(e:Event):void
		{
			if(moveArr[0]== undefined) return;
			var _direction:int;
			if(main.x!=getTarget("x"))
			{
				// 计算移动方向
				_direction=(getTarget("x")-main.x)>0 ? 1 : -1;
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
		
		public function getTestData():Object
		{
			return moveArr;
		}
		
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
		
		private function moveDone():void
		{
			this.moveArr.shift();
			playerMoveStop();
		}
		
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
		
		private function buildNameLabel(mytext:String):void
		{
			username.text=main_name;
			username.selectable=false;
			main.addChild(username);
		}
		/* ------ 角色控制区 ------ */
		private function playerMoveAction():void
		{
			player.gotoAndPlay(player.playlab);
			player.move_status=true;
		}
		
		private function playerMoveStop():void
		{
			player.gotoAndStop(player.playlab);
			player.move_status=false;
		}
		
		private function set_playerDirection(d:String):void
		{
			player.playlab=d;
		}
		
		
		
		public var main:MovieClip=new MovieClip;
		public var main_name:String;
		public var player:MovieClip;
		public var username:TextField=new TextField();

		private var loader:Loader=new Loader();
		private var url:String="lib/player.swf";
		private var moveArr:Array=new Array();
		private var speed:int=3;
	}
}