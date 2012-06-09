package com.gread.socialboard.view.socialFeed
{
	import com.gread.socialboard.model.vo.SocialDataVO;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	
	
	public class SocialFeedDisplayItem extends SkinnableComponent
	{
		[SkinPart(required = "true")]
		public var feedName:Label;
		
		[SkinPart(required = "true")]
		public var feedTitle:Label;
		
		[SkinPart(required = "true")]
		public var profileImg:Image;
		
		private var _data:SocialDataVO;
		
		public function get data():SocialDataVO
		{
			return _data;
		}
		
		public function set data(value:SocialDataVO):void
		{
			_data = value;
			
			this.validateDisplayList();
		}
		
		public function SocialFeedDisplayItem()
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
				case "feedName":
					feedName.text = _data.name;
					feedName.setStyle("fontFamily", "BigCaslon");
					feedName.addEventListener(MouseEvent.CLICK, onClickFeedName);
					break;
				
				case "profileImg":
					var imageSrc:Loader = new Loader();
					if(_data.thumbnailPicPath){
						imageSrc.load(new URLRequest(_data.thumbnailPicPath));
						imageSrc.contentLoaderInfo.addEventListener(Event.COMPLETE, function(evt:Event):void{
							//trace(evt.target);
							profileImg.source = evt.target.content;
						});
					}
					break;
				
				case "feedTitle":
					feedTitle.text = _data.title;
					feedTitle.setStyle("fontFamily", "BigCaslon");
					feedTitle.addEventListener(MouseEvent.CLICK, onClickFeedTitle);
					break;
				
				default:
					break;
			}
			
			
		}
		
		protected function onClickFeedTitle(event:MouseEvent):void
		{
			dispatchEvent(new DataEvent("POPUP_URL", true, false, _data.url));
		}
		
		protected function onClickFeedName(event:MouseEvent):void
		{
			dispatchEvent(new DataEvent("POPUP_URL", true, false, _data.url));
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
	}
}