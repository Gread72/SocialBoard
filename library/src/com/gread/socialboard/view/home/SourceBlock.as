package com.gread.socialboard.view.home
{
	
	import com.gread.socialboard.model.vo.FeedSourceVO;
	
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.Rect;
	
	public class SourceBlock extends SkinnableComponent
	{
		[SkinPart( required="true" )]
		public var recEle:Rect;
		
		[SkinPart(required = "true")]
		public var title:Label;
		
		private var _data:FeedSourceVO;
		
		public function SourceBlock()
		{
			super();
		}
		
		public function get data():FeedSourceVO
		{
			return _data;
		}

		public function set data(value:FeedSourceVO):void
		{
			_data = value;
			
			title.text = _data.name;
			
			this.validateDisplayList();
		}

		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			
			if(partName == "recEle"){
				//
			}
			
			if(partName == "title"){
				//
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
	}
}