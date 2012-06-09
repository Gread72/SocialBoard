package com.gread.socialboard.model
{
	import com.gread.socialboard.model.vo.FeedSourceVO;
	import com.gread.socialboard.service.FacebookService;
	import com.gread.socialboard.view.home.FacebookPanel;
	
	import flash.display.DisplayObject;

	public class FacebookPanelPM
	{
		public static const FB_STATUS_NOT_AUTHENTICATED:String = "Not Authenticated.";
		public static const FB_STATUS_AUTHENTICATED:String = "Authenticated.";
		
		[Inject]
		[Bindable]
		public var facebook:FacebookService;
		
		[Inject]
		[Bindable]
		public var appModel:ApplicationModel;
		
		[Bindable]
		public var status:String = FB_STATUS_NOT_AUTHENTICATED;
		
		
		
		private var currentView:FacebookPanel;
		
		public function FacebookPanelPM()
		{
		}
		
		public function getFacebookContent(view:FacebookPanel):void{
			currentView = view;
			
			facebook.init(DisplayObject(view));
		}
		
		
		[EventHandler( event="SocialServiceEvent.AUTHENTICATION_STATUS", properties="isAuthentication" )]
		public function isAuth(isAuthentication:Boolean):void{
			if(isAuthentication){
				status = FB_STATUS_AUTHENTICATED;
				currentView.setUpFBBtn.visible = false;
				appModel.isFBServiceAuthenticated = true;
			}else{
				status = FB_STATUS_NOT_AUTHENTICATED;
				currentView.setUpFBBtn.visible = true;
				appModel.isFBServiceAuthenticated = false;
			}
			
		}
	}
}