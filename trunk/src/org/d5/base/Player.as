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
			// Load lib
			var url:URLRequest=new URLRequest(url);
			var t_info : LoaderInfo = loader.contentLoaderInfo;
			t_info.addEventListener(Event.COMPLETE, buildPlayer);
			loader.load(url);
			
			main.x=x;
			main.y=y;
			main_name=name;
			
			this.addChild(main);
			this.addChild(loader);
		}
		
		public function buildPlayer(e:Event):void
		{
			var loadinfo:LoaderInfo=loader.contentLoaderInfo;
			player=loadinfo.content as MovieClip;
			player.addEventListener(Event.ENTER_FRAME,moveControler);
			main.addChild(player);
			username.text=main_name;
			main.addChild(username);
		}
		
		private function moveControler(e:Event):void
		{
			if(moveArr[0]== undefined) return;
			var _direction:int;
			if(main.x!=getTarget("x"))
			{
				// 计算移动方向
				_direction=(getTarget("x")-main.x)>0 ? 1 : -1;
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
		
		
		
		public var main:MovieClip=new MovieClip;
		public var main_name:String;
		public var player:MovieClip;
		
		public var username:TextField=new TextField();
		private var loader:Loader=new Loader();
		private var url:String="lib/player.swf";
		private var moveArr:Array=new Array();
		private var speed:int=5;
	}
}