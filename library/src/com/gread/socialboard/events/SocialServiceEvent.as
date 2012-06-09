package com.gread.socialboard.events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class SocialServiceEvent extends Event
	{
		public static const RETURN_DATA_ARRAY:String = "returnDataArray";
		
		public static const AUTHENTICATION_STATUS:String = "authenticationStatus";
		
		public var dataArray:ArrayCollection;
		
		public var isAuthentication:Boolean = false;
		
		public function SocialServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, 
										   dataArrayVal:ArrayCollection = null, isAuthenticationVal:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			dataArray = dataArrayVal;
			
			isAuthentication = isAuthenticationVal;
		}
	}
}