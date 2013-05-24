package com.greenMagnets.utils
{
	import com.adobe.utils.StringUtil;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Config
	{
		public static function init():void
		{
			var loader:URLLoader = new URLLoader( new URLRequest( "config.properties" ) );
			loader.addEventListener(Event.COMPLETE, onComplete);
		}
		
		private static function onComplete( e:Event ):void
		{
			parse( e.target.data );
		}
		
		public static function parse( data:String ):void
		{
			if( data == null || data.length == 0 ) return;
			var doc:String = data;
			var messArr:Array = doc.split( "\n" );
			var ml:int = messArr.length;
			for( var mi:int = 0; mi < ml; mi++ )
			{
				var str:String = messArr[mi];
				if( str.indexOf( "#" ) == 0 )
					continue;
				if( str.indexOf( "=" ) == -1 )
					continue;
				
				var didx:int = str.indexOf( "=", 0 );
				var key:String = StringUtil.trim( str.substring( 0, didx - 1 ) );
				var value:String = StringUtil.trim( str.substring( didx + 1 ) );
				if( Config['hasOwnProperty']( key ) )
					trace( "发现重复的国际化项，位置为", key );
				Config[key] = value;
			}
		}
		
		public static var imageUploaderUrl:String;
		public static var interfaceUrl:String;
	}
}