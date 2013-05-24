package com.greenMagnets.domain
{
	public class User
	{
		/**
		 * 唯一标识
		 */
		public var id:String;
		/**
		 * email
		 */
		public var email:String;
		/**
		 * 上载过的magnets
		 */
		public var magnets:Array;
		/**
		 * 类型
		 */
		public var type:int;
		
		public function User()
		{
		}
	}
}