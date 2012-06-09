package com.gread.socialboard.view.socialFeed
{
	import com.hurlant.crypto.symmetric.NullPad;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.ui.Keyboard;
	
	public class StageWebViewExample extends MovieClip
	{
		public var webView:StageWebView = new StageWebView();
		private var background:Sprite = new Sprite;
		
		public function StageWebViewExample() 
		{
			
		}
		
		public function init(stage:Stage):void{
			webView.stage = stage;	
			var width:Number = stage.stageWidth * .9;
			var height:Number = stage.stageHeight * .8;
			var xPos:Number = stage.stageWidth / 2 -  width / 2;
			var yPos:Number = stage.stageHeight / 2 -  height / 2;
			webView.viewPort = new Rectangle( xPos, yPos, width, height);
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKey );
		}
		
		private function onKey( event:KeyboardEvent ):void
		{
			if( event.keyCode == Keyboard.BACK && webView.isHistoryBackEnabled )
			{
				trace("Back.");
				webView.historyBack();
				event.preventDefault();
			}
			
			if( event.keyCode == Keyboard.SEARCH && webView.isHistoryForwardEnabled )
			{
				trace("Forward.");
				webView.historyForward();
			}
		}
		
		public function gotoUrl(url:String):void{
			if( url ){
				webView.loadURL( url );
			}
		}
	}
}