package com.gread.socialboard.service
{
	
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONDecoder;
	import com.gread.socialboard.events.SocialServiceEvent;
	import com.gread.socialboard.model.vo.FeedSourceVO;
	import com.gread.socialboard.model.vo.SocialDataVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;
	import org.iotashan.utils.URLEncoding;
	import org.soenkerohde.Tweeter.event.TwitterOAuthEvent;
	import org.soenkerohde.Tweeter.event.TwitterStatusEvent;
	import org.soenkerohde.Tweeter.event.TwitterUserEvent;
	

	public class TwitterService implements ISocialService, IOAuth
	{
		public static const VERIFY_CREDENTIALS:String = "https://twitter.com/account/verify_credentials.json";
		public static const REQUEST_TOKEN:String = "http://twitter.com/oauth/request_token";
		public static const ACCESS_TOKEN:String = "http://twitter.com/oauth/access_token";
		public static const AUTHORIZE:String = "http://twitter.com/oauth/authorize";
		public static const SET_STATUS:String = "https://twitter.com/statuses/update.json";
		public static const GET_STATUSES_HOME_TIMELINE:String = "http://api.twitter.com/1/statuses/home_timeline.json";
		
		private var _feedSource:FeedSourceVO;
		//private var _httpService:HTTPService;
		private var feedDataItems:ArrayCollection;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		public var errorOccurred:Boolean = false;
		
		public function TwitterService( consumerKey : String = null, consumerSecret : String = null)
		{
			/*
			_httpService = new HTTPService();
			_httpService.resultFormat = "text";
			_httpService.method = "GET";
			
			_httpService.addEventListener(ResultEvent.RESULT, resultHandler); 
			_httpService.addEventListener(FaultEvent.FAULT, faultHandler);
			*/
			
			consumerKey = "ik1jNZrFIjx0B3DVjsLYXQ";
			consumerSecret = "MPVNAc5pwsBQP1VlgXc1fIrPhAa6tYDLJwXMzDQ6M";
			
			_consumerKey = consumerKey;
			_consumerSecret = consumerSecret;
			
			
		}
		/*
		protected function faultHandler(event:FaultEvent):void
		{
			// TODO Auto-generated method stub
			trace("faultHandler " + event.message);
		}
		
		protected function resultHandler(event:ResultEvent):void
		{
			// TODO Auto-generated method stub
			trace("resultHandler " + event.result);
			
			var feedDataItems:ArrayCollection = new ArrayCollection();
			
			var resultObj:Object = com.adobe.serialization.json.JSON.decode(event.result.toString());
			
			for( var item:Object in resultObj){
				
				var tweet:SocialDataVO = new SocialDataVO();
				
				tweet.messageText = resultObj[item].user.description;
				tweet.name = resultObj[item].user.screen_name;
				tweet.title = resultObj[item].text;
				tweet.url = resultObj[item].user.url;
				tweet.thumbnailPicPath = resultObj[item].user.profile_image_url;
				//tweet.picPath = 
				tweet.date = resultObj[item].created_at;
				
				feedDataItems.addItem(tweet);
			}
			
			dispatcher.dispatchEvent(new SocialServiceEvent(SocialServiceEvent.RETURN_DATA_ARRAY, false, false, feedDataItems));
			
		}
		*/
		
		public function set feedSource(value:FeedSourceVO):void
		{
			_feedSource = value;
			
			//_httpService.url = _feedSource.url + '?screen_name=' + _feedSource.userName; 
			//url="http://api.twitter.com/1/statuses/user_timeline.json?screen_name=gread72"
		}
		
		public function makeRequest():void{
			//_httpService.send();
			dispatcher.dispatchEvent(new SocialServiceEvent(SocialServiceEvent.RETURN_DATA_ARRAY, false, false, feedDataItems, true));
		}


///
		
		public static function getTokenFromResponse( tokenResponse : String ) : OAuthToken {
			var result:OAuthToken = new OAuthToken();
			
			var params:Array = tokenResponse.split( "&" );
			for each ( var param : String in params ) {
				var paramNameValue:Array = param.split( "=" );
				if ( paramNameValue.length == 2 ) {
					if ( paramNameValue[0] == "oauth_token" ) {
						result.key = paramNameValue[1];
					} else if ( paramNameValue[0] == "oauth_token_secret" ) {
						result.secret = paramNameValue[1];
					}
				}
			}
			
			return result;
		}
		
		protected var signature:OAuthSignatureMethod_HMAC_SHA1 = new OAuthSignatureMethod_HMAC_SHA1();
		
		protected var requestToken:OAuthToken;
		protected var accessToken:OAuthToken;
		
		private var _consumerKey:String;
		private var _consumerSecret:String;
		
		private var _consumer:OAuthConsumer;
		
		
		public function set consumerKey( key : String ) : void {
			_consumerKey = key;
		}
		
		public function set consumerSecret( secret : String ) : void {
			_consumerSecret = secret;
		}
		
		private function get consumer() : OAuthConsumer {
			if ( _consumer == null && _consumerKey != null && _consumerSecret != null ) {
				_consumer = new OAuthConsumer( _consumerKey, _consumerSecret );
			}
			return _consumer;
		}
		
		public function setAccessToken( token : OAuthToken ) : void {
			accessToken = token;
		}
		
		public function authenticate() : void {
			var oauthRequest:OAuthRequest = new OAuthRequest( "GET", REQUEST_TOKEN, { oauth_callback: "oob" }, consumer, null );
			var request:URLRequest = new URLRequest( oauthRequest.buildRequest( signature ) );
			var loader:URLLoader = new URLLoader( request );
			loader.addEventListener( Event.COMPLETE, requestTokenHandler );
		}
		
		protected function requestTokenHandler( e : Event ) : void {
			requestToken = getTokenFromResponse( e.currentTarget.data as String );
			if ( dispatcher.dispatchEvent( new TwitterOAuthEvent( TwitterOAuthEvent.REQUEST_TOKEN, requestToken ) ) ) {
				var request:URLRequest = new URLRequest( AUTHORIZE + "?oauth_token=" + requestToken.key );
				navigateToURL( request, "_blank" );
			}
		}
		
		public function obtainAccessToken( pin : uint ) : void {
			var oauthRequest:OAuthRequest = new OAuthRequest( "GET", ACCESS_TOKEN, { oauth_verifier: pin }, consumer, requestToken );
			var request:URLRequest = new URLRequest( oauthRequest.buildRequest( signature, OAuthRequest.RESULT_TYPE_URL_STRING ) );
			request.method = "GET";
			
			var loader:URLLoader = new URLLoader( request );
			loader.addEventListener( Event.COMPLETE, accessTokenResultHandler );
		}
		
		protected function accessTokenResultHandler( event : Event ) : void {
			var accessToken:OAuthToken = getTokenFromResponse( event.currentTarget.data as String );
			if ( dispatcher.dispatchEvent( new TwitterOAuthEvent( TwitterOAuthEvent.ACCESS_TOKEN, accessToken ) ) ) {
				setAccessToken( accessToken );
			}
		}
		
		public function verifyAccessToken( token : OAuthToken ) : void {
			try{
				var oauthRequest:OAuthRequest = new OAuthRequest( "GET", VERIFY_CREDENTIALS, null, consumer, token );
				var request:URLRequest = new URLRequest( oauthRequest.buildRequest( signature, OAuthRequest.RESULT_TYPE_URL_STRING ) );
				request.method = "GET";
				
				var loader:URLLoader = new URLLoader( request );
				loader.addEventListener( Event.COMPLETE, verifyAccessTokenHandler );
				loader.addEventListener(IOErrorEvent.IO_ERROR , onIOError);
				setHomeTimeline( token );
			}catch(e:Error){
				trace("IOError - TwitterService");
				errorOccurred = true;
			}
			
		}
		
		protected function verifyAccessTokenHandler( event : Event ) : void {
			var decoder:JSONDecoder = new com.adobe.serialization.json.JSONDecoder( event.currentTarget.data );
			var value:Object = decoder.getValue();
			var screenName:String = value.screen_name;
			dispatcher.dispatchEvent( new TwitterUserEvent( TwitterUserEvent.USER_INFO, screenName ) );
		}
		
		public function setStatus( accessToken : OAuthToken, status : String ) : void {
			// create OAuthRequest
			var oauthRequest:OAuthRequest = new OAuthRequest( "POST", SET_STATUS, { status: status }, consumer, accessToken );
			
			// build request URL from OAuthRequst
			var requestUrl:String = oauthRequest.buildRequest( new OAuthSignatureMethod_HMAC_SHA1(), OAuthRequest.RESULT_TYPE_URL_STRING );
			// new URLReuqest with URL and OAuth params
			var request:URLRequest = new URLRequest( requestUrl );
			request.method = "POST";
			
			// remove status message param from URL since it is a post request
			request.url = request.url.replace( "&status=" + URLEncoding.encode( status ), "" );
			// add status message to request data
			request.data = new URLVariables( "status=" + status );
			
			if ( dispatcher.dispatchEvent( new TwitterStatusEvent( TwitterStatusEvent.STATUS_SENDING ) ) ) {
				var loader:URLLoader = new URLLoader( request );
				loader.addEventListener( Event.COMPLETE, statusResultHandler );
			}
		}
		
		protected function statusResultHandler( event : Event ) : void {
			dispatcher.dispatchEvent( new TwitterStatusEvent( TwitterStatusEvent.STATUS_SEND ) );
		}
		
		public function setHomeTimeline( token : OAuthToken ) : void {
			try{
				var oauthRequest:OAuthRequest = new OAuthRequest( "GET", GET_STATUSES_HOME_TIMELINE, null, consumer, token );
				var request:URLRequest = new URLRequest( oauthRequest.buildRequest( signature, OAuthRequest.RESULT_TYPE_URL_STRING ) );
				request.method = "GET";
				
				var loader:URLLoader = new URLLoader( request );
				loader.addEventListener( Event.COMPLETE, setHomeTimelineResultHandler );
				loader.addEventListener(IOErrorEvent.IO_ERROR , onIOError);
			}catch(e:Error){
				trace("IOError - TwitterService");
				errorOccurred = true;
			}
			
		}
		
		protected function onIOError(event:IOErrorEvent):void
		{
			trace("IOError - TwitterService");
			errorOccurred = true;
		}
		
		protected function setHomeTimelineResultHandler(event:Event):void
		{
			trace("setHomeTimelineResultHandler");
			
			// feed source not set
//			if(!_feedSource){
//				return;
//			}
			
			feedDataItems = new ArrayCollection();
			
			var resultObj:Object = com.adobe.serialization.json.JSON.decode(event.currentTarget.data.toString());
			
			for( var item:Object in resultObj){
				
				var tweet:SocialDataVO = new SocialDataVO();
				
				tweet.messageText = resultObj[item].user.description;
				tweet.name = resultObj[item].user.screen_name;
				tweet.title = resultObj[item].text;
				tweet.url = "http://twitter.com/" + resultObj[item].user.screen_name;
				tweet.thumbnailPicPath = resultObj[item].user.profile_image_url;
				tweet.source = resultObj[item].user.url;
				tweet.date = resultObj[item].created_at;
				
				feedDataItems.addItem(tweet);
			}
			
			//dispatcher.dispatchEvent(new SocialServiceEvent(SocialServiceEvent.RETURN_DATA_ARRAY, false, false, feedDataItems, true));
			//dispatcher.dispatchEvent(new SocialServiceEvent(SocialServiceEvent.AUTHENTICATION_STATUS, false, false, null, true));
			
			
//			var resultObj:Object = com.adobe.serialization.json.JSON.decode(event.currentTarget.data.toString());
//			
//			_timelineTweets.removeAll();
//			
//			for( var item:Object in resultObj){
//				var user:UserVO = new UserVO();
//				var tweet:TweetVO = new TweetVO();
//				
//				user.description = resultObj[item].user.description;
//				user.followers_count = resultObj[item].user.followers_count;
//				user.friends_count = resultObj[item].user.friends_count;
//				user.id = resultObj[item].user.id;
//				user.location = resultObj[item].user.location;
//				user.name = resultObj[item].user.name;
//				user.profile_image_url = resultObj[item].user.profile_image_url;
//				user.screen_name = resultObj[item].user.screen_name;
//				user.url = resultObj[item].user.url;
//				
//				tweet.user = user;
//				tweet.text = resultObj[item].text;
//				tweet.created_at = resultObj[item].created_at;
//				
//				_timelineTweets.addItem(tweet);
//			}
			
		}
		

	}
}