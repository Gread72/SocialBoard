package com.gread.socialboard.view.home
{
	
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class HomeDisplay extends SkinnableComponent
	{
		[SkinPart(required = "true")]
		public var title:Label;
		
		[SkinPart(required = "true")]
		public var instruction:Label;
		
		[SkinPart(required = "true")]
		public var logo:Image;
		
		[SkinPart(required = "true")]
		public var twitterAuthPanel:TwitterAuthPanel;
		
		[SkinPart(required = "true")]
		public var facebookPanel:FacebookPanel;
		
		[SkinPart(required = "true")]
		public var settingsBtn:Button;
		
		public function HomeDisplay()
		{
			super();
		}
		
		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			
			switch (partName) {
				case "title":
					title.text = "SocialBoard";
					break;
				
				case "instruction":
					instruction.text = "Welcome to SocialBoard... \n\nPlease log into Twitter and Facebook to view feeds. \n\nOther sources do not need login.";
					break;
				
				case "settingsBtn":
					settingsBtn.label = "Settings";
					settingsBtn.addEventListener(MouseEvent.CLICK, onClickSettingsBtn)
					break;
				
				default:
					break;
			}
		}
		
		protected function onClickSettingsBtn(event:MouseEvent):void
		{
			
			twitterAuthPanel.visible = !twitterAuthPanel.visible;
			facebookPanel.visible = !facebookPanel.visible;
			//settingsBtn.visible = false;
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
		public function set currentServiceStatus(servicesAreAuthenticated:Boolean):void{
			if(servicesAreAuthenticated){
				instruction.text = "Welcome to SocialBoard...\n\nClick on grid to select feed."
				twitterAuthPanel.visible = false;
				facebookPanel.visible = false;
				settingsBtn.visible = true;
			}else{
				settingsBtn.visible = false;
			}
		}
		
	}
}