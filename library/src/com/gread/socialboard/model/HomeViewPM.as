package com.gread.socialboard.model
{
	import com.gread.socialboard.events.HomeViewEvent;
	import com.gread.socialboard.model.ApplicationModel;
	import com.gread.socialboard.model.vo.FeedSourceVO;
	import com.gread.socialboard.service.FacebookService;
	import com.gread.socialboard.service.HTTPSourceService;
	import com.gread.socialboard.service.ISocialService;
	import com.gread.socialboard.service.TwitterService;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class HomeViewPM
	{
		[Bindable]
		public var socialFeedSources:ArrayCollection = new ArrayCollection;
		
		[Inject]
		public var twitterService:TwitterService;
		
		[Inject]
		public var facebookService:FacebookService;
		
		[Inject]
		public var httpSourceService:HTTPSourceService;
		
		[Inject]
		[Bindable]
		public var appModel:ApplicationModel;
		
		[Bindable]
		public var areServicesReady:Boolean = false;
		
		public function HomeViewPM()
		{
			trace("HomeViewPM instance");
			
			var soc1:FeedSourceVO = new FeedSourceVO();
			soc1.name = "Twitter";
			soc1.type = FeedSourceVO.SOURCE_TYPE_TWITTER;
			//gread72
			soc1.url = "http://api.twitter.com/1/statuses/user_timeline.json";
			soc1.userName = "gread72";
			socialFeedSources.addItem(soc1);
			
			var soc2:FeedSourceVO = new FeedSourceVO();
			soc2.name = "Facebook";
			soc2.type = FeedSourceVO.SOURCE_TYPE_FACEBOOK;
			//gread72
			soc2.url = "";
			soc2.userName = "";
			socialFeedSources.addItem(soc2);
			
			var soc3:FeedSourceVO = new FeedSourceVO();
			soc3.name = "Huffington News";
			soc3.type = FeedSourceVO.SOURCE_TYPE_NEWSFEED;
			soc3.url = "http://feeds.huffingtonpost.com/huffingtonpost/LatestNews";
			soc3.dataFeedType = FeedSourceVO.DATA_FEED_TYPE_XML;
			socialFeedSources.addItem(soc3);
			
			var soc4:FeedSourceVO = new FeedSourceVO();
			soc4.name = "Yahoo US News";
			soc4.type = FeedSourceVO.SOURCE_TYPE_NEWSFEED;
			soc4.url = "http://news.yahoo.com/rss/us";
			soc4.dataFeedType = FeedSourceVO.DATA_FEED_TYPE_XML_RSS;
			socialFeedSources.addItem(soc4);
			
			var soc5:FeedSourceVO = new FeedSourceVO();
			soc5.name = "Wired";
			soc5.type = FeedSourceVO.SOURCE_TYPE_NEWSFEED;
			soc5.url = "http://feeds.wired.com/wired/index";
			soc5.dataFeedType = FeedSourceVO.DATA_FEED_TYPE_XML_RSS;
			socialFeedSources.addItem(soc5);
			
			var soc6:FeedSourceVO = new FeedSourceVO();
			soc6.name = "Yahoo - World";
			soc6.type = FeedSourceVO.SOURCE_TYPE_NEWSFEED;
			soc6.url = "http://news.yahoo.com/rss/world";
			soc6.dataFeedType = FeedSourceVO.DATA_FEED_TYPE_XML_RSS;
			socialFeedSources.addItem(soc6);
			
			var soc7:FeedSourceVO = new FeedSourceVO();
			soc7.name = "Yahoo - Sports";
			soc7.type = FeedSourceVO.SOURCE_TYPE_NEWSFEED;
			soc7.url = "http://news.yahoo.com/rss/sports";
			soc7.dataFeedType = FeedSourceVO.DATA_FEED_TYPE_XML_RSS;
			socialFeedSources.addItem(soc7);
			
			var soc8:FeedSourceVO = new FeedSourceVO();
			soc8.name = "Yahoo - Entertain";
			soc8.type = FeedSourceVO.SOURCE_TYPE_NEWSFEED;
			soc8.url = "http://news.yahoo.com/rss/entertainment";
			soc8.dataFeedType = FeedSourceVO.DATA_FEED_TYPE_XML_RSS;
			socialFeedSources.addItem(soc8);
			
			var soc9:FeedSourceVO = new FeedSourceVO();
			soc9.name = "Yahoo - Science";
			soc9.type = FeedSourceVO.SOURCE_TYPE_NEWSFEED;
			soc9.url = "http://news.yahoo.com/rss/science";
			soc9.dataFeedType = FeedSourceVO.DATA_FEED_TYPE_XML_RSS;
			socialFeedSources.addItem(soc9);
			
		}
		
		private function onCheckService(evt:Event):void{
			if( appModel.isFBServiceAuthenticated && appModel.isTwitterServiceAuthenticated ){
				areServicesReady = true;
			}
			
		}
		
		[PostConstruct]
		public function init():void {
			trace("HomeViewPM referenced");
			
			appModel.dispatcher.addEventListener("CHECK_SERVICES", onCheckService);
		}
		
		[EventHandler( event="SocialFeedSourceEvent.GET_SOCIAL_DATA", properties="data" )]
		public function getFeedSource(data:FeedSourceVO):void{
			//trace("getFeedSource");
			
			switch (data.type){
				case  FeedSourceVO.SOURCE_TYPE_TWITTER:
				twitterService.feedSource = data;
				twitterService.makeRequest();
				break;
				
				case FeedSourceVO.SOURCE_TYPE_FACEBOOK:
				facebookService.feedSource = data;
				facebookService.makeRequest();
				break;
				
				case FeedSourceVO.SOURCE_TYPE_NEWSFEED:
				httpSourceService.feedSource = data;
				httpSourceService.makeRequest();
				break;
				
			}
			
		}
		
		[EventHandler( event="HomeViewEvent.CHANGE_CURRENT_STATE", properties="currentState" )]
		public function setCurrentState(currentState:String):void{
			appModel.currentState = currentState;
			
		}	
	}
}