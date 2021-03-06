package com.greenMagnets.application
{
	import com.greenMagnets.domain.Magnet;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class Model extends EventDispatcher
	{
		private static var _instance:Model;
		public static function get instance():Model
		{
			_instance = _instance || new Model;
			return _instance;
		}
		
		public var currentMagnet:Magnet;
		public var magnetList:ArrayCollection = new ArrayCollection();
	}
}