package com.gread.socialboard.view.home
{
	import mx.containers.Grid;
	
	import spark.components.TileGroup;
	import spark.skins.SparkSkin;
	
	public class SocialGridPanelSkin extends SparkSkin
	{
		public var gridPanel:TileGroup;
		
		public function SocialGridPanelSkin()
		{
			super();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if(!gridPanel){
				gridPanel = new TileGroup();
				addElement(gridPanel);
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			gridPanel.y = 90;
			gridPanel.width = 625;
		}
	}
}