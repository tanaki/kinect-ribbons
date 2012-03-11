package org.cornflex.ribbons
{
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	public class RibbonManager
	{
		
  		private var ribbonAmount:int;
  		private var ribbonParticleAmount:int;
  		private var randomness:Number;
  		private var ribbons:Array;
  		private var container:Sprite;
		
		public function RibbonManager(container:Sprite, ribbonAmount:int,ribbonParticleAmount:int,randomness:Number)
		{
			this.ribbonAmount = ribbonAmount;
			this.ribbonParticleAmount = ribbonParticleAmount;
			this.randomness = randomness;
			this.container = container;
			init();
		}
		
		private function init():void
		{
			addRibbon();
		}

		private function addRibbon():void
		{
			ribbons = new Array(ribbonAmount);
			
			for (var i:int = 0; i < ribbonAmount; i++)
			{
				ribbons[i] = new Ribbon(container, ribbonParticleAmount, Math.random() * 0xFFFFFF, randomness);
			}
		}
  
		public function update(currX:int, currY:int):void 
		{
			for (var i:int = 0; i < ribbonAmount; i++)
			{
				var randX:Number = currX;
				var randY:Number = currY;
				ribbons[i].update(randX, randY);
			}
		}
		  
		public function setRadiusMax(value:Number):void { for (var i:int = 0; i < ribbonAmount; i++) { ribbons[i].radiusMax = value; } }
		public function setRadiusDivide(value:Number):void { for (var i:int = 0; i < ribbonAmount; i++) { ribbons[i].radiusDivide = value; } }
		public function setGravity(value:Number):void { for (var i:int = 0; i < ribbonAmount; i++) { ribbons[i].gravity = value; } }
		public function setFriction(value:Number):void { for (var i:int = 0; i < ribbonAmount; i++) { ribbons[i].friction = value; } }
		public function setMaxDistance(value:int):void { for (var i:int = 0; i < ribbonAmount; i++) { ribbons[i].maxDistance = value; } }
		public function setDrag(value:Number):void { for (var i:int = 0; i < ribbonAmount; i++) { ribbons[i].drag = value; } }
		public function setDragFlare(value:Number):void { for (var i:int = 0; i < ribbonAmount; i++) { ribbons[i].dragFlare = value; } }

	}
}