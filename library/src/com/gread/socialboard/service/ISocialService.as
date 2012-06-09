package com.gread.socialboard.service
{
	import com.gread.socialboard.model.vo.FeedSourceVO;

	public interface ISocialService{
		
		function set feedSource(value:FeedSourceVO):void
			
		function makeRequest():void
	}
}