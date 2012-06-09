package com.gread.socialboard.model
{
	import com.gread.socialboard.model.vo.FeedSourceVO;
	import com.gread.socialboard.service.TwitterService;
	import com.gread.socialboard.view.home.TwitterAuthPanel;
	
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	
	import org.iotashan.oauth.OAuthToken;
	import org.soenkerohde.Tweeter.event.TwitterOAuthEvent;
	import org.soenkerohde.Tweeter.event.TwitterStatusEvent;
	import org.soenkerohde.Tweeter.event.TwitterUserEvent;
	
	public class TwitterAuthPanelPM
	{
		private var accessToken:OAuthToken;
		
		[Bindable]
		public var pinPending:Boolean = false;
		
		[Bindable]
		public var statusPending:Boolean = false;
		
		[Bindable]
		public var screenName:String;
		
		[Bindable]
		public var viewPinText:String;
		
		[Bindable]
		public var viewStatusMessageText:String
		
		[Bindable]
		public var currentState:String = "initial";
		
		private var token:Object;
		
		[Inject]
		[Bindable]
		public var twitter:TwitterService;
		
		[Inject]
		[Bindable]
		public var appModel:ApplicationModel;
		
		public function TwitterAuthPanelPM(){ }

		public function authenticate() : void {
			try{
				var file:File = File.applicationStorageDirectory.resolvePath("mta.fas");
				
				if(twitter.errorOccurred && file.exists){
					file.deleteFile();
					token = null;
					twitter.errorOccurred = false;
				}else{
					if(file.exists){
						var fileStream:FileStream = new FileStream();
						fileStream.open(file, FileMode.READ);
						token = fileStream.readObject();
						fileStream.close();
					}
				}
			
				//var so:SharedObject = SharedObject.getLocal( "twitter" );
				//var token:Object = so.data["accessToken"];
				// user has already an AccessToken
				if ( token != null ) {
					appModel.isTwitterServiceAuthenticated = false;
					CursorManager.setBusyCursor();
					accessToken = new OAuthToken( token.key, token.secret );
					verifyAccessToken( accessToken );
					// user is not authenticated yet
				} else {
					currentState = "unauthenticated";
					twitter.authenticate();
					appModel.isTwitterServiceAuthenticated = false;
				}
			}catch(e:Error){
				trace("Error Occurred");
			}
			
			
		}
		protected function verifyAccessToken( token : OAuthToken ) : void {
			try{
				twitter.dispatcher.addEventListener( TwitterUserEvent.USER_INFO, userInfoHandler );
				twitter.dispatcher.addEventListener( TwitterUserEvent.USER_ERROR, userErrorHandler );
				twitter.dispatcher.addEventListener( IOErrorEvent.IO_ERROR , onIOError);
				twitter.verifyAccessToken( token );
			}catch(e:Error){
				trace("Error Occurred");
			}
			
		}
		
		private function onIOError():void
		{
			trace("Error Occurred");
		}
		
		private function userInfoHandler( event : TwitterUserEvent ) : void {
			currentState = "authenticated";
			appModel.isTwitterServiceAuthenticated = true;
			CursorManager.removeBusyCursor();
			screenName = event.screenName;
			twitter.dispatcher.removeEventListener( TwitterUserEvent.USER_INFO, userInfoHandler );
			twitter.dispatcher.removeEventListener( TwitterUserEvent.USER_ERROR, userErrorHandler );
		}
		private function userErrorHandler( event : TwitterUserEvent ) : void {
			currentState = "unauthenticated";
			
			CursorManager.removeBusyCursor();
			twitter.dispatcher.removeEventListener( TwitterUserEvent.USER_INFO, userInfoHandler );
			twitter.dispatcher.removeEventListener( TwitterUserEvent.USER_ERROR, userErrorHandler );
		}
		public function pinClickHandler( value:String ) : void {
			viewPinText = value;
			pinPending = true;
			CursorManager.setBusyCursor();
			twitter.dispatcher.addEventListener( TwitterOAuthEvent.ACCESS_TOKEN, accessTokenHandler );
			twitter.obtainAccessToken( int( viewPinText ) );
		}
		private function accessTokenHandler( event : TwitterOAuthEvent ) : void {
			var file:File = File.applicationStorageDirectory.resolvePath("mta.fas");
			if(file.exists) file.deleteFile();
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeObject(event.token);
			fileStream.close();
			
			//				var so:SharedObject = SharedObject.getLocal( "twitter" );
			//				so.data["accessToken"] = event.token;
			//				so.flush();
			
			currentState = "authenticated";
			pinPending = false;
			CursorManager.removeBusyCursor();
			twitter.dispatcher.removeEventListener( TwitterOAuthEvent.ACCESS_TOKEN, accessTokenHandler );
			verifyAccessToken( event.token );
		}
		public function statusClickHandler( value:String ) : void {
			viewStatusMessageText = value;
			statusPending = true;
			CursorManager.setBusyCursor();
			twitter.dispatcher.addEventListener( TwitterStatusEvent.STATUS_SEND, statusSendHandler );
			twitter.setStatus( accessToken,  viewStatusMessageText);
		}
		private function statusSendHandler( event : TwitterStatusEvent ) : void {
			//Alert.show( "Your message was successfully sent.", "Status Updated" );
			statusPending = false;
			viewStatusMessageText = "";
			CursorManager.removeBusyCursor();
			twitter.dispatcher.removeEventListener( TwitterStatusEvent.STATUS_SEND, statusSendHandler );
		}
		public function logoutClickHandler( event : MouseEvent ) : void {
			// to clear out stored values - for testing 
			//				var file:File = File.applicationStorageDirectory.resolvePath("mta.fas");
			//				if(file.exists) file.deleteFile();
			//				token = null;
			
			currentState = "unauthenticated";
			authenticate();
		}
		
		
	}
}