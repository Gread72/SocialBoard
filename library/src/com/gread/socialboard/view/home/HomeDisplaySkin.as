package com.gread.socialboard.view.home
{
	import spark.components.Button;
	import spark.components.Image;
	import spark.components.Label;
	import spark.skins.SparkSkin;
	
	public class HomeDisplaySkin extends SparkSkin
	{
		public var title:Label;
		
		public var instruction:Label;
		
		public var logo:Image;
		
		public var twitterAuthPanel:TwitterAuthPanel;
		
		public var facebookPanel:FacebookPanel;
		
		public var settingsBtn:spark.components.Button;
		
		[Embed(source="com/gread/socialboard/assets/logo.png")]
		public var logoObj:Class;
		
		
		public function HomeDisplaySkin()
		{
			super();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if(!title){
				title = new Label();
				title.styleName = "logo";
				addElement(title);
			}
			
			if(!instruction){
				instruction = new Label();
				instruction.styleName = "title";
				addElement(instruction);
			}
			
			if(!logo){
				logo = new Image();
				logo.source = logoObj;
				addElement(logo);
			}
			
			if(!twitterAuthPanel){
				twitterAuthPanel = new TwitterAuthPanel();
				addElement(twitterAuthPanel);
			}
			
			if(!facebookPanel){
				facebookPanel = new FacebookPanel();
				addElement(facebookPanel);
			}
			
			if(!settingsBtn){
				settingsBtn = new Button();
				addElement(settingsBtn);
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			logo.x = 10;
			logo.y = 10;
			
			title.x = logo.width + logo.x + 5;
			title.y = logo.y + (logo.height/2) - (title.height/2) + 4;
			
			instruction.x = logo.x + 25;
			instruction.y = 100;
			instruction.width = Math.round(unscaledWidth * .80);
			
			twitterAuthPanel.x = instruction.x;
			twitterAuthPanel.y = instruction.y + instruction.height + 10;
			
			facebookPanel.x = instruction.x;
			facebookPanel.y = twitterAuthPanel.y + twitterAuthPanel.height + 30;
			
			settingsBtn.x = instruction.x;
			settingsBtn.y = facebookPanel.y + facebookPanel.height + 30;
			
		
		}
		
		override protected function commitProperties():void{
			super.commitProperties();
		}
		
	}
}