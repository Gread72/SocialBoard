package com.gread.socialboard.events
{
	import flash.events.Event;
	
	public class HomeViewEvent extends Event
	{
		public static const CHANGE_CURRENT_STATE:String = "changeCurrentState";
		
		public var currentState:String;
		
		
		public function HomeViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, currentStateVal:String = "")
		{
			super(type, bubbles, cancelable);
				
			currentState = currentStateVal;
		}
		
	}
}