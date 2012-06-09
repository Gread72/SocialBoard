package com.gread.socialboard.view.home
{
	
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
					instruction.text = "Welcome to SocialBoard... \nPlease log into Twitter and Facebook to view feeds. \nOther sources do not need login.";
				
				default:
					break;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
		public function set currentServiceStatus(servicesAreAuthenticated:Boolean):void{
			if(servicesAreAuthenticated){
				instruction.text = "Welcome to SocialBoard...\nClick on grid to select feed."
				twitterAuthPanel.visible = false;
				facebookPanel.visible = false;
			}
		}
		
	}
}