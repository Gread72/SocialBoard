package com.gread.socialboard.model
{
	import mx.collections.ArrayCollection;

	public class SocialFeedViewPM
	{
		[Bindable]
		public var socialFeedData:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var titleOfSource:String = "";
		
		[Inject]
		[Bindable]
		public var appModel:ApplicationModel;
		
		public function SocialFeedViewPM(){}
		
		[EventHandler( event="SocialServiceEvent.RETURN_DATA_ARRAY", properties="dataArray" )]
		public function returnDataFeed(dataArray:ArrayCollection):void{
			//socialFeedData = new ArrayCollection(); 
			socialFeedData = dataArray;
			
			titleOfSource = appModel.selectedSource.name;
		}
		
		
	}
}