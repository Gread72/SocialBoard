package com.gread.socialboard.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class FeedSourceVO
	{
		public static var SOURCE_TYPE_FACEBOOK:String = "sourceTypeFacebook";
		public static var SOURCE_TYPE_TWITTER:String = "sourceTypeTwitter";
		public static var SOURCE_TYPE_NEWSFEED:String = "sourceTypeNewsFeed";
		
		public static var DATA_FEED_TYPE_JSON:String = "json";
		public static var DATA_FEED_TYPE_XML:String = "xml";
		public static var DATA_FEED_TYPE_XML_RSS:String = "xmlRSS";
		
		public var name:String
		public var type:String;
		public var url:String;
		public var userName:String;
		public var password:String;
		public var dataFeedType:String = DATA_FEED_TYPE_JSON;
		public var socialDataArray:ArrayCollection;
	}
}