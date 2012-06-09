package com.gread.socialboard.service.manager
{
	import com.digitas.facebook.core.FacebookBase;
	import com.digitas.facebook.core.FacebookMobileBase;
	import com.digitas.facebook.core.IFacebookService;
	import com.digitas.facebook.core.events.FacebookEvent;
	import com.digitas.facebook.core.vo.Friend;
	import com.digitas.facebook.core.vo.Image;
	import com.digitas.facebook.core.vo.ImageTag;
	import com.digitas.facebook.core.vo.Like;
	import com.digitas.facebook.core.vo.NewsFeed;
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FQLMultiQuery;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	
	import mx.collections.ArrayCollection;
	
	//import lmld.events.ServiceErrorEvent;
	
	public class FacebookManager extends FacebookMobileBase implements IFacebookService
	{
		public static var APPID:String = "235021199846810";
		public static var permissions:String = "user_photos,friends_photos,user_photo_video_tags,friends_photo_video_tags,publish_stream,user_likes,friends_likes,read_stream";
		
		protected var initializedStatus:uint;
		protected var applicationPhotos:Array;
		protected var _myLikes:Array;
		protected var _usersLikes:Array;
		protected var _friends:Array;
		protected var _minimiumImages:Number;
		protected var _maximiumImages:Number;
		
		protected var photoCollection:Array;
		protected var userID:String;
		protected var photoAlbumsLeftToProcess:Number;
		protected var photosCompleted:Boolean;
		protected var newsfeedCollection:Array;
		
		public function FacebookManager(appID:String, perms:String, stage:Stage)
		{
			super(appID, perms, stage);
			
			_myLikes = [];
			_usersLikes = [];
			_friends = [];
			_minimiumImages = 7
			_maximiumImages = 100;

			
			addEventListener(FacebookEvent.RECEIVED_NEWS_FEEDS, onInitialize);
		}
		
		override protected function getFacebookData():void {
			//getMyFriends(handleGetMyFriends);
			//getMyLikes(handleGetMyLikes);
			getMyNewsFeeds(handleGetMyNewsFeeds);
		}
		
		protected function onInitialize(e:FacebookEvent):void {
			dispatchEvent(new FacebookEvent(FacebookEvent.INITIALIZED));
		}
		
		protected function handleGetMyLikes(success:Object, error:Object):void {
			for (var i:uint = 0; i < success.length; i++) {
				var like:Like = new Like();
				like.category = success[i].category;
				like.created_time = success[i].created_time;
				like.id = success[i].id;
				like.name = success[i].name;
				
				_myLikes.push(like);
			}
			dispatchEvent(new FacebookEvent(FacebookEvent.RECEIVED_LIKES));
		}
		
		protected function handleGetUserLikes(success:Object, error:Object):void {
			for (var i:uint = 0; i < success.length; i++) {
				var like:Like = new Like();
				like.category = success[i].category;
				like.created_time = success[i].created_time;
				like.id = success[i].id;
				like.name = success[i].name;
				
				_usersLikes.push(like);
			}
			dispatchEvent(new FacebookEvent(FacebookEvent.RECEIVED_USERS_LIKES));
		}
		
		protected function handleGetMyFriends(success:Object, error:Object):void {
			for (var i:uint = 0; i < success.length; i++) {
				var friend:Friend = new Friend();
				friend.id = success[i].id;
				friend.name = success[i].name;
				friends.push(friend);
			}
			dispatchEvent(new FacebookEvent(FacebookEvent.RECEIVED_FRIENDS));
		}
		
		protected function handleGetMyNewsFeeds(success:Object, error:Object):void {
			newsfeedCollection = [];
			if(success){
				for (var i:uint = 0; i < success.length; i++) {
					//trace(success);
					var newsfeed:NewsFeed = new NewsFeed;
					newsfeed.id = success[i].id;
					newsfeed.actions = success[i].actions;
					newsfeed.caption = success[i].caption;
					newsfeed.created_time = success[i].created_time;
					newsfeed.description = success[i].description;
					newsfeed.from = success[i].from;
					newsfeed.icon = success[i].icon;
					newsfeed.likes = success[i].likes;
					newsfeed.link = success[i].link;
					newsfeed.message = success[i].message;
					newsfeed.name = success[i].name;
					newsfeed.picture = success[i].picture;
					newsfeed.source = success[i].source;
					newsfeed.type = success[i].type;
					newsfeed.updated_time = success[i].updated_time;
					/**/
					newsfeedCollection.push(newsfeed);
					
				}
				
				dispatchEvent(new FacebookEvent(FacebookEvent.RECEIVED_NEWS_FEEDS));
			}
		}
		
		/*
		//newsfeed = NewsFeedVO( bindVOtoJSONObj(success[i], newsfeed) );
		
		private function bindVOtoJSONObj(jsonOBJ:Object, voObj:Object):Object{
			for each(var item:Object in jsonOBJ){
				trace(item.name);
			}
			
			return voObj;
		}
		*/
		
		protected function handleGetOnlyMyAlbumPhotos(success:Object, error:Object):void {
			for (var i:uint = 0; i < success.length; i++) {
				if (photoCollection.length < _maximiumImages) {
					var image:Image = new Image();
					image.id = success[i].id;
					image.filePath = success[i].picture;
					image.thumbPath = success[i].picture;
					image.name = success[i].name;
					image.priority = 2;
					photoCollection.push(image);
				}
			}
			
			photoAlbumsLeftToProcess -= 1;
			
			if (photoAlbumsLeftToProcess == 0 && photoCollection.length < _minimiumImages)
				//dispatchEvent(new ServiceErrorEvent(ServiceErrorEvent.NOT_ENOUGH_PHOTOS));
			
			if (photoAlbumsLeftToProcess == 0 && photosCompleted != true) {
				photosCompleted = true;
				dispatchEvent(new FacebookEvent(FacebookEvent.PHOTOS_COMPLETE));
			}
		}
		
		private function getTaggedPhotos():void {
			var multiQuery:FQLMultiQuery = new FQLMultiQuery();
			multiQuery.add("SELECT pid FROM photo_tag WHERE subject=me()", "myTags");
			multiQuery.add("SELECT pid FROM photo_tag WHERE subject=" + userID, "theirTags");
			fqlMultiQuery(multiQuery, processTaggedPhotos);
		}
		
		protected function processTaggedPhotos(success:Object, error:Object):void {
			var smallTagList:Array = (success.myTags < success.theirTags) ? success.myTags : success.theirTags;
			var largeTagList:Array = (success.myTags > success.theirTags) ? success.myTags : success.theirTags;
			var commonTags:Array = [];
			
			// find common tags
			for (var i:uint = 0; i < smallTagList.length; i++) {
				for (var j:uint = 0; j < largeTagList.length; j++) {
					if (smallTagList[i].pid == largeTagList[j].pid) {
						commonTags.push(smallTagList[i].pid);
					}
				}
			}
			
			var select:String = 'SELECT src_big, pid, src_small, caption FROM photo WHERE pid IN (';
			
			// build the select statement
			for (var k:uint = 0; k < commonTags.length; k++) {
				if (k == (commonTags.length - 1))
					select += commonTags[k].toString() + ") ORDER BY created DESC";
				else
					select += commonTags[k].toString() + ",";
			}
			fqlQuery(select, addTaggedPhotosToCollection);
			
			getUserLikes(userID, handleGetUserLikes);
			addEventListener(FacebookEvent.RECEIVED_USERS_LIKES, processLikedPhotos);
		}
		
		protected function addTaggedPhotosToCollection(success:Object, error:Object):void {
			if (error) {
				// dispatch error	
			}
			
			for (var i:uint = 0; i < success.length; i++) {
				var image:Image = new Image();
				image.id = success[i].pid;
				image.filePath = success[i].src_big;
				image.thumbPath = success[i].src_small;
				image.name = success[i].caption;
				image.priority = 0;
				
				photoCollection.push(image);
			}
		}
		
		protected function processLikedPhotos(uid:String):void {
			var photosNeeded:Number = _minimiumImages - photoCollection.length;
			
			// get all my likes
			for (var i:uint = 0; i < _myLikes.length; i++) {
				// get all of the users likes
				for (var j:uint = 0; j < _usersLikes.length; j++) {
					// if we have a similiar like, make the API call to get it
					if (_myLikes[i].id == _usersLikes[j].id) {
						Facebook.api("/" + _myLikes[i].id, addLikeImageToCollection);
						photosNeeded -= 1;
					}
				}
			}
			
			if (photosNeeded > 0)
				//dispatchEvent(new ServiceErrorEvent(ServiceErrorEvent.NOT_ENOUGH_PHOTOS));
			
			getMyAlbums(handleGetMyAlbums);
		}
		
		protected function handleGetMyAlbums(success:Object, error:Object):void {
			photoAlbumsLeftToProcess = success.length;
			photosCompleted = false;
			
			for (var i:uint = 0; i < success.length; i++) {
				var albumID:String = success[i].id;
				getAlbumPhotos(albumID, handleGetAlbumPhotos);
			}
		}
		
		protected function handleGetAlbumPhotos(success:Object, error:Object):void {
			for (var i:uint = 0; i < success.length; i++) {
				if (photoCollection.length < _maximiumImages) {
					var image:Image = new Image();
					image.id = success[i].id;
					image.filePath = success[i].source;
					image.thumbPath = success[i].picture;
					image.name = success[i].name;
					image.priority = 2;
					photoCollection.push(image);
				}
			}
			
			photoAlbumsLeftToProcess -= 1;
			
			if (photoAlbumsLeftToProcess == 0 && photoCollection.length < _minimiumImages){
				//dispatchEvent(new ServiceErrorEvent(ServiceErrorEvent.NOT_ENOUGH_PHOTOS));
			}else if (photoAlbumsLeftToProcess == 0){
				dispatchEvent(new FacebookEvent(FacebookEvent.PHOTOS_COMPLETE));
			}
		}
		
		protected function addLikeImageToCollection(success:Object, error:Object):void {
			if (success) {
				var image:Image = new Image();
				image.id = success.id;
				image.filePath = success.picture;
				image.thumbPath = success.picture;
				image.name = success.name;
				image.priority = 1;
				photoCollection.push(image);
			}
		}
		
		public function getPhotos(uid:String = null):void {
			userID = uid;
			photoCollection = [];
			getTaggedPhotos();
		}
		
		public function getMyPhotos():void {
			photoCollection = [];
			getMyAlbums(handleGetMyAlbums);
		}
		
		public function set minimiumImages(value:Number):void {
			_minimiumImages = value;
		}
		
		public function get photos():Array {
			return photoCollection;
		}
		
		public function get friends():Array {
			return _friends;
		}
		
		public function get newsFeeds():Array {
			return newsfeedCollection;
		}
		
		public function refresh():void{
			getMyNewsFeeds(handleGetMyNewsFeeds);
		}
		
	}
}