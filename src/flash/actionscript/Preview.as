package actionscript
{
	import flash.display.*;
	import flash.text.*;
	import flash.media.*;
	import flash.external.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.NetStream;
	import flash.display.Bitmap;
	public class Preview
	{
		private var config:Object;
		private var reference:Sprite;
		private var precontainer:MovieClip;
		private var preimgLoader:Loader;
		private var preimagePath:URLRequest;

		public function Preview(ref,cfg):void
		{
			config = cfg;
			reference = ref;
			if (reference.root.loaderInfo.parameters['preview'])
			{
				config['preview'] = config['ref'].root.loaderInfo.parameters['preview'];
			}
			else if (config['plistlength'] != 0)
			{
				config['preview'] = config['preview'];
			}
		}//========================================== load preview image ==============================================================================
		public function loadPreview()
		{
			config['skinMc'].y = config['stageHeight']-(config['skinMc'].skin_bg.height);
			config['skinMc'].alpha = 1;
			if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
			{
				config['thuMc'].alpha = 1;
			}
			if(config['mov'] == 1)
			{
				var videoscale2 = new videoScale(config,reference);
				videoscale2.buttonInVis();
			}
			else
			{
				var videoscale3 = new videoScale(config,reference);
				videoscale3.buttonVis();
			}
			if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
			{
				if (config['thuMc'] != undefined)
				{
					config['thuMc'].visible = true;
				}
			}
			if (config['timer'] == "true")
			{
				if (config['isLive'] != "true")
				{
					config['skinMc'].ti.visible = config['skinMc'].ti2.visible = true;
				}
				else
				{
					config['skinMc'].ti.visible = true;
					config['skinMc'].ti2.visible = false;
				}
			}
			else
			{
				config['skinMc'].ti.visible = config['skinMc'].ti2.visible = false;
			}
			if (config['playlist_auto'] == "true")
			{
				config['skinMc'].autoPlayButton.visible = true;
			}
			if (config['hd'] == "true")
			{
				config['skinMc'].hd.visible = true;
			}
			if (config['showPlaylistB'] == "true")
			{
				config['skinMc'].PlayListView.visible = true;
			}
			if (config['isLive'] == "true")
			{
				var playvideo = new playVideo(config,reference);
				playvideo.setLiveText();
			}
			else
			{
				config['skinMc'].pro.visible = true;
			}
			config['skinMc'].visible = true;
			config['setnum'] = 0;
			var skinArrnge2 = new skinarrnge(config);
			precontainer = new MovieClip();
			reference.addChild(precontainer);
			config['precontainer'] = precontainer;
			config['shareClip'] = precontainer;
			if (precontainer)
			{
				var otherindex = reference.getChildIndex(config['Playbtn']);
				reference.setChildIndex(precontainer, otherindex);
			}
			if(config['preview'] ==null || config['preview'] =="" || config['preview'] == undefined)  config['preview'] = "";
			if(config['preview'] == "" && config['imageDefault'] == true)
			{
				config['preview'] = config['baseurl'] + "images/default_preview.jpg";
			}
			if(config['preview'] != "")
			{
				if (config['preview'].indexOf('http') > -1)
				{
					config['preview'] = config['preview'];
				}
				else
				{
					config['preview'] = config['baseurl'] + "" + config['preview'];
				}
				preimgLoader  = new Loader();
				preimagePath = new URLRequest(config['preview']);
				preimgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,preimgLoaded);
				preimgLoader.load(preimagePath);
				preimgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,preimgLoaded);
				preimgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageError);
			}
			config['preval'] = true;
			if (config['mov'] != 2)
			{
				if (config['showTag'] == "true")
				{
					config['tagline'].visible = false;
				}
				config['skinMc'].pro.buffer_end.visible = config['skinMc'].pro.seek_end.visible = config['skinMc'].pro.seekS.visible = config['skinMc'].pro.bufferS.visible = false;
				config['buffer_Mc'].alpha = 0;
				config['Playbtn'].alpha = 1;
				if (config['skinMc'].pp.Replay.visible == false)
				{
					config['skinMc'].pp.play_btn.visible = true;
				}
				config['skinMc'].pp.pause_btn.visible = false;
				config['Playbtn'].visible = true;
				precontainer.addEventListener(MouseEvent.MOUSE_DOWN,removePreviewAndplay);
			}
			else
			{
				var videoscale = new videoScale(config,reference);
				videoscale.buttonVis();
				config['skinMc'].pro.buffer_end.visible = config['skinMc'].pro.seek_end.visible = config['skinMc'].pro.seekS.visible = config['skinMc'].pro.bufferS.visible = true;
			}
			precontainer.addEventListener(MouseEvent.MOUSE_UP,stopPlaylistMove);
			config['skinMc'].y = config['stageHeight']-(config['skinMc'].skin_bg.height);
		}
		private function imageError(evt:IOErrorEvent)
		{
			if (config['preview'].indexOf("maxresdefault.jpg") > -1)
			{
				config['preview'] = String(config['preview']).replace('maxresdefault.jpg','hqdefault.jpg');
				loadPreview();
			}
			else if (config['preview'].indexOf("hqdefault.jpg") > -1)
			{
				config['preview'] = String(config['preview']).replace('hqdefault.jpg','mqdefault.jpg');
				loadPreview();
			}
			else if (config['imageDefault'] == true && config['preview'].indexOf("default_preview.jpg") <= -1)
			{
				config['preview'] = config['baseurl'] + "images/default_preview.jpg";
				loadPreview();
			}
		}
		private function stopPlaylistMove(eve:MouseEvent)
		{
			config['downBool'] = false;
			config['upBool'] = false;
		}
		public function preimgLoaded(evt:Event)
		{
			precontainer.addChild(preimgLoader);
			precontainer.buttonMode = true;
			config['org_width'] = precontainer.width;
			config['org_height'] = precontainer.height;
			config['vidscale'] = precontainer.width / precontainer.height;
			var playerUI = new playerUi(reference,config);
			playerUI.setPos(config);
			if(config['mov'] == 1)
			{
				var videoscale2 = new videoScale(config,reference);
				videoscale2.buttonInVis();
			}
			else
			{
				var videoscale3 = new videoScale(config,reference);
				videoscale3.buttonVis();
			}
		}
		//========================================== remove preview image ==============================================================================
		public function removePreview()
		{
			config['skinMc'].y = config['stageHeight'] - config['skinMc'].pp.height;
			config['precontainer'].visible = false;
			if (config['precontainer']!= "" && config['precontainer'] != undefined)
			{
				reference.removeChild(config['precontainer']);
			}
			config['preval'] = false;
			config['skinMc'].pp.play_btn.visible = false;
			config['skinMc'].pp.pause_btn.visible = true;
		}
		private function removePreviewAndplay(eve:MouseEvent)
		{
			if (config['relatedview'])
			{
				var relatedvideo = new relatedVideo(config,reference);
				relatedvideo.removerelated();
			}
			else
			{
				removePreview();
				config['Playbtn'].visible = false;
				if (config['skinMc'].pp.Replay.visible == true)
				{
					config['mov'] = 2;
				}
				var getvideo = new findVideoType(reference,config);
			}
		}

	}
}