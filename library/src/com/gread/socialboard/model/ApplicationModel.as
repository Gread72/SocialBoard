package com.gread.socialboard.model
{
	import com.gread.socialboard.model.vo.FeedSourceVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class ApplicationModel
	{
		private var _selectedSource:FeedSourceVO;
		private var _feedSource:ArrayCollection = new ArrayCollection();
		
		private var _isFBServiceAuthenticated:Boolean = false;
		
		private var _isTwitterServiceAuthenticated:Boolean = false;
		
		[Bindable]
		public var currentState:String = "home";
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		public function ApplicationModel()
		{
			trace("ApplicationModel instance");
			
			currentState = "home";
		}
		
		public function get isFBServiceAuthenticated():Boolean
		{
			return _isFBServiceAuthenticated;
		}

		public function set isFBServiceAuthenticated(value:Boolean):void
		{
			_isFBServiceAuthenticated = value;
			
			dispatcher.dispatchEvent(new Event("CHECK_SERVICES"));
		}
		
		public function get isTwitterServiceAuthenticated():Boolean
		{
			return _isTwitterServiceAuthenticated;
		}
		
		public function set isTwitterServiceAuthenticated(value:Boolean):void
		{
			_isTwitterServiceAuthenticated = value;
			
			dispatcher.dispatchEvent(new Event("CHECK_SERVICES"));
		}

		[PostConstruct]
		public function init():void {
			trace("ApplicationModel referenced");
		}
		
		public function get selectedSource():FeedSourceVO
		{
			return _selectedSource;
		}
		
		public function set selectedSource(value:FeedSourceVO):void
		{
			_selectedSource = value;
		}

		[EventHandler( event="SocialFeedSourceEvent.GET_SOCIAL_DATA", properties="data" )]
		public function getFeedSource(data:FeedSourceVO):void{
			trace("getFeedSource");
			
			_selectedSource = data;
			
			currentState = "socialFeed";
		}
		
		[Bindable(event="changeFeedSource")]
		public function get feedSource():ArrayCollection
		{
			return _feedSource;
		}

		public function set feedSource(value:ArrayCollection):void
		{
			_feedSource = value;
			dispatcher.dispatchEvent(new Event("changeFeedSource"));
			
		}

	}
}