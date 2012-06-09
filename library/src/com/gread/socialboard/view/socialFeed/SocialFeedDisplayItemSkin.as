package com.gread.socialboard.view.socialFeed
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import mx.core.IVisualElement;
	import mx.graphics.Stroke;
	
	import spark.components.Image;
	import spark.components.Label;
	import spark.primitives.Rect;
	import spark.skins.SparkSkin;
	
	public class SocialFeedDisplayItemSkin extends SparkSkin
	{
		public var feedName:Label;
		
		public var feedTitle:Label;
		
		public var profileImg:Image;
		
		public var border:Rect;
		
		public function SocialFeedDisplayItemSkin()
		{
			super();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if(!feedName){
				feedName = new Label;
				addElement(feedName);
			}
			
			if(!feedTitle){
				feedTitle = new Label;
				addElement(feedTitle);
			}
			
			if(!profileImg){
				profileImg = new Image;
				addElement(profileImg);
			}
			
			if(!border){
				border = new Rect;
				addElement(border);
			}
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			profileImg.width = 100;
			feedName.x = profileImg.width + profileImg.x + 5;
			feedName.y = 5;
			feedName.width = 500;
			feedTitle.y = feedName.height + 10;
			feedTitle.x = feedName.x;
			feedTitle.width = 500;
			
			border.stroke = new Stroke(0);
			border.width = profileImg.width + feedName.width + 10;
			var heightSet:Number = feedName.height + (feedTitle.height + 10) + 5;
			if(profileImg.height > heightSet){
				heightSet = profileImg.height;
			}
				  
			
			border.height =  heightSet;
			
			
		}
		
		override protected function commitProperties():void{
			super.commitProperties();
		}
	}
}