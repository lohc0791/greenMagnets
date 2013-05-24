package com.greenMagnets.domain
{
	import com.mapquest.tilemap.MapInit;
	import com.mapquest.tilemap.TileMap;

	public class Magnet
	{
		public static function setup( value:Object ):Magnet
		{
			var magnet:Magnet = new Magnet();
			magnet.city = value.city;
			magnet.continent = value.continent;
			magnet.country = value.country;
			magnet.date = new Date(value.create_at);
			magnet.lat = value.lat;
			magnet.lng = value.lng;
			magnet.id = value.magnet_id;
			magnet.name = value.name;
			magnet.score = value.score;
			magnet.socredNum = value.score_cnt;
			magnet.state = value.state;
			magnet.title = value.title;
			magnet.visited = value.visited_cnt;
			magnet.images = value.image_urls.split( "|||" );
			magnet.image_urls = value.image_urls;
			magnet.author = new User();
			magnet.author.email = value.author_email;
			return magnet;
		}
		/**
		 * 唯一标识的id
		 */
		public var id:String;							
		
		public var image_urls:String;
		
		public var name:String;
		/**
		 * 创建日期
		 */
		public var date:Date;
		/**
		 * 标签
		 */
		public var tag:Array;
		/**
		 * 标题
		 */
		public var title:String;
		/**
		 * 作者
		 */
		public var author:User;
		/**
		 * 访问次数
		 */
		public var visited:int;
		/**
		 * 评论的数组
		 */
		public var comments:Array;
		/**
		 * 包含的image的数组
		 */
		public var images:Array;
		/**
		 * 分数
		 */
		public var score:Number;
		/**
		 * 评分次数
		 */
		public var socredNum:int;
		/**
		 * 状态
		 */
		public var state:int;
		/**
		 * 经度
		 */
		public var lat:Number;
		/**
		 * 纬度
		 */
		public var lng:Number;
		/**
		 * 城市
		 */
		public var city:String;
		/**
		 * 国家
		 */
		public var country:String;
		/**
		 * 洲
		 */
		public var continent:String;
		
		/**
		 * 包含的features
		 */
		public var features:Array;
		
		public function Magnet()
		{
		}
	}
}