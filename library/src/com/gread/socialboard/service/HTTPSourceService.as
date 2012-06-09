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
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class HTTPSourceService implements ISocialService
	{
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		private var _feedSource:FeedSourceVO;
		private var _httpService:HTTPService;
		
		public function HTTPSourceService()
		{
			_httpService = new HTTPService();
			_httpService.resultFormat = "text";
			_httpService.method = "GET";
			
			_httpService.addEventListener(ResultEvent.RESULT, resultHandler); 
			_httpService.addEventListener(FaultEvent.FAULT, faultHandler);
		}
		
		protected function faultHandler(event:FaultEvent):void
		{
			// TODO Auto-generated method stub
			trace("faultHandler " + event.message);
		}
		
		protected function resultHandler(event:ResultEvent):void
		{
			// TODO Auto-generated method stub
			//trace("resultHandler " + event.result);
			
			var feedDataItems:ArrayCollection = new ArrayCollection();
			var XMLData:XML;
			var dataArray:Array;
			var rssSocialXMLData:SocialDataVO;
			var entry:Object;
			
			if(_feedSource.dataFeedType == FeedSourceVO.DATA_FEED_TYPE_JSON){
				var resultObj:Object = com.adobe.serialization.json.JSON.decode(event.result.toString());
				
				for( var item:Object in resultObj){
					
					var rssSocialData:SocialDataVO = new SocialDataVO();
					
					rssSocialData.messageText = resultObj[item].user.description;
					rssSocialData.name = resultObj[item].user.screen_name;
					rssSocialData.title = resultObj[item].text;
					rssSocialData.url = resultObj[item].user.url;
					rssSocialData.thumbnailPicPath = resultObj[item].user.profile_image_url;
					//tweet.picPath = 
					rssSocialData.date = resultObj[item].created_at;
					
					feedDataItems.addItem(rssSocialData);
				}
			}else if(_feedSource.dataFeedType == FeedSourceVO.DATA_FEED_TYPE_XML){
				XMLData = XML(event.result);
				dataArray = parseXML(XMLData, "entry");
				
				for(entry in dataArray){
					//trace(dataArray[entry]);
					rssSocialXMLData = new SocialDataVO();
					rssSocialXMLData.messageText = getXMLValue( dataArray[entry].content ); //dataArray[entry].content.children()[0];
					rssSocialXMLData.name = getXMLValue(dataArray[entry].author, "name"); //dataArray[entry].author.children()[0].children()[0];
					rssSocialXMLData.title = getXMLValue(dataArray[entry].title) //dataArray[entry].title.children()[0];
					rssSocialXMLData.url = dataArray[entry].link.attribute("href");
					rssSocialXMLData.thumbnailPicPath = "assets/rss_logo.png";
					//tweet.picPath = 
					rssSocialXMLData.date = getXMLValue(dataArray[entry].published);
					
					feedDataItems.addItem(rssSocialXMLData);
					
				}

			}else if(_feedSource.dataFeedType == FeedSourceVO.DATA_FEED_TYPE_XML_RSS){
				XMLData = XML(event.result);
				
				var xmlList:XMLList = XMLData.channel;
				
				dataArray = parseXML(XML(xmlList.toXMLString()), "item");
				
				for(entry in dataArray){
					
					// yahoo
					if(!dataArray[entry].creator){
						rssSocialXMLData = new SocialDataVO();
						rssSocialXMLData.messageText = getXMLValue( dataArray[entry].description ); //dataArray[entry].content.children()[0];
						rssSocialXMLData.name = getXMLValue(dataArray[entry].source); //dataArray[entry].author.children()[0].children()[0];
						rssSocialXMLData.title = getXMLValue(dataArray[entry].title); //dataArray[entry].title.children()[0];
						rssSocialXMLData.url = getXMLValue(dataArray[entry].link);
						rssSocialXMLData.thumbnailPicPath = "assets/rss_logo.png";
						rssSocialXMLData.date = getXMLValue(dataArray[entry].pubDate);
						feedDataItems.addItem(rssSocialXMLData);
					}else{ // wired
						rssSocialXMLData = new SocialDataVO();
						if(dataArray[entry].encoded){
							rssSocialXMLData.messageText = getXMLValue( dataArray[entry].encoded ); //dataArray[entry].content.children()[0];
						}
						if(dataArray[entry].description){
							rssSocialXMLData.messageText = getXMLValue( dataArray[entry].description ); //dataArray[entry].content.children()[0];
						}
						rssSocialXMLData.name = getXMLValue(dataArray[entry].creator); //dataArray[entry].author.children()[0].children()[0];
						rssSocialXMLData.title = getXMLValue(dataArray[entry].title); //dataArray[entry].title.children()[0];
						rssSocialXMLData.url = getXMLValue(dataArray[entry].link);
						rssSocialXMLData.thumbnailPicPath = "assets/rss_logo.png";
						rssSocialXMLData.date = getXMLValue(dataArray[entry].pubDate);
						
						feedDataItems.addItem(rssSocialXMLData);
					}
					
				}
			}
			
			dispatcher.dispatchEvent(new SocialServiceEvent(SocialServiceEvent.RETURN_DATA_ARRAY, false, false, feedDataItems, true));
			
		}
		
		private function parseXML(XMLData:XML, tagName:String=""):Array{
			var results:Array = new Array();
			
			var xmlList:XMLList = XMLList(XML(XMLData)[0]);
			
			for each (var entryElement:XML in XMLList(xmlList).children()) { 
				
				var name:Object = XML(entryElement).name();
				//trace(name.toString());
				
				if(name.localName == tagName){
					for each (var entryElementChild:XML in entryElement) { 
						//trace(entryElementChild);
						var obj:Object = new Object();
						
						for each (var entryObj:XML in entryElementChild.children()) {
							var nameEntry:String = XML(entryObj).name().localName;
							var valueEntry:XML = entryObj;
							
							//trace(nameEntry + " " + valueEntry);
							for each (var value:String in valueEntry.children()) {
								//trace(value);
							}
							
							obj[nameEntry] = valueEntry;
						}
					
						results.push(obj);
					}
					
				}
			}
			
			return results;
			
		}
		
		private function getXMLValue(xml:XML, tagName:String=""):String{
			var result:String = "";
			
			if( xml.children().length() > 1 ){
				var counter:Number = xml.children().length();
				var subText:String = "";
				for(var i:Number = 0; i < counter; i++) {
					var name:String = XML(xml.children()[i]).name().localName;
					if(tagName == name){
						result = getXMLValue(xml.children()[i]);
					}
				}
				
			}else{
				result = xml.children()[0];	
			}
			
			return result;
		}
		
		public function set feedSource(value:FeedSourceVO):void
		{
			_feedSource = value;
			
			_httpService.url = _feedSource.url; 
			//url="http://api.twitter.com/1/statuses/user_timeline.json?screen_name=gread72"
		}
		
		public function makeRequest():void{
			_httpService.send();
		}
	}
}