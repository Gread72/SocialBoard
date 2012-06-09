package com.gread.socialboard.events
{
	import com.gread.socialboard.model.vo.FeedSourceVO;
	
	import flash.events.Event;
	
	public class SocialFeedSourceEvent extends Event
	{
		public static const GET_SOCIAL_DATA:String = "getSocialData";
		
		public var data:FeedSourceVO;
		
		public function SocialFeedSourceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, dataVal:FeedSourceVO = null)
		{
			super(type, bubbles, cancelable);
			
			data = dataVal;
		}
		
	}
}