package com.gread.socialboard.service
{
	import com.digitas.facebook.core.events.FacebookEvent;
	import com.digitas.facebook.core.vo.Friend;
	import com.digitas.facebook.core.vo.NewsFeed;
	import com.gread.socialboard.events.SocialServiceEvent;
	import com.gread.socialboard.model.vo.FeedSourceVO;
	import com.gread.socialboard.model.vo.SocialDataVO;
	import com.gread.socialboard.service.manager.FacebookManager;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class FacebookService implements ISocialService
	{
		private var _manager:FacebookManager;
		
		private var feedDataItems:ArrayCollection;
		
		private var _feedSource:FeedSourceVO;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Bindable]
		public var isAuthenticated:Boolean = false; 
		
		public function FacebookService(){
			
		}
		
		public function init(view:DisplayObject):void{
			_manager = new FacebookManager(FacebookManager.APPID, FacebookManager.permissions, view.parent.stage); //_view.parent.stage
		
			_manager.addEventListener( FacebookEvent.RECEIVED_NEWS_FEEDS, onReceivedNewsFeeds);
			//_manager.addEventListener( FacebookEvent.RECEIVED_FRIENDS, onReceiveFriends);
			_manager.addEventListener( FacebookEvent.INITIALIZED, onInitial);
		}
		
		public function set feedSource(value:FeedSourceVO):void
		{
			_feedSource = value;
		}
		
		public function makeRequest():void
		{
			dispatcher.dispatchEvent(new SocialServiceEvent(SocialServiceEvent.RETURN_DATA_ARRAY, false, false, feedDataItems, isAuthenticated));
		}
		
		protected function onInitial(event:Event):void
		{
			if(_manager.myUserID){
				isAuthenticated = true;
				//_appModel.fbID = _manager.myUserID;
				//getFriendProfile();
				//_appModel.loading = false;
			}else{
				isAuthenticated = false;
			}
			
			dispatcher.dispatchEvent(new SocialServiceEvent(SocialServiceEvent.AUTHENTICATION_STATUS, false, false, null, isAuthenticated));
			
		}
		
		protected function onReceiveFriends(event:Event):void
		{
			var dp:ArrayCollection = new ArrayCollection();
			for each(var item:Friend in _manager.friends){
				dp.addItem(item);
			}
			//_appModel.friends = dp;
		}
		
		protected function onReceivedNewsFeeds(event:Event):void
		{
			// feed source not set
//			if(!_feedSource){
//				return;
//			}
			
			//var newsFeedView:NewsFeedView = _view.newsFeed as NewsFeedView;
			feedDataItems = new ArrayCollection();
			
			for each(var item:NewsFeed in _manager.newsFeeds){
				var newsFeed:SocialDataVO = resultType(item);
				feedDataItems.addItem(newsFeed);
			}
			
			_manager.removeEventListener( FacebookEvent.RECEIVED_NEWS_FEEDS, onReceivedNewsFeeds);
			
			//dispatcher.dispatchEvent(new SocialServiceEvent(SocialServiceEvent.RETURN_DATA_ARRAY, false, false, feedDataItems, isAuthenticated));
			
			
		}
		
		private function resultType(item:NewsFeed):SocialDataVO{
			var newsFeed:SocialDataVO = new SocialDataVO();
			//status / link / picture / video
			switch (item.type){
				case "link":
					newsFeed.messageText = item.message;
					newsFeed.name = item.name;
					newsFeed.title = item.message;
					newsFeed.url = item.link;
					if(item.picture == "" || item.picture == null){
						newsFeed.thumbnailPicPath = "http://graph.facebook.com/" + item.from.id + "/picture"; //"assets/facebook_logo.png";
					}else{
						newsFeed.thumbnailPicPath = item.picture;
					}
					newsFeed.date = item.created_time;
					break;
				
				case "status":
					newsFeed.messageText = item.message;
					newsFeed.name = item.from.name;
					newsFeed.title = item.message;
					newsFeed.url = "http://www.facebook.com/" + item.from.id;
					if(item.picture == "" || item.picture == null){
						newsFeed.thumbnailPicPath = "http://graph.facebook.com/" + item.from.id + "/picture";
					}else{
						newsFeed.thumbnailPicPath =  item.picture;
					}
					newsFeed.date = item.created_time;
					trace(item);
					break;
				
				case "photo":
					newsFeed.messageText = "Photo from " + item.from.name;
					newsFeed.name = item.from.name;
					newsFeed.title = "Photo from " + item.from.name;
					newsFeed.url = item.link;
					if(item.picture == "" || item.picture == null){
						newsFeed.thumbnailPicPath = "http://graph.facebook.com/" + item.from.id + "/picture"; //"assets/facebook_logo.png";
					}else{
						newsFeed.thumbnailPicPath = item.picture;
					}
					newsFeed.date = item.created_time;
					newsFeed.source = item.link; //video source
					trace(item);
					break;
				
				case "video":
					newsFeed.messageText = item.message;
					newsFeed.name = item.name;
					newsFeed.title = item.message;
					newsFeed.url = item.link;
					if(item.picture == "" || item.picture == null){
						newsFeed.thumbnailPicPath = "http://graph.facebook.com/" + item.from.id + "/picture"; //"assets/facebook_logo.png";
					}else{
						newsFeed.thumbnailPicPath = item.picture;
					}
					newsFeed.date = item.created_time;
					newsFeed.source = item.source; //video source
					trace(item);
					break;
					
			}
			
			return newsFeed;
		}
		
	}
}