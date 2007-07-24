package org.d5.base
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.display.Loader;
	
	public class Player extends Sprite
	{
		public function Player():void
		{
			// Load lib
			var url:URLRequest=new URLRequest(player);
			loader.load(url);
			main.addChild(loader);
			main.x=100;
			main.y=100;
			this.addChild(main);
		}
		
		public function getX():int
		{
			return main.x;
		}
		
		public var main:MovieClip=new MovieClip;
		private var loader:Loader=new Loader();
		private var player:String="lib/player.png";
	}
}