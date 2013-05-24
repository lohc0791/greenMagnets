package com.greenMagnets.application
{
	import com.adobe.serialization.json.JSON;
	import com.greenMagnets.domain.Magnet;
	import com.greenMagnets.domain.News;
	import com.greenMagnets.domain.User;
	import com.greenMagnets.utils.Config;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ServiceManager
	{
		public static const CREATE_MAGNETS:int = 0x000;
		public static const DEL_MAGNETS:int = 0x001;
		public static const EDIT_MAGNETS:int = 0x002;
		public static const GET_MAGNETS:int = 0x003;
		public static const SCORE_MAGNETS:int = 0x004;
		public static const COMMENT_MAGNETS:int = 0x005;
		public static const PASS_MAGNETS:int = 0x006;
		public static const PASS_COMMENT:int = 0x007;
		
		public static const CREATE_NEWS:int = 0x100;
		public static const DEL_NEWS:int = 0x101;
		public static const EDIT_NEWS:int = 0x102;
		public static const GET_NEWS:int = 0x103;
		
		public static const SIGN_IN:int = 0x200;
		public static const LOG_IN:int = 0x201;
		public static const RESET_PWD:int = 0x202;
		public static const RESET_INFO:int = 0x203;
		
		private static var loader:URLLoader;
		
		private static var callbackDic:Dictionary;
		private static var faultbackDic:Dictionary;
		
		{
			loader = new URLLoader( );
			loader.addEventListener( Event.COMPLETE, loadCompleteHandler );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
			loader.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			
			callbackDic = new Dictionary();
			faultbackDic = new Dictionary();
		}
		
		protected static function loadCompleteHandler( event:Event ):void
		{
			var data:Object = com.adobe.serialization.json.JSON.decode( event.target['data'] );
			var opera:int = data['opera'];
			if( callbackDic[opera] && callbackDic[opera].length > 0 )
			{
				var l:int = callbackDic[opera].length;
				for ( var i:int = 0; i < l; i++ )
				{
					callbackDic[opera][i]( data );
				}
			}
		}
		
		protected static function securityErrorHandler( event:SecurityErrorEvent ):void
		{
			
		}
		
		protected static function ioErrorHandler( event:IOErrorEvent ):void
		{
		
		}
		
		private static function regisetCallbackAndFaultback( opera:int, callback:Function = null, faultback:Function = null ):void
		{
			if( callback != null)
			{
				if( !callbackDic[opera] )
					callbackDic[opera] = [];
				
				callbackDic[opera].push( callback );
			}
			
			if( faultback != null)
			{
				if( !faultbackDic[opera] )
					faultbackDic[opera] = [];
				
				callbackDic[opera].push( faultback );
			}
		}
		/**
		 * 创建一个magnet
		 * @param magnet 创建的magnet的信息
		 * @response magnet的id
		 */
		public static function createMagnets( magnet:Magnet, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['magnet'] = com.adobe.serialization.json.JSON.encode( magnet );
			value['opera'] = CREATE_MAGNETS;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 搜索magnet
		 * @param type 搜索的方式
		 * @param keyword 搜索的参数
		 * @response 得到的magnet的数组
		 */
		public static function getMagnets( type:int, keyword:String, page:int = 0, pageSize:int = 20, callback:Function = null, faultback:Function = null ):void
		{
			//type == 1, 获取所有的magnets, 此时keyword参数传""
			//type == 2, 获取所有continent下的magnets, 此时keyword为州名
			//type == 3, 获取所有country下的magnets, 此时keyword为国家名
			//type == 4, 获取所有city下的magnets, 此时keyword为城市名
			//type == 5, 获取所有tag下的magnets， 此时keyword为"tag1;tag2;tag3;tag4"
			//type == 6, 获取所有用户email的magnets, 此时keyword为用户的email
			//type == 7, 获取推荐的magnets， 此时keyword为""
			//type == 8, 获取最新的magnets, 此时keyword为""
			var value:URLVariables = new URLVariables();
			value['type'] = type;
			value['keyword'] = keyword;
			value['opera'] = GET_MAGNETS;
			//添加 一些分页相关的功能 2012-12-19 晚
			value['limit_start'] = page; //页起始点
			value['page_size'] = pageSize; //页大小，目前最大支持50，如果需要更多请联系 shijie. li.
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 修改一个magnet
		 * @param magnet 修改后的magnet的信息
		 */
		public static function editMagnets( magnet:Magnet, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['magnet'] = com.adobe.serialization.json.JSON.encode( magnet );
			value['opera'] = EDIT_MAGNETS;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 删除一个magnet
		 * @param id 要删除的magnet的id
		 */
		public static function delMagnets( id:String, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['id'] = id;
			value['opera'] = DEL_MAGNETS;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 对一个magnet进行评分
		 * @param id 呗评分的magnet的id
		 * @param score magnet的分数
		 */
		public static function scoreMagnets( id:String, score:Number, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['id'] = id;
			value['opera'] = SCORE_MAGNETS;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 对一个magnet进行评论
		 * @param id 呗评论的magnet的id
		 * @param email 评论者的email
		 * @param content 评论的内容
		 */
		public static function commentMagnets( id:String, email:String, content:String, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['id'] = id;
			value['email'] = email;
			value['content'] = content;
			value['opera'] = COMMENT_MAGNETS;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 改变一个magnet的状态
		 * @param id 
		 * @param state
		 * @response
		 */
		public static function passMagnets( id:String, state:int, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['id'] = id;
			value['state'] = state;
			value['opera'] = PASS_MAGNETS;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 改变一个评论的状态
		 * @param id
		 * @param state
		 * @response
		 */
		public static function passComment( id:String, state:int, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['id'] = id;
			value['state'] = state;
			value['opera'] = PASS_COMMENT;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 创建一条新闻
		 * @param news 创建的新闻的信息
		 * @response id 创建的新闻的id
		 */
		public static function createNews( news:News, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['data'] = com.adobe.serialization.json.JSON.encode( news );
			value['opera'] = CREATE_NEWS;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 删除一条新闻
		 * @param id 要删除的新闻的id
		 */
		public static function delNews( id:String, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['data'] = id;
			value['opera'] = DEL_NEWS;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 编辑一条新闻
		 * @param news 要编辑的新闻的信息
		 */
		public static function editNews( news:News, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['data'] = com.adobe.serialization.json.JSON.encode( news );
			value['opera'] = EDIT_NEWS;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 获取新闻
		 * @response 新闻的数组
		 */
		public static function getNews( callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['opera'] = GET_NEWS;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 注册用户
		 * @param user 用户的信息
		 * @param pwd 密码
		 * @response 用户的id
		 */
		public static function signIn( user:User, pwd:ByteArray, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['user'] = user;
			value['pwd'] = pwd;
			value['opera'] = SIGN_IN;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 用户登录
		 * @param email 用户的email
		 * @param pwd 密码
		 * @response 用户的信息
		 */
		public static function logIn( email:String, pwd:ByteArray, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['email'] = email;
			value['pwd'] = pwd;
			value['opera'] = LOG_IN;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 修改密码
		 * @param id 用户的id
		 * @param oldPwd 旧的用户密码
		 * @param newPwd 新的用户密码
		 * @response 是否修改成功
		 */
		public static function resetPwd( id:String, oldPwd:ByteArray, newPwd:ByteArray, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['id'] = id;
			value['oldPwd'] = oldPwd;
			value['newPwd'] = newPwd;
			value['opera'] = RESET_PWD;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
		
		/**
		 * 修改用户信息
		 * @param user 修改的用户的信息
		 * @response 是否修改成功
		 */
		public static function resetInfo( user:User, callback:Function = null, faultback:Function = null ):void
		{
			var value:URLVariables = new URLVariables();
			value['user'] = user;
			value['opera'] = RESET_INFO;
			var url:URLRequest = new URLRequest( Config.interfaceUrl );
			url.data = value;
			url.method = URLRequestMethod.POST;
			loader.load( url );
			regisetCallbackAndFaultback( value['opera'], callback, faultback );
		}
	}
}