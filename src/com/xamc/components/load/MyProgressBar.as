package com.xamc.components.load
{
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.net.*;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.utils.*;
	
	import mx.events.*;
	import mx.preloaders.IPreloaderDisplay;
	
	import org.osmf.elements.ImageLoader;
	
	public class MyProgressBar extends Sprite implements IPreloaderDisplay 
	{ 
		[Embed(source="css/skin/progress/logo1.png", mimeType="application/octet-stream")]  
		public var _loadingLogo:Class;  
		
		[Embed(source="css/skin/progress/logo1.png", mimeType="application/octet-stream")]  
		public var _loadpiccar:Class;  
		
		
		
		private var dpbImageControl:Loader;  
		private var _barSprite:Sprite;  
		private var progressText:TextField;         
		private var ProgressBarSpritIsAdded:Boolean = false;  
		
		private var thisWidth:int = 980;
		private var thisHeight:int = 630;
		
		private var _loader:Loader;
		
		public function MyProgressBar() 
		{ 
			super(); 
		} 
		
		// Specify the event listeners.  
		public function set preloader(preloader:Sprite):void {  
			//Listen for 正在下载  
			preloader.addEventListener(ProgressEvent.PROGRESS, handleProgress);  
			//Listen for 下载完成  
			preloader.addEventListener(Event.COMPLETE, handleComplete);  
			//Listen for 正在初始化  
			preloader.addEventListener(FlexEvent.INIT_PROGRESS, handleInitProgress);  
			//Listen for 初始化完成  
			preloader.addEventListener(FlexEvent.INIT_COMPLETE, handleInitComplete);  
		}  
		
		// Initialize the Loader control in the override  
		// of IPreloaderDisplay.initialize().  
		public function initialize():void {  
			//添加logo图  
			dpbImageControl = new Loader();        
			dpbImageControl.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);  
			dpbImageControl.loadBytes(new _loadingLogo() as ByteArray);  
			//dpbImageControl.load(new URLRequest("loadinglogo.swf"));  
		}  
		
		
		// After the SWF file loads, set the size of the Loader control.  
		private function loader_completeHandler(event:Event):void  
		{          
			addChild(dpbImageControl);  
			dpbImageControl.width = 212;  
			dpbImageControl.height= 56;  
			dpbImageControl.x = thisWidth/2 - dpbImageControl.width/2;  
			dpbImageControl.y = thisHeight/2 - dpbImageControl.height/2-20;  
		}    
		
		//  
		private function addProgressBarSprit():void{  
			//绘制背景渐变  
			var matrix:Matrix=new Matrix();  
			matrix.createGradientBox(thisWidth,thisHeight,Math.PI/2);  
			var colors:Array=[0xf9f9f9,0xf9f9f9];  
			var alphas:Array=[1,1];  
			var ratios:Array=[0,255];  
			this.graphics.lineStyle();  
			this.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);         
			this.graphics.drawRect(0,0,thisWidth,thisHeight);  
			this.graphics.endFill();  
			
			//绘制中心白色发光  
			/*var _Sprite1:Sprite = new Sprite();  
			addChild(_Sprite1);  
			_Sprite1.graphics.beginFill(0xffffff,0.45);  
			_Sprite1.graphics.drawEllipse(thisWidth/2-130, thisHeight/2-90, 280, 100);  
			_Sprite1.graphics.endFill(); */
			
			//滤镜实现发光边缘柔和             
			/*var blur:BlurFilter = new BlurFilter();  
			blur.blurX = 100;  
			blur.blurY = 50;  
			blur.quality = BitmapFilterQuality.HIGH;  
			_Sprite1.filters = [blur];*/  
			
			
			//-------------------------------------------------  
			
			//绘制进度条背景  
			var _Sprite2:Sprite = new Sprite();  
//			addChild(_Sprite2);  
			_Sprite2.graphics.lineStyle(2, 0x000000);  
			_Sprite2.graphics.beginFill(0x999999);  
			_Sprite2.graphics.drawRect((thisWidth/2 - 200), (thisHeight/2 +150), 404, 21);    
			_Sprite2.graphics.endFill();  
			
			//-------------------------------------------------  
			
			//加载进度条Sprite  
			_barSprite = new Sprite();  
//			addChild(_barSprite);  
			_barSprite.x = thisWidth/2 - 198;  
			_barSprite.y = thisHeight/2 + 152;  
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _loader_completeHandler);  
			_loader.loadBytes(new _loadpiccar() as ByteArray);  
			//-------------------------------------------------  
			
			//加载进度条文字  
			progressText = new TextField();  
