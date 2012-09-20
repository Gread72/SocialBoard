package com.gread.socialboard.model
{
	import com.gread.socialboard.model.vo.FeedSourceVO;
	
	import flash.data.EncryptedLocalStore;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;

	public class ApplicationModel
	{
		private var _selectedSource:FeedSourceVO;
		private var _feedSource:ArrayCollection = new ArrayCollection();
		
		private var _isFBServiceAuthenticated:Boolean = false;
		private var _isTwitterServiceAuthenticated:Boolean = false;
		
		private var _enableFacebook:Boolean = false;
		private var _enableTwitter:Boolean = false;
		
		[Bindable]
		public var currentState:String = "home";
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		public function ApplicationModel()
		{
			trace("ApplicationModel instance");
			
			currentState = "home";
			
		}
		
		[PostConstruct]
		public function init():void {
			trace("ApplicationModel referenced");
			
			var getTwitterObj:Boolean = (retrieveData("socialBoard_twitter") == "false") ? false : true;
			var getFacebookObj:Boolean = (retrieveData("socialBoard_facebook") == "false") ? false : true;
			
			if(getTwitterObj){
				enableTwitter = getTwitterObj;
			}
			
			if(getFacebookObj){
				enableFacebook = getFacebookObj;
			}
			
			
		}
		
		//[Bindable(event="changeEnabledTwitter")]
		
		public function get enableTwitter():Boolean
		{
			return _enableTwitter;
		}

		public function set enableTwitter(value:Boolean):void
		{
			
			_enableTwitter = value;
			
			storeData("socialBoard_twitter", _enableTwitter);
			
			//dispatcher.dispatchEvent(new Event("changeEnabledTwitter"));
		}

		//[Bindable(event="changeEnabledFacebook")]
		
		public function get enableFacebook():Boolean
		{
			return _enableFacebook;
		}

		public function set enableFacebook(value:Boolean):void
		{
			_enableFacebook = value;
			
			storeData("socialBoard_facebook", _enableFacebook);
			
			//dispatcher.dispatchEvent(new Event("changeEnabledFacebook"));
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
		
		private function storeData(key:String, value:Object):void{
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes(value.toString());//create a byte array out of the text we want to encrypt
			EncryptedLocalStore.setItem(key, data); //store the byte array into the encrypted local storage 
		}
		
		private function retrieveData(key:String):Object{
			//using the same key I used when I wrote the data, I reead the bytes back
			var bytes:ByteArray = EncryptedLocalStore.getItem(key);
			var returnObject:Object;
			
			if(bytes)
				//trace(bytes.readUTFBytes(bytes.bytesAvailable));
				returnObject = Object(bytes.readUTFBytes(bytes.bytesAvailable));
			else
				trace("There was no value to be read!");
			
			return returnObject;
		}

	}
}