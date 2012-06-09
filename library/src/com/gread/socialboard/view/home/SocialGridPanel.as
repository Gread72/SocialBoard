package com.gread.socialboard.view.home
{
	import com.gread.socialboard.events.SocialFeedSourceEvent;
	import com.gread.socialboard.model.vo.FeedSourceVO;
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElement;
	
	import spark.components.TileGroup;
	import spark.components.supportClasses.SkinnableComponent;
	
	
	public class SocialGridPanel extends SkinnableComponent
	{
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[SkinPart(required = "true")]
		public var gridPanel:TileGroup;
		
		private var _dataProvider:ArrayCollection;
		
		public function SocialGridPanel()
		{
			super();
		}
		
		public function set dataProvider(value:ArrayCollection):void
		{
			_dataProvider = value;
			var instanceNum:Number = 0;
			
			for each(var service:FeedSourceVO in _dataProvider){
				SourceBlock(gridPanel.getChildAt(instanceNum)).data = service;
				instanceNum++;
			}
		}

		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			
			if(partName == "gridPanel"){
			
				for( var i:Number = 1; i <= 9; i++){
					gridPanel.addElement(createRectBlock());	
				}
				
				gridPanel.addEventListener(MouseEvent.CLICK,  onGridClick);
			}
		}
		
		protected function onGridClick(event:MouseEvent):void
		{
			trace("onGridClick");
			
			if(event.target is SourceBlockSkin && event.target.owner.data){
				trace(event.target.owner.data.name);
				dispatcher.dispatchEvent(new SocialFeedSourceEvent(SocialFeedSourceEvent.GET_SOCIAL_DATA, false, false, event.target.owner.data));
			}
		}
		
		private function createRectBlock():IVisualElement{
			var sourceBlock:SourceBlock = new SourceBlock();
			sourceBlock.setStyle("skinClass", SourceBlockSkin);
			return sourceBlock;
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
	}
}