//			addChild(progressText);  
			progressText.textColor = 0x959595;  
			progressText.width = 300;  
			progressText.height = 25;  
			progressText.x = thisWidth/2 - 198;  
			progressText.y = thisHeight/2 + 180;  
			progressText.visible = true;
		}  
		
		private function _loader_completeHandler(event:Event):void  
		{          
//			_barSprite.addChild(_loader);
			_loader.x = -124;
			_loader.y = -34; 
		}  
		
		
		//刷新进度条  
		private function drawProgressBar(bytesLoaded:Number, bytesTotal:Number):void  
		{    
//			if (_barSprite != null && progressText != null){  
//				var g:Graphics = _barSprite.graphics;  
//				g.clear();  
//				g.beginFill(0xcccccc);  
//				g.drawRect(0, 0, 400*(bytesLoaded/bytesTotal),16);    
//				g.endFill();     
//				
//				var matrix:Matrix=new Matrix();  
//				matrix.createGradientBox(400*(bytesLoaded/bytesTotal),16,90);  
//				var colors:Array=[0x8db048,0x8db048,0x8db048];  
//				var alphas:Array=[1,1,1];  
//				var ratios:Array=[0,125,255];  
//				g.lineStyle();  
//				g.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);         
//				g.drawRect(0,0,400*(bytesLoaded/bytesTotal),17);  
//				g.endFill();   
//				
//				_loader.x = 400*(bytesLoaded/bytesTotal) - 124;
//			}  
		}  
		
		//正在下载的进度  
		private function handleProgress(event:ProgressEvent):void {  
			//第一次处理时绘制进度条Sprit  
			if (ProgressBarSpritIsAdded == false){  
				ProgressBarSpritIsAdded = true;  
				addProgressBarSprit();  
			}  
//			
//			if (progressText != null){  
//				progressText.text = "下载进度：已下载 " + event.bytesLoaded + " byte，总大小 " + event.bytesTotal + " byte.";  
//			}          
//			drawProgressBar(event.bytesLoaded, event.bytesTotal);  
		}  
		
		private function handleComplete(event:Event):void {  
//			if (progressText != null){  
//				progressText.text = "下载完成.";  
//			}  
//			drawProgressBar(1,1);         
		}  
		
		private function handleInitProgress(event:Event):void {  
//			if (progressText != null){  
//				progressText.text = "正在初始化...";  
//			}  
//			drawProgressBar(1,1);  
		}  
		
		private function handleInitComplete(event:Event):void {  
//			if (progressText != null){  
//				progressText.text = "初始化完成.";  
//			}  
//			drawProgressBar(1,1);          
//			
			//0.03秒后抛出完成事件  
			var timer:Timer = new Timer(300,1);  
			timer.addEventListener(TimerEvent.TIMER, dispatchComplete);  
			timer.start();       
		}  
		
		private function dispatchComplete(event:TimerEvent):void {  
			dispatchEvent(new Event(Event.COMPLETE));  
		}  
		
		
		public function get backgroundAlpha():Number 
		{ 
			return 0; 
		} 
		
		public function set backgroundAlpha(value:Number):void 
		{ 
		} 
		
		public function get backgroundColor():uint 
		{ 
			return 0; 
		} 
		
		public function set backgroundColor(value:uint):void 
		{ 
		} 
		
		public function get backgroundImage():Object 
		{ 
			return null; 
		} 
		
		public function set backgroundImage(value:Object):void 
		{ 
		} 
		
		public function get backgroundSize():String 
		{ 
			return null; 
		} 
		
		public function set backgroundSize(value:String):void 
		{ 
		} 
		
		
		
		public function get stageHeight():Number 
		{ 
			return 0; 
		} 
		
		public function set stageHeight(value:Number):void 
		{ 
		} 
		
		public function get stageWidth():Number 
		{ 
			return 0; 
		} 
		
		public function set stageWidth(value:Number):void 
		{ 
		} 
	} 
}