package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	[SWF(frameRate="60")]
	public class WuhunPreLoader extends Sprite{
		public static var isDebug:Boolean;
		public function WuhunPreLoader(){
			Security.allowDomain("*");
			stage?loadMain():addEventListener(Event.ADDED_TO_STAGE, loadMain);
		}
		protected function loadMain(e:Event=null):void{
			//layer
			var layer:Sprite = new Sprite();
			addChild(layer);
			
			//config
			Config.layer = layer;
			Config.root = this;
			Config.p = new Object();
			for (var k:String in root.loaderInfo.parameters) 
			{
				Config.p[k]=root.loaderInfo.parameters[k];
			}
			
			//load main
			var loader:Loader = new Loader();
				addChild(loader);
				configureListeners(loader);
			var context:LoaderContext = new LoaderContext(); 
				context.applicationDomain = ApplicationDomain.currentDomain; 
			loader.load(new URLRequest("Main.swf"),context);
			trace("开始加载");
		}
		protected function onOK(e:Event):void{ trace("完成加载"); }
		protected function onGo(event:ProgressEvent):void{
			trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		private function getLogo(linkName:String,app:ApplicationDomain=null):Bitmap{
			if(app==null)app=ApplicationDomain.currentDomain;
			var c:Class = app.getDefinition(linkName) as Class;
			return new Bitmap(new c());
		}
		private function configureListeners(l:Loader):void {
			l.addEventListener(Event.COMPLETE, onOK);			//完成
			l.addEventListener(ProgressEvent.PROGRESS, onGo);	//进行中
			l.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			l.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		private function completeHandler(event:Event):void { trace("completeHandler: " + event); }
		private function httpStatusHandler(event:HTTPStatusEvent):void { trace("httpStatusHandler: " + event); }
		private function ioErrorHandler(event:IOErrorEvent):void { trace("ioErrorHandler: " + event); }
	}
}
