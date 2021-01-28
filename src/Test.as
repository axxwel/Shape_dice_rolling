package{
    import flash.display.Sprite;
    import flash.events.Event;
	import flash.events.MouseEvent;
    import flash.text.TextField;
	import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    import flash.utils.getTimer;

    public class Test extends Sprite{
		private var conteneur:Sprite=new Sprite();
		
        private var last:uint = getTimer();
        private var ticks:uint = 0;
		private var tfFPS:TextField=new TextField;
		private var tfFB:TextField=new TextField;
		private var tfCONS:TextField=new TextField;
		
		private var tfFormat:TextFormat=new TextFormat();
		
		public var unlog:Boolean = false;
		
        public function Test() {
			tfFormat.font="Arial";
			tfFormat.size=16;
			
			tfFPS= new TextField();
			tfFPS.textColor=0xffffff;
			tfFPS.background=true;
			tfFPS.backgroundColor=0x000000;
			tfFPS.text = "----- fps";           
            tfFPS.autoSize = TextFieldAutoSize.LEFT;
			tfFPS.setTextFormat(tfFormat);
			
			tfFB= new TextField();
			tfFB.textColor=0xffffff;
			tfFB.background=true;
			tfFB.backgroundColor=0x3B5999;
			tfFB.text="Facebook:";
			tfFB.multiline = true;
            tfFB.autoSize = TextFieldAutoSize.LEFT;
			tfFB.setTextFormat(tfFormat);
			
			tfCONS= new TextField();
			tfCONS.textColor=0x000000;
			tfCONS.background=true;
			tfCONS.backgroundColor=0xffffff;
			tfCONS.text = "--------------";           
            tfCONS.autoSize = TextFieldAutoSize.LEFT;
			tfCONS.setTextFormat(tfFormat);
			
			conteneur.addChild(tfFPS);
			conteneur.addChild(tfFB);
			conteneur.addChild(tfCONS);
			
			addChild(conteneur);
			addEventListener(Event.ENTER_FRAME, tick);
		}
        public function tick(evt:Event):void {
            ticks++;
            var now:uint = getTimer();
            var delta:uint = now - last;
            if (delta >= 1000) {
                //trace(ticks / delta * 1000+" ticks:"+ticks+" delta:"+delta);
                var fps:Number = ticks / delta * 1000;
                tfFPS.text = fps.toFixed(1) + " fps";
				tfFPS.setTextFormat(tfFormat);
                ticks = 0;
                last = now;
            }
			tfFB.y = tfFPS.height;
			tfCONS.y = tfFB.height+tfFB.y;
        }
		public function FBlog(tx:String=""){
			tfFB.text=tfFB.text+"\n"+tx;
			tfFB.setTextFormat(tfFormat);
		}
		public function console(tx:String){
			tfCONS.text=tfCONS.text+"\n"+tx;
			tfCONS.setTextFormat(tfFormat);
		}
    }
}