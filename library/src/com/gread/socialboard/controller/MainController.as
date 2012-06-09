package com.gread.socialboard.controller
{
	import com.gread.socialboard.model.ApplicationModel;
	import com.gread.socialboard.model.HomeViewPM;
	import com.gread.socialboard.model.vo.FeedSourceVO;

	public class MainController
	{

		
		[Inject]
		[Bindable]
		public var appModel:ApplicationModel;
		
		public function MainController()
		{

		}
	}
}