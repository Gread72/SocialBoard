package com.gread.socialboard.view.socialFeed
{
	
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.Rect;
	
	public class Header extends SkinnableComponent
	{
		[SkinPart( required="true" )]
		public var recEle:Rect;
		
		[SkinPart(required = "true")]
		public var title:Label;
		
		[SkinPart(required = "true")]
		public var logo:Image;
		
		private var _sourceTitle:String = "";
		
		
		public function Header()
		{
			super();
		}
		
		[Bindable]
		public function get sourceTitle():String
		{
			return _sourceTitle;
		}

		public function set sourceTitle(value:String):void
		{
			_sourceTitle = value;
			
			if(sourceTitle != ""){
				title.text = "SocialBoard - " + _sourceTitle + " <--Click to go back";
			}else{
				title.text = "SocialBoard";
			}
			
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
					if(sourceTitle != ""){
						title.text = "SocialBoard - " + _sourceTitle + " <--Click to go back";
					}else{
						title.text = "SocialBoard";
					}
					break;
				
				default:
					break;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
	}
}