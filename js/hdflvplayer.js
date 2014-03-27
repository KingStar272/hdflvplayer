/**
 * "HD FLV Player - HTML5" - Version 1.0
 * Author: adhavan(developer@contus.in)
 * Copyright (c) 2013 Contus Support - support@hdvideoshare.net
 * License: GNU/GPL http://www.gnu.org/copyleft/gpl.html
 * Creation Date: February 28 2014
 */
jQuery(document).ready(function($) {
    $.fn.hdflv = function(hflv_option)
    {
        return this.each(function()
        {
            var handleClick= 'ontouchstart' in document.documentElement ? 'touchstart': 'mousedown';
            var $hdflv = $(this);
            var ads_id;
            var palyerType,currentTime,duration,totalWidth=0,drg=true,myVar,parentOffset,relX,relY,seekto,speedOver=true,skinOver=true,over=true,playing='initial',player,totalBytes,bytesLoaded,myVar2,src_error=false,qualityBg=false,speedBg=false,playbackrate = 1,viewmode='normal',file,qy,qtxt,i=0,toalads=0,toalvideo=0,playlist,poster,autoplay,tagvalue,streamer="",video_id=0,ads_playing=false;
            if(hflv_option.playlist){
                
                toalvideo = hflv_option.playlist.length;
                if(toalvideo>1){
                    playlist = 'enable'
                }else{
                    playlist = 'disable'
                }
                if(hflv_option.hd_default == 'true'){
                    file = hflv_option.playlist[video_id].hd_file;
                    qy = -5;
                    qtxt = 'HD';
                }else{
                    file = hflv_option.playlist[video_id].file;
                    qy = -25;
                    qtxt = 'Normal';
                }
                streamer = hflv_option.playlist[video_id].streamer;
                poster = hflv_option.playlist[video_id].poster;
                ads_id = hflv_option.playlist[video_id].ads_id;
            }else{
                playlist = 'disable';
                if(hflv_option.hd_default == 'true'){
                    file = hflv_option.hd_file;
                    qy = -5;
                    qtxt = 'HD';
                }else{
                    file = hflv_option.file;
                    qy = -25;
                    qtxt = 'Normal';
                }
                streamer = hflv_option.streamer;
                poster = hflv_option.poster;
                ads_id = hflv_option.ads_id;
            }
            var ads_url;
            var ads_provider;
            var ads_id_array =[];
            function get_ads_url(){
                toalads = hflv_option.ads.length;
                if(hflv_option.ads){
                    for ( i = 0; i < toalads; i++ ){
                        if(hflv_option.ads[i].id == ads_id){
                            ads_url = hflv_option.ads[i].url;
                            ads_provider = hflv_option.ads[i].provider
                            break;
                        }
                    }
                }
            }
            autoplay =hflv_option.autoplay;
            var $video_wrap = $('<div></div>').addClass('hdflv-video-player');
            var addhtmlvideocontainer=function(){
                tagvalue = '<div class="player_container">'
                tagvalue += '<video width="'+hflv_option.width+'" height="'+hflv_option.height+'"  class="hdflvplayer" id="hdflvplayer"  style="cursor: pointer">\n\
                                            <source class="playersource" src="'+file+'"></source>';
                tagvalue +='</video>';
                tagvalue +='</div>';
                return tagvalue;
            }
            var addflashvideocontainer=function(){
                playing = 'false';
                tagvalue = '<div class="player_container">'
                    palyerType = 'flash';
                tagvalue += '<div class="hdflvFLASH" id="hdflvFLASH"></div>';
                tagvalue +='</div>';
                return tagvalue;
            }
            var getyoutubeID=function(url){
                var videoid = url.match(/(?:https?:\/{2})?(?:w{3}\.)?youtu(?:be)?\.(?:com|be)(?:\/watch\?v=|\/)([^\s&]+)/);
                if(videoid != null) {
                   console.log("video id ="+videoid[1]+'//');
                   return videoid[1];
                } else {
                    console.log("The youtube url is not valid.");
                }
            }
            var addyoutubecontainer=function(){
                 tagvalue = '<div class="player_container">'
                tagvalue += '<iframe width="'+hflv_option.width+'" height="'+hflv_option.height+'" src="http://www.youtube.com/embed/'+getyoutubeID(file)+'?autoplay=1&controls=0&showinfo=0" class="hdflvplayer" id="hdflvplayer"  style="cursor: pointer">'
                tagvalue += '</iframe>';
                tagvalue += '</div>';
                return tagvalue;
            }
            var taginitial;
            var cretetagvalue=function(){
                var isiDevice = /ipad|iphone|ipod/i.test(navigator.userAgent.toLowerCase());
                if(($.browser.msie && $.browser.version<9.0) || file.indexOf("youtube")>-1){
                      if(isiDevice && file.indexOf("youtube")>-1)
                      {
                          taginitial = addyoutubecontainer();

                      }else {
                          taginitial = addflashvideocontainer();
                          palyerType = 'flash';
                      }

                }else{
                     palyerType = 'html';
                     if(file.indexOf(".m3u8")>-1 && isiDevice == false)
                     {
                           taginitial = addflashvideocontainer();
                           palyerType = 'flash';
                     }else{
                         taginitial = addhtmlvideocontainer();
                     }
                }
            }
            cretetagvalue();
            var $hdflv_player = $(taginitial +'<div class="hdflv-video-play-button sprite-image"></div>\n\
                                    <div class="hdlfv-skin-container">\n\
                                        <span class="hdflv-skinBg"></span>\n\
                                        <span class="hdflv-play-pause sprite-image"></span>\n\
                                        <span class="hdflv-fullscreen sprite-image"></span>\n\
                                        <span class="hdflv-volume sprite-image">\n\
                                              <div class="hdflv-volume-bg">\n\
                                                  <span class="hdlflv-volume-progress-bg"></span>\n\
                                                  <span class="hdlflv-volume-progress"></span>\n\
                                                  <span class="hdlflv-mute"></span>\n\
                                              </div>\n\
                                        </span>\n\
                                        <span class="hdflv-hd-swipe sprite-image">\n\
                                             <div class="setting_bg">\n\
                                                 <span class="speed_button">\n\
                                                     <span class="current_speed">Normal</span>\n\
                                                     <span class="speed_downn_arraow"></span>\n\
                                                     <div class="speed_bg">\n\
                                                         <span class="2xSp">2x</span>\n\
                                                         <span class="1_5xSp">1.5x</span>\n\
                                                         <span class="normalSp">Normal</span>\n\
                                                         <span class="0_5xSp">0.5x</span>\n\
                                                         <span class="0_25xSp">0.25x</span>\n\
                                                         <span class="speed_select">.</span>\n\
                                                     </div>\n\
                                                  </span>\n\
                                                  <span class="speed_text">speed</span>\n\
                                                  <span class="quality_button">\n\
                                                     <span class="current_quality">HD</span>\n\
                                                     <span class="quality_downn_arraow"></span>\n\
                                                     <div class="quality_bg">\n\
                                                         <span class="QNormal">Normal</span>\n\
                                                         <span class="QHD">HD</span>\n\
                                                         <span class="Quality_select">.</span>\n\
                                                     </div>\n\
                                                  </span>\n\
                                                  <span class="quality_text">quality</span>\n\
                                              </div>\n\
                                        </span>\n\
                                        <span class="hdflv-duration">/ 00:00</span>\n\
                                        <span class="hdflv-currentTime">00:00</span>\n\
                                        <span class="hdlflv-skin-progress-bg"></span>\n\
                                        <span class="hdlflv-skin-buffer"></span>\n\
                                        <span class="hdlflv-skin-seek"></span>\n\
                                    </div>');
            $hdflv.wrap($video_wrap);
            $hdflv.after($hdflv_player);
            loadpreview();
            $('.hdflv-video-player').css({'top': '0','left': '0','z-index':'-1','overflow':'hidden'});
            function playerstatus(){
                if(palyerType == 'html'){
                    $('.hdflvplayer').bind('play', function(){
                        playing = 'true';
                        $('.hdflvplayer')[0].volume = volume_level/volume_deault;
                        $('.hdflv-video-play-button').addClass('playing')
                        $('.hdflv-video-play-button').hide();
                        $('.hdflv-play-pause').css({'background-position': '0px -36px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                    });
                    $('.hdflvplayer').bind('pause', function(){
                        playing = 'false';
                        $('.hdflv-play-pause').css({'background-position': '-1px -5px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                        $('.hdflv-video-play-button').removeClass('playing')
                        $('.hdflv-video-play-button').show();
                    });
                    $('.hdflvplayer').bind('ended', function(){
                        playing = 'false';
                        $('.hdflv-play-pause').css({'background-position': '-1px -5px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                        $('.hdflv-video-play-button').show();
                    });
                    totalWidth = $('.hdlflv-skin-progress-bg').width();
                    $('.hdflvplayer').bind("timeupdate",function(event){
                        currentTime = this.currentTime;
                        duration = this.duration;
                        onTrackedVideoFrame(this.currentTime, this.duration);
                    });
                    }else{
                         myVar2 = setInterval(function(){onTrackedVideoFrame2();},1);
                    }
                    $('.hdflvplayer').bind('volumechange',function() {
                        if($("video").prop('muted')){
                            $(this).addClass('hdflv-muted');
                            $('.hdflv-volume').css({'background-position': '-239px -123px'});
                            $('.hdflvplayer')[0].volume = 0;
                            $('.hdlflv-volume-progress').height(0);
                        }else if($(this).hasClass('hdflv-muted')){
                            $(this).removeClass('hdflv-muted');
                            $('.hdflv-volume').css({'background-position': '-240px -4px'});
                            $('.hdflvplayer')[0].volume = volume_level/volume_deault;
                            $('.hdlflv-volume-progress').height(volume_level);
                            if(volume_level/volume_deault>=0.5){
                            $('.hdflv-volume').css({'background-position': '-240px -4px'});
                            }else{
                                 if(volume_level/volume_deault<=0){$('.hdflv-volume').css({'background-position': '-239px -123px'});}
                                 else {$('.hdflv-volume').css({'background-position': '-240px -94px'});}
                            }
                        }

                    });
            };
            var ads_sVar;
            function ads_status()
            {
                var ads_cur,ads_dur;
                $('#hflvplayerflash').externalInterface({method:'getadscurrentTime',success: function(response){
                        ads_cur = response;
                }});
                $('#hflvplayerflash').externalInterface({method:'getadsDuration',success: function(response){
                        ads_dur = response;
                }});
                if(!isNaN(ads_dur)){
                    $('.ads_duraiton_ind').text('Advertisement: ('+gTimeFormat(ads_dur-ads_cur)+')')
                }
                $('#hflvplayerflash').externalInterface({method:'getadsstate',success: function(response){
                      if(response == 'unstarted' || response == 'initial' || response == 'playing'){
                         $('.hdflv-video-play-button').hide();
                         $('.hdflv-play-pause').css({'background-position': '0px -36px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                       }else if(response == 'ended'){
                         clearInterval(ads_sVar)
                         playing = 'false';
                         ads_playing = false;
                         setTimeout(function () {$('#adContainer').remove();}, 100);
                         playpausevideo()
                       }
                }});
            }
            function playpausevideo(){
                 $('.preview_image').remove();
                 if(playing == 'initial'){
                     if(palyerType == 'html')$('.hdflvplayer')[0].pause();
                     if(ads_id != undefined){
                         get_ads_url();
                         if(ads_url != undefined){
                             if(palyerType == 'flash'){
                                 ads_playing = true;
                                 ads_sVar = setInterval(function(){ads_status();},100);
                                 $('.hdflv-video-player').prepend('<div id="adContainer"></div>');
                                 $('#adContainer').prepend('<div class="ads_duraiton_ind">Advertisement: (00:00)</div>')
                                 $('.ads_duraiton_ind').css({'position':'absolute','width':'100%','background-color':'black','color': '#e5bb00','text-align': 'left','font': 'normal 12px arial,helvetica,sans-serif','min-width': '150px','padding': '6px 10px','top':'100%','margin-top': '-30px'});
                                 $('.hdlfv-skin-container').hide()
                                 $('#hflvplayerflash').externalInterface({method:'adsplayer',args: ads_url});
                             }else{
                                requestAds();
                             }
                             playing = 'false';
                         }else{
                            playing = 'false';
                            playpausevideo();
                         }
                     }else{
                         playing = 'false';
                         playpausevideo();
                     }
                 }else if(ads_playing == false){
                    var n=file.indexOf(".avi");
                    if(n>-1){
                        $('.error_board').show();
                        errorMessage('AVI is not supported by Flash or HTML5')
                    }else if(palyerType == 'flash'){
                        if(playing == 'false'){
                           playing = 'true';
                           $('.hdflv-video-play-button').hide();
                           $('.hdflv-play-pause').css({'background-position': '0px -36px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                        }else{
                           playing = 'false';
                           $('.hdflv-video-play-button').show();
                           $('.hdflv-play-pause').css({'background-position': '-1px -5px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                        }
                        $('#hflvplayerflash').externalInterface({method:'playfun'});
                        playerstatus();
                    }else{
                       if($('.hdflvplayer')[0].paused == false) {
                           $('.hdflvplayer')[0].pause();
                           $('.hdflv-video-play-button').show();
                       } else {
                           $('.hdflvplayer')[0].play();
                           $('.hdflv-video-play-button').hide();
                       }
                       playerstatus();
                    }
                 }
             };
            function initFlash(){
               $('.hdflvplayer').remove();
               $('.player_container').prepend('<div class="hdflvFLASH" id="hdflvFLASH"></div>');
               src_error = true;
               palyerType = 'flash';
               var flashvars = {};
               var params = {};
               params.file = file;
               params.poster = poster;
               var attributes = {};
               var s1 = new SWFObject('hdplayer.swf','hflvplayerflash',hflv_option.width,hflv_option.height,'9');
                   s1.addParam('allowfullscreen','true');
                   s1.addParam('allowscriptaccess','always');
                   s1.addParam('wmode','transparent');
                   s1.addVariable('file',file);
                   if(streamer != undefined){
                       s1.addVariable('streamer',streamer);
                   }
                   s1.addVariable('poster',poster);
                   s1.addVariable('autoplay',autoplay);
                   s1.write('hdflvFLASH');
                   loadpreview();
            }
            if(playlist == 'enable'){
                $('.hdlfv-skin-container').prepend('<div class="hdflv_playlist" id="hdflv_playlist"></div>');
                $('.hdflv_playlist').css({'display':'black','position': 'absolute','width': '250px','height': 'calc(100% - 30px)','top':'0px', 'bottom': '30px','left':'100%','margin-left':'-250px','background': '#414141'});
                $('.hdflv_playlist').prepend('<div class="dhflv_playlist" id="dhflv_playlist"></div>');
                $('.dhflv_playlist').css({'display':'black','position': 'absolute','width': '245px','height': 'calc(100%)','top':'0px', 'bottom': '30px','left':'100%','margin-left':'-250px','border': '1px solid rgb(0, 0, 0)','background': '#414141','overflow-x':'hidden'});
                $('.hdflv_playlist').prepend('<div class="playlist_open" id="playlist_open"></div>');
                $('.playlist_open').css({'display':'black','position': 'absolute','width': '25px','height': '60px','left':'100%','margin-left':'-275px','bottom':'50%','margin-bottom':'-30px','border': '1px solid rgb(0, 0, 0)','background': '#414141', 'cursor': 'pointer'});
                $('.playlist_open').prepend('<div class="playlist_open_obj" id="playlist_open_obj"></div>');
                $('.playlist_open').prepend('<div class="playlist_hide_obj" id="playlist_open_obj"></div>');
                $('.playlist_hide_obj').css({'position': 'absolute','border-top': '10px solid transparent','border-bottom': '10px solid transparent','border-left': '10px solid white','top':'50%','margin-top':'-10px','left':'50%','margin-left':'-5px'});
                $('.playlist_open_obj').css({'position': 'absolute','border-top': '10px solid transparent','border-bottom': '10px solid transparent','border-right': '10px solid white','top':'50%','margin-top':'-10px','left':'50%','margin-left':'-8px'});
                $('.playlist_open_obj').hide();
                $('.playlist_open').addClass('playlist_opened');
                for ( i = 0; i < toalvideo; i++ ) {
                    $('.dhflv_playlist').prepend('<div class="hdflv_video'+i+'" id="hdflv_video'+i+'"></div>');
                    $('.hdflv_video'+i).css({'display':'black','position': 'absolute','width': '240px','top':(i*72)+'px','height': '72px','border-bottom': '1px solid rgb(0, 0, 0)','background': '#414141','cursor':'pointer'});
                    $('.hdflv_video'+i).prepend('<img class="hdflv_thumb" src="'+hflv_option.playlist[i].thumb+'" width="74px" height="50px"/>');
                    $('.hdflv_thumb').css({'position': 'absolute','top':'11px','left':'11px'});
                    $('.hdflv_video'+i).prepend('<h3 class="hdflv_titletag">'+hflv_option.playlist[i].title+'</h3>');
                    $('.hdflv_titletag').css({'font-family': 'arial', 'font-size': '12px', 'color': '#fff', 'position': 'absolute', 'top': '0px', 'left': '96px','width':'140px','height':'30px','overflow':'hidden'});
                    $('.hdflv_video'+i).prepend('<h1 class="hdflv_des_tag">'+hflv_option.playlist[i].description+'</h1>');
                    $('.hdflv_des_tag').css({'font-family': 'arial', 'font-size': '9px', 'color': 'rgb(170, 167, 167)', 'position': 'absolute', 'top': '36px', 'left': '96px','width':'140px','height':'20px','overflow':'hidden'});
                    $('.hdflv_video'+i).hover(function(e){
                        $(this).css({'background': '#1F1E1E'});
                    }, function() {
                        if(!$(this).hasClass('curr_video')){
                            $(this).css({'background': '#414141'});
                        }
                    });
                    $('#hdflv_video'+i).on(handleClick,function(e){
                        clearInterval(myVar2)
                        $('.hdflv_video'+video_id).removeClass('curr_video');
                        $('.hdflv_video'+video_id).css({'background': '#414141'});
                        if(palyerType == 'flash'){
                            $('.hdflvFLASH').remove();
                            palyerType = 'html'
                            tagvalue = '<video width="'+hflv_option.width+'" height="'+hflv_option.height+'" pdoster="'+poster+'" class="hdflvplayer" id="hdflvplayer"  style="cursor: pointer">'
                            tagvalue +='</video>';
                            $('.player_container').append(tagvalue)
                        }else{
                            $('.hdflvplayer').empty();
                        }
                        streamer="";
                        video_id = e.currentTarget.className.slice(11);
                        streamer = hflv_option.playlist[video_id].streamer;
                        file = hflv_option.playlist[video_id].hd_file;
                        $('.hdflv_video'+video_id).css({'background': '#1F1E1E'});
                        $('.hdflvplayer').append('<source class="playersource" src="'+ file +'">')
                        if(($.browser.msie && $.browser.version<9.0) || file.indexOf("youtube")>-1 || streamer != undefined || file.indexOf("view.vzaar.com")>-1){
                            initFlash()
                        }
                        poster = hflv_option.playlist[e.currentTarget.className.slice(11)].poster;
                        ads_id = hflv_option.playlist[e.currentTarget.className.slice(11)].ads_id;
                        $('.hdflv_video'+video_id).addClass('curr_video');
                        src_error = false;
                        errorfunction();
                        playing = 'initial';
                        playpausevideo();
                        $('.hdflvplayer').bind(handleClick,playpausevideo);
                    });
                    $('.hdflv_video0').addClass('curr_video');
                    $('.hdflv_video'+video_id).css({'background': '#1F1E1E'});
                }
               $('.playlist_open').bind(handleClick,function(){
                   if(!$('.playlist_open').hasClass('playlist_opened')){
                      $('.playlist_open').addClass('playlist_opened');
                      $('.hdflv_playlist').animate({left:'100%','margin-left':'-250px'},400);
                      $('.playlist_open_obj').hide();
                      $('.playlist_hide_obj').show();
                   }else{
                      $('.hdflv_playlist').animate({left:'100%','margin-left':'5px'},400);
                      $('.playlist_open_obj').show();
                      $('.playlist_hide_obj').hide();
                      $('.playlist_open').removeClass('playlist_opened');
                   }
               });
               if(hflv_option.playlist_open != 'true'){
                   $('.playlist_open_obj').show();
                   $('.playlist_hide_obj').hide();
                   $('.playlist_open').removeClass('playlist_opened');
                   $('.hdflv_playlist').animate({left:'100%','margin-left':'5px'},10);
               }
            }
            if(hflv_option.share == 'true'){
                $('.hdlfv-skin-container').prepend('<span class="hdflv_share" id="hdflv_share"></span>');
                if(playlist == 'enable'){
                    $('.hdflv_share').css({'background': 'rgb(58, 54, 54)','position': 'absolute', 'height': '35px', 'width': '35px', 'top': '10px', 'left': '10px', '-moz-border-radius': '5px', 'border-radius':'5px','border': '1.5px solid rgb(92, 90, 90)', 'cursor': 'pointer'});
                }else{
                    $('.hdflv_share').css({'background': 'rgb(58, 54, 54)','position': 'absolute', 'height': '35px', 'width': '35px', 'top': '10px', 'left': '100%', 'margin-left': '-45px', '-moz-border-radius': '5px', 'border-radius':'5px','border': '1.5px solid rgb(92, 90, 90)', 'cursor': 'pointer'});
                }
                $('.hdflv_share').prepend('<span class="hdflv_share_icon" id="hdflv_share_icon"></span>');
                $('.hdflv_share_icon').css({'background': 'url(./skin/share.svg) no-repeat','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '5px', 'left':'5px'});
                $('body').prepend('<div class="hdflv_body" id="hdflv_body">')
                $('body').prepend('<div class="hdflv_share_bg" id="hdflv_share_bg">\n\
                                       <div class="hdflv_HR">\n\
                                           <span class="hdflv_shar_video_text"><b>Share this video</b></span>\n\
                                           <span class="hdflv_shar_close"><a id="hdflv-pop-up"><b>x</b></a></span>\n\
                                       </div>\n\
                                       <div class="hdflv-pop-up-contect">\n\
                                           <div class="share-right">\n\
                                               <h4 class="hd_l">Link</h4>\n\
                                               <input type="text" class="hdflv_linktxt">\n\
                                           </div>\n\
                                           <div class="share-left">\n\
                                                   <h4 class="hd_s">Social</h4>\n\
                                                   <ul class="hd_social_contianer">\n\
                                                   <li><a class="hd_social_image hd_social_facebook"></a></li>\n\
                                                   <li><a class="hd_social_image hd_social_twitter"></a></li>\n\
                                                   <li><a class="hd_social_image hd_social_googleplus"></a></li>\n\
                                                   <li><a class="hd_social_image hd_social_tumblur"></a></li>\n\
                                                   <li><a class="hd_social_image hd_social_pinterest"></a></li>\n\
                                                   <li><a class="hd_social_image hd_social_reddit"></a></li>\n\
                                                   </ul>\n\
                                           </div>\n\
                                           <div class="embed-div">\n\
                                             <h4 class="hd_e">Embed Url</h4>\n\
                                             <textarea type="text" class="embed-url"></textarea>\n\
                                           </div>\n\
                                           <p style="font-size: 12px;padding: 0px 10px;">This embedded video will include a text link.</p>\n\
                                       </div>\n\
                                   </div>');
                $('body').css({'margin':'0px','padding':'0px'})
                $('.hdflv_body').css({'display':'none','background':'#000','height':$(window).height()+'px','opacity': '0.8'})
                $('.hdflv_share_bg').css({'display': 'block', 'background-color': 'rgb(231, 236, 240)', 'position': 'fixed', 'width': '40%', 'top': '-170%', 'left': '30%', 'cursor': 'pointer', 'background-position': 'initial initial', 'background-repeat': 'initial initial','font-family': 'Arial','z-index':'99'});
                $('.hdflv_HR').css({'width': '100%', 'height': '30%', 'background': '#4d4d4d', 'float': 'left','color':'#fff','font-size': '25px'});
                $('.hdflv_shar_video_text').css({'width': '85%', 'float': 'left','padding': '10px 12px'});
                $('.hdflv_shar_close').css({'float': 'right','padding': '10px 12px','cursor':'pointer'});
                $('.hdflv-pop-up-contect').css({'clear': 'both','width': '94%','float': 'left','padding':'3%'});
                $('.share-right').css({'width': '45%','padding': '0px','float': 'left'});
                $('.hd_l,.hd_s,.hd_e').css({'color':'rgb(41, 51, 50)','margin':'0 0 10px'});
                $('.hd_social_contianer').css({'list-style-type':'none','padding':'0px','margin':'0px'});
                $('.hd_social_image').css({'width': '38px','height': '38px','background': 'url(./skin/sprite_share_social.png) no-repeat','float':'left','padding':'0 6px 0 0'});
                $('.hd_social_facebook').css({'background-position': '0px 0px'});
                $('.hd_social_twitter').css({'background-position': '-43px 0px'});
                $('.hd_social_googleplus').css({'background-position': '-86px 0px'});
                $('.hd_social_tumblur').css({'background-position': '-130px 0px'});
                $('.hd_social_pinterest').css({'background-position': '-173px 0px'});
                $('.hd_social_reddit').css({'background-position': '-216px 0px'});
                $('.hdflv_linktxt').css({'width': '95%','height': '30px','border':'3px solid #d2d2d2'});
                $('.share-left').css({'width': '52%','padding': '0px','float': 'right'});
                $('.embed-div').css({'clear': 'both','padding': '15px 0 0'});
                $('.embed-url').css({'width': '98%','height': '55px','border':'3px solid #d2d2d2'});

                $('.hdflv_share,.hdflv_shar_close,.hdflv_body').bind(handleClick,function(){
                   $('.hdflv-video-play-button').hide();
                   if(!$('.hdflv_share').hasClass('isShare')){
                       $('.hdflv_share_bg,.hdflv_body').css({'display':'block'});
                       $('.hdflv_share').addClass('isShare');
                       $('.hdflv_share_bg').fadeIn('fast').animate({
                           'top': 50
                           }, {duration: 'slow', queue: false}, function() {
                       });
                   }else{
                       $('.hdflv_share_bg,.hdflv_body').css({'display':'none'});
                       $('.hdflv_share_bg').fadeIn('fast').animate({
                           'top': -500
                           }, {duration: 'slow', queue: false}, function() {
                       });
                       $('.hdflv_share').removeClass('isShare');
                       if(!$('.hdflv-video-play-button').hasClass('playing')){
                       $('.hdflv-video-play-button').show()
                       }
                   }
                });
            }
            function errorfunction(msg){
                $(".playersource").error(function (e) {
                    if(src_error == false){
                        initFlash();
                    }
                });
                $(".playersource").bind('error',function(e,ui) {
                    if(src_error == false){
                        initFlash();
                    }
                });
                $('.hdflvplayer').bind('error',function(e,ui) {
                    if(src_error == false){
                        initFlash();
                    }
                });
            }
            errorfunction();
            if( palyerType == 'flash')initFlash();
            var $video_container = $hdflv.parent('.hdflv-video-player');
            var rightpo = 35;
            var volume_level = 50;
            var volume_deault = 100;
            if(hflv_option.volume_level>100){
                hflv_option.volume_level = 100;
            }
            $('.hd-flv-player').remove();
            $('.sprite-image').css({'background': 'url(./skin/snippets-2.png) no-repeat'});
            $('.hdflv-video-player').css({'position': 'absolute', 'background': '#000','width': hflv_option.width+'px','height': hflv_option.height+'px'});
            $('.hdflv-video-play-button').css({'background-position': '-298px -12px','position': 'absolute', 'height': '70px', 'width': '70px', 'top': '50%', 'margin-top': '-35px', 'left': '50%', 'margin-left': '-35px', 'cursor': 'pointer'});
            $('.hdflv-skinBg').css({'background': 'url(./skin/skin_bg.png) repeat-x', 'width':'100%' , 'position': 'absolute', 'height': '30px', 'bottom': '0%', 'display': 'block'});
            $('.hdflv-play-pause').css({'background-position': '-1px -5px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
            if(hflv_option.fullscreen != 'false'){
                $('.hdflv-fullscreen').css({'background-position': '-115px -3px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'left': '100%', 'margin-left': -rightpo+'px', 'cursor': 'pointer'});
                rightpo = rightpo+30;
            }else{
                $('.hdflv-fullscreen').remove();
            }
            if(hflv_option.volume != 'false'){
                $('.hdflv-volume').css({'background-position': '-240px -4px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'left': '100%', 'margin-left': -rightpo+'px', 'cursor': 'pointer'});
                $('.hdflv-volume-bg').css({'background': 'url(./skin/volumbg.png) no-repeat','display': 'none','position': 'absolute', 'height': '103px', 'width': '28px', 'top': '100%', 'margin-top': '-134px'});
                $('.hdlflv-volume-progress-bg').css({'position': 'absolute','width': '8px','height': '82px', 'border': '1px solid #333', 'bottom': '8px', 'left': '9px', '-moz-border-radius': '10px', '-ms-border-radius': '10px', '-webkit-border-radius': '10px', 'border-radius':'10px', 'display': 'block','background': '#000', 'background-image': '-moz-linear-gradient(top, #000, #000)', 'cursor': 'pointer'});
                volume_deault = $('.hdlflv-volume-progress-bg').height();
                volume_level = (hflv_option.volume_level/100)* $('.hdlflv-volume-progress-bg').height();
                $('.hdlflv-volume-progress').css({'position': 'absolute','width': '7px','height': volume_level+'px', 'bottom': '8px', 'left': '10px', '-moz-border-radius': '10px', '-ms-border-radius': '10px', '-webkit-border-radius': '10px', 'border-radius':'10px', 'display': 'block','background': 'rgb(255, 253, 253)', 'background-image': '-moz-linear-gradient(top, #000, #000)', 'cursor': 'pointer'});
                $('.hdlflv-mute').css({'position': 'absolute','width': '28px','height': '23px', 'bottom': '-26px', 'left': '1px', 'display': 'block','background': 'rgb(255, 253, 253)', 'opacity': '0', 'cursor': 'pointer'});
                rightpo = rightpo+30;
            }else{
                $('.hdflv-volume').remove();
            }
            if(hflv_option.hd != 'false'){
                $('.hdflv-hd-swipe').css({'background-position': '-41px -4px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'left': '100%', 'margin-left': -rightpo+'px', 'cursor': 'pointer'});
                $('.setting_bg').css({'display':'none','position': 'absolute','width': '120px','height': '48px', 'bottom': '32px', 'left': '-88px','background': 'rgb(54, 49, 49)','opacity': '1', 'border': '1px solid rgb(27, 27, 27)'});
                $('.speed_button').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute','width': '70px','height': '20px', 'bottom': '1px', 'left': '47px','display': 'block','background': 'rgb(255, 255, 255)','opacity': '1', 'border': '1px solid rgb(27, 27, 27)'});
                $('.speed_bg').css({'position': 'absolute','width': '70px','height': '102px', 'bottom': '48px', 'left': '-1px', 'display': 'none','background': 'rgb(255, 255, 255)','opacity': '1', 'border': '1px solid rgb(27, 27, 27)'});
                $('.speed_text').css({'font-family': 'arial', 'font-size': '12px', 'color': '#fff', 'position': 'absolute', 'top': '28px', 'left': '4px'});

                $('.current_speed').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '2px', 'left': '4px'});
                $('.speed_downn_arraow').css({'position': 'absolute','left':'54px','bottom':'7px','width': '0px', 'height': '0px','border-left': '5px solid transparent','border-right': '5px solid transparent','border-bottom': '5px solid black'});
                $('.2xSp').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '4px', 'left': '20px'});
                $('.1_5xSp').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '24px', 'left': '20px'});
                $('.normalSp').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '44px', 'left': '20px'});
                $('.0_5xSp').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '64px', 'left': '20px'});
                $('.0_25xSp').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '84px', 'left': '20px'});
                $('.speed_select').css({'font-family': 'arial', 'font-size': '44px', 'color': '#000', 'position': 'absolute', 'top': '14px', 'left': '2px'});

                $('.quality_button').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute','width': '70px','height': '20px', 'bottom': '25px', 'left': '47px','display': 'block','background': 'rgb(255, 255, 255)','opacity': '1', 'border': '1px solid rgb(27, 27, 27)'});
                $('.quality_bg').css({'position': 'absolute','width': '70px','height': '44px', 'bottom': '24px', 'left': '-1px', 'display': 'none','background': 'rgb(255, 255, 255)','opacity': '1', 'border': '1px solid rgb(27, 27, 27)'});
                $('.quality_text').css({'font-family': 'arial', 'font-size': '12px', 'color': '#fff', 'position': 'absolute', 'top': '5px', 'left': '4px'});
                $('.current_quality').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '2px', 'left': '4px'});
                $('.current_quality')[0].innerHTML = qtxt;
                $('.quality_downn_arraow').css({'position': 'absolute','left':'54px','bottom':'7px','width': '0px', 'height': '0px','border-left': '5px solid transparent','border-right': '5px solid transparent','border-bottom': '5px solid black'});
                $('.QNormal').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '4px', 'left': '20px'});
                $('.QHD').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '24px', 'left': '20px'});
                $('.Quality_select').css({'font-family': 'arial', 'font-size': '44px', 'color': '#000', 'position': 'absolute', 'top': qy+'px', 'left': '2px'});
                rightpo = rightpo+30;
                $('.hdflv-hd-swipe,.setting_bg').hover(function(e){
                  $('.setting_bg').fadeIn(500);
                  $(".hdflv-volume-bg").fadeOut();
                  $('.setting_bg,.hdflv-hd-swipe').on('mouseout',function(et){
                      setTimeout(function () {if(speedOver == false){
                              $(".setting_bg").fadeOut();
                              $('.speed_bg').fadeOut();
                              $('.quality_bg').fadeOut();
                              qualityBg = speedBg = false;
                          }}, 1000);
                      speedOver = false;
                  });
                  $('.setting_bg').on('mousemove',function(et){
                      $('.setting_bg').stop("mouseout");
                      speedOver = true;
                  });
                });
                $('.speed_button').on('mousedown',function(){
                    qualityBg = false;
                    $('.quality_bg').fadeOut();
                    if(speedBg == false){
                        $('.speed_bg').fadeIn(500);
                        speedBg = true;
                    }else{
                        speedBg = false;
                        $('.speed_bg').fadeOut();
                    }
                });
                $('.2xSp,.1_5xSp,.normalSp,.0_5xSp,.0_25xSp').on('mousedown',function(e){
                   switch (e.target.className){
                      case ('2xSp'):
                            playbackrate = 2;
                            $('.current_speed')[0].innerHTML = '2x';
                            $('.speed_select').css({'top': '-24px'});
                            break;
                      case ('1_5xSp'):
                            playbackrate = 1.5;
                            $('.current_speed')[0].innerHTML = '1.5x';
                            $('.speed_select').css({'top': '-4px'});
                            break;
                      case ('normalSp'):
                            playbackrate = 1;
                            $('.current_speed')[0].innerHTML = 'Normal';
                            $('.speed_select').css({'top': '14px'});
                            break;
                      case ('0_5xSp'):
                            playbackrate = 0.5;
                            $('.current_speed')[0].innerHTML = '0.5x';
                            $('.speed_select').css({'top': '34px'});
                            break;
                      case ('0_25xSp'):
                            playbackrate = 0.25;
                            $('.current_speed')[0].innerHTML = '0.25x';
                            $('.speed_select').css({'top': '54px'});
                            break;
                      default:
                            playbackrate = 1;
                            $('.current_speed')[0].innerHTML = 'Normal';
                            $('.speed_select').css({'top': '14px'});
                   }
                      $('.hdflvplayer')[0].playbackRate = playbackrate;
                   });
                   $('.quality_button').on('mousedown',function(){
                      speedBg = false;
                      $('.speed_bg').fadeOut();
                      if(qualityBg == false){
                          $('.quality_bg').fadeIn(500);
                          qualityBg = true;
                      }else{
                          qualityBg = false;
                          $('.quality_bg').fadeOut();
                      }
                    });
                    $('.QNormal,.QHD').on('mousedown',function(e){
                        switch (e.target.className){
                         case ('QNormal'):
                               file = hflv_option.file;
                               qy = -25;
                               qtxt = 'Normal'
                               $('.current_quality')[0].innerHTML = 'Normal';
                               break;
                         case ('QHD'):
                               file = hflv_option.hd_file;
                               qy = -5
                               qtxt = 'HD'
                               break;
                       }
                       $('.current_quality')[0].innerHTML = qtxt;
                       $('.Quality_select').css({'top': qy+'px'});
                       $('.playersource').remove();
                       var ntt = currentTime * (100 / duration);
                       relX = (ntt * totalWidth)/100
                       seekto = relX * (duration / totalWidth);
                       $('.hdflvplayer').append('<source class="playersource" src="'+ file +'">');
                       $('.hdflvplayer')[0].currentTime = seekto;
                        setTimeout(function () {$('.hdflvplayer')[0].currentTime = seekto;}, 500);
                    });
            }else{
                $('.hdflv-hd-swipe').remove();
            }
            if(hflv_option.timer != 'false'){
                rightpo = rightpo+10;
                $('.hdflv-duration').css({'font-family': 'arial', 'font-size': '12px', 'color': '#999', 'position': 'absolute', 'height': '30px', 'width': '40px', 'top': '100%', 'margin-top': '-30px', 'left': '100%', 'margin-left': -rightpo+'px', 'line-height': '33px'});
                rightpo = rightpo+35;
                $('.hdflv-currentTime').css({'font-family': 'arial','font-size': '12px','color': '#fff', 'position': 'absolute', 'height': '30px', 'width': '40px', 'top': '100%', 'margin-top': '-30px', 'left': '100%', 'margin-left': -rightpo+'px', 'line-height': '33px'});
                rightpo = rightpo+30;
            }else{
                $('.hdflv-duration').remove();
                $('.hdflv-currentTime').remove();
            }
            if(hflv_option.progress != 'false'){
                $('.hdlflv-skin-progress-bg').css({'position': 'absolute','width': (hflv_option.width-(rightpo+15))+'px','height': '10px', 'border': '1px solid #333', 'bottom': '8px', 'left': '33px', '-moz-border-radius': '10px', '-ms-border-radius': '10px', '-webkit-border-radius': '10px', 'border-radius':'10px', 'display': 'block','background': '#000', 'background-image': '-moz-linear-gradient(top, #000, #000)', 'background-image': '-webkit-gradient(linear,left top,left bottom,color-stop(0, #000),color-stop(1, #000))', 'box-shadow': 'inset 0 -3px 3px #000', 'cursor': 'pointer'});
                $('.hdlflv-skin-buffer').css({'position': 'absolute','width': 0+'px','height': '8px','bottom': '10px', 'left': '33px', '-moz-border-radius': '10px', '-ms-border-radius': '10px', '-webkit-border-radius': '10px', 'border-radius':'10px', 'display': 'block','background': 'rgb(138, 135, 135)', 'background-image': '-webkit-gradient(linear, 0% 0%, 0% 100%, from(rgb(179, 179, 179)), to(rgb(61, 59, 59)))', 'box-shadow': 'rgb(134, 133, 133) 0px 1px 2px inset', 'cursor': 'pointer'});
                $('.hdlflv-skin-seek').css({'position': 'absolute','width':0+'px','height': '8px','bottom': '10.5px', 'left': '33px', '-moz-border-radius': '10px', '-ms-border-radius': '10px', '-webkit-border-radius': '10px', 'border-radius':'10px', 'display': 'block','background': 'rgb(255, 253, 253)', 'background-image': '-webkit-gradient(linear, 0% 0%, 0% 100%, from(rgb(255, 252, 252)), to(rgb(255, 255, 255)))', 'box-shadow': 'rgb(216, 216, 216) 0px 1px 2px inset', 'cursor': 'pointer'});
            }else{
                $('.hdlflv-skin-progress-bg').remove();
                $('.hdlflv-skin-buffer').remove();
                $('.hdlflv-skin-seek').remove();
            }
            function errorMessage(msg) {
                $('.hdflv-video-play-button').hide();
                $('.error_message').text( msg );
                $('.error_message').css({'float':'left', 'width':($('.error_board').width()-62)+'px','text-align':'left','margin':'10px 10px 10px 10px'});
                $('.error_board').css({'height': ($('.error_message').height()+20)+'px','margin-top': '-'+($('.error_message').height()-50)+'px','margin-left': '-'+($('.error_board').width()/2)+'px'});
                $('.error_board_icon').css({'margin-left': '7px','margin-top': ($('.error_message').height()/2)-5+'px'});
             };
            $('.hdflv-video-player').prepend('<div class="error_board" id="error_board">\n\
                                                      <i class="error_board_icon"></i><span class="error_message"></span>\n\
                                                 </div>')
            $('.error_board').css({'position': 'absolute','width': '55%','height': '50px', 'top': '50%', 'margin-top': '-20px', 'left': '50%', 'margin-left': '-155px', 'display': 'none','background': '#FFFEDB','border-radius':'5px', 'moz-border-radius':'5px', 'webkit-border-radius':'5px', 'opacity': '1', 'border': '2px solid #F1C85F'});
            $('.error_board_icon').css({'background': 'url(./skin/error_board_icon.png) no-repeat','width': '34px','height': '31px','float': 'left'});
            $('.error_message').css({'font-family': 'arial', 'font-size': '15px', 'color': '#000', 'line-height': '20px'});
            $('.hdflv-video-play-button,.hdflv-play-pause,.hdflvplayer,#hflvplayerflash').bind(handleClick,playpausevideo);
            function onTrackedVideoFrame2(){
                $('#hflvplayerflash').externalInterface({method:'getCurrentTime',success: function(response){currentTime= response;}});
                $('#hflvplayerflash').externalInterface({method:'getDuration',success: function(response){duration= response;}});
                $('#hflvplayerflash').externalInterface({method:'getbytesLoaded',success: function(response){bytesLoaded= response;}});
                $('#hflvplayerflash').externalInterface({method:'getbytesTotal',success: function(response){totalBytes= response;}});
                $('#hflvplayerflash').externalInterface({method:'getplayerstate',success: function(response){
                    if(response == 'paused'){
                      $('.hdflv-play-pause').css({'background-position': '-1px -5px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                      $('.hdflv-video-play-button').show();
                    }else if(response == 'playing'){
                      $('.hdflv-video-play-button').hide();
                      $('.hdflv-play-pause').css({'background-position': '0px -36px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                    }else if(response == 'unstarted' || response == 'initial'){
                      $('.hdflv-video-play-button').hide();
                      $('.hdflv-play-pause').css({'background-position': '0px -36px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                    }else if(response == 'ended'){
                      clearInterval(myVar2)
                      playing = 'false';
                      $('.hdflv-play-pause').css({'background-position': '-1px -5px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                      $('.hdflv-video-play-button').show();
                    }
                }});
                onTrackedVideoFrame(currentTime,duration);
            }
            function onTrackedVideoFrame(currentTime, durations){
                duration = durations;
                if(!isNaN(currentTime)){
                    $('.hdflv-currentTime').text(gTimeFormat(currentTime));
                    $('.hdflv-duration').text('/ '+gTimeFormat(duration));
                    totalWidth = $('.hdlflv-skin-progress-bg').width();
                    var nt = currentTime * (100 / duration);
                    if(drg == true){
                        $('.hdlflv-skin-seek').width((nt * totalWidth)/100);
                    }
                    if(palyerType == 'html'){
                        if(!isNaN($('.hdflvplayer').get(0).duration)){
                            $('.hdlflv-skin-buffer').width(($('.hdflvplayer').get(0).buffered.end(0) / $('.hdflvplayer').get(0).duration)*totalWidth);
                        }
                    }else if(!isNaN(totalBytes) && $('.hdlflv-skin-buffer').width()<=totalWidth ){
                        $('.hdlflv-skin-buffer').width(bytesLoaded * totalWidth / totalBytes);
                    }else{
                            $('.hdlflv-skin-buffer').width(totalWidth);
                        }
                }
            }
            function gTimeFormat(seconds){
                var m=Math.floor(seconds/60)<10?"0"+Math.floor(seconds/60):Math.floor(seconds/60);
                var s=Math.floor(seconds-(m*60))<10?"0"+Math.floor(seconds-(m*60)):Math.floor(seconds-(m*60));
                return m+":"+s;
            };
            $('.hdlflv-skin-progress-bg,.hdlflv-skin-buffer,.hdlflv-skin-seek').mousedown(function(e){
                if(ads_playing == false){
                    drg = false;
                    parentOffset = $('.hdlflv-skin-seek,.hdlflv-skin-progress-bg,.hdlflv-skin-buffer').offset();
                    relX = e.pageX - parentOffset.left;
                    relY = e.pageY - parentOffset.top;
                    seekto = relX * (duration / totalWidth);
                    if(palyerType == 'html'){
                        $('.hdflvplayer')[0].currentTime = seekto;
                    }else{
                        $('#hflvplayerflash').externalInterface({method:'seekVideo',args:seekto});
                    }
                    $('.hdlflv-skin-seek').width(relX);
                    $(document).on('mousemove',function(et){
                        parentOffset = $('.hdlflv-skin-seek,.hdlflv-skin-progress-bg,.hdlflv-skin-buffer').offset();
                        relX = et.pageX - parentOffset.left;
                        relY = et.pageY - parentOffset.top;
                        seekto = relX * (duration / totalWidth);
                         if(palyerType == 'html'){

                            $('.hdflvplayer')[0].currentTime = seekto;
                         }else{
                             $('#hflvplayerflash').externalInterface({method:'seekVideo',args:seekto});
                         }
                        if(relX<totalWidth){
                            $('.hdlflv-skin-seek').width(relX);
                        }else{
                            $('.hdlflv-skin-seek').width(totalWidth);
                        }
                    });
                }
            });
            function fullscreeEvent(){
                if ($video_container[0].requestFullscreen) {
                   $video_container[0].requestFullscreen();
                }else if ($video_container[0].msRequestFullscreen) {
                   $video_container[0].msRequestFullscreen();
                }else if ($video_container[0].mozRequestFullScreen) {
                   $video_container[0].mozRequestFullScreen();
                }else if ($video_container[0].webkitRequestFullscreen) {
                   $video_container[0].webkitRequestFullscreen();
                }
                $('#hflvplayerflash').attr({'width': $(document).width(),'height': $(window).height()});
                $('.hdflvplayer').css({'position': 'absolute','width': '100%','height': '100%'});
                $('.hdflv-video-player').css({'width': '100%','height': '100%','top': '0','left': '0'});
                $('.hdlflv-skin-progress-bg').css({'position': 'absolute','width': ($(window).width()-(rightpo+15))+'px','height': '10px'});
                $('.hdflv-fullscreen').addClass('isFullScreenMode');
                $('.hdflv-fullscreen').css({'background-position': '-115px -38px'});
            };
            function getoriginalSize(){
                $('#hflvplayerflash').attr({'width': hflv_option.width,'height': hflv_option.height});
                $('.hdlflv-skin-seek').css({'position': 'absolute','width':0+'px','height': '8px','bottom': '10.5px', 'left': '33px', '-moz-border-radius': '10px', '-ms-border-radius': '10px', '-webkit-border-radius': '10px', 'border-radius':'10px', 'display': 'block','background': 'rgb(255, 253, 253)', 'background-image': '-webkit-gradient(linear, 0% 0%, 0% 100%, from(rgb(255, 252, 252)), to(rgb(255, 255, 255)))', 'box-shadow': 'rgb(216, 216, 216) 0px 1px 2px inset', 'cursor': 'pointer'});
                $('.hdlflv-skin-buffer').css({'position': 'absolute','width': 0+'px','height': '8px','bottom': '10px', 'left': '33px', '-moz-border-radius': '10px', '-ms-border-radius': '10px', '-webkit-border-radius': '10px', 'border-radius':'10px', 'display': 'block','background': 'rgb(138, 135, 135)', 'background-image': '-webkit-gradient(linear, 0% 0%, 0% 100%, from(rgb(179, 179, 179)), to(rgb(61, 59, 59)))', 'box-shadow': 'rgb(134, 133, 133) 0px 1px 2px inset', 'cursor': 'pointer'});
                $('.hdflv-video-player').css({'position': 'absolute','width': hflv_option.width+'px','height': hflv_option.height+'px'});
                $('.hdflvplayer').css({'width': hflv_option.width+'px','height': hflv_option.height+'px'});
                $('.hdlflv-skin-progress-bg').css({'position': 'absolute','width': (hflv_option.width-(rightpo+15))+'px','height': '10px'});
                $('.hdflv-fullscreen').removeClass('isFullScreenMode');
                $('.hdflv-fullscreen').css({'background-position': '-115px -3px'});

            };
            function exitfullscreeEvent(){
                    if (document.cancelFullScreen) {
                        document.cancelFullScreen();
                    } else if (document.mozCancelFullScreen) {
                        document.mozCancelFullScreen();
                    } else if (document.webkitCancelFullScreen) {
                        document.webkitCancelFullScreen();
                    }else if (document.exitFullscreen) {
                        document.exitFullscreen();
                    }
                    getoriginalSize();
            };
            $('.hdflv-fullscreen').bind(handleClick,function(){
                var $that = $(this);
                if(!$that.hasClass('isFullScreenMode')){
                    fullscreeEvent();
                    if(palyerType == 'flash')var myVar3 = setInterval(function(){fullscreeEvent();},0.5);
                    setTimeout(function () {if(palyerType == 'flash'){clearInterval(myVar3)}}, 300);
                }else{
                    jQuery.event.trigger({ type : 'keyup', which : 27 });
                    exitfullscreeEvent();
                    if(palyerType == 'flash')var myVar4 = setInterval(function(){exitfullscreeEvent();},0.5);
                    setTimeout(function () {if(palyerType == 'flash'){clearInterval(myVar4)}}, 300);
                }
            });
            $(window).keyup(function(e){
                if(e.which == 27){
                    exitfullscreeEvent();
                    if($('.hdflv-fullscreen').hasClass('isFullScreenMode')){
                        $('.hdflv-fullscreen').removeClass('isFullScreenMode');
                        $('.hdflv-fullscreen').css({'background-position': '-115px -3px'});
                    }
                }
            });
            $('.hdlflv-volume-progress-bg,.hdlflv-volume-progress').mousedown(function(e){
                //e.preventDefault();
                parentOffset = $('.hdlflv-volume-progress-bg,.hdlflv-volume-progress').offset();
                relX = e.pageX - parentOffset.left;
                relY = e.pageY - parentOffset.top;
                seekto = volume_deault-relY;
                if(seekto>volume_deault){seekto = volume_deault;}
                else if(seekto<0){seekto = 0;}
                if(palyerType == 'html'){
                    $('.hdflvplayer')[0].volume = seekto/volume_deault;
                }else{
                    $('#hflvplayerflash').externalInterface({method:'setVolume',args:seekto/volume_deault});
                }
                if(drg == true){
                    $('.hdlflv-volume-progress').height(seekto);
                }
                if(seekto/volume_deault>=0.5){
                $('.hdflv-volume').css({'background-position': '-240px -4px'});
                }else{
                     if(seekto/volume_deault<=0){$('.hdflv-volume').css({'background-position': '-239px -123px'});}
                     else {$('.hdflv-volume').css({'background-position': '-239px -94px'});}
                }
                volume_level = seekto;
                $(document).on('mousemove',function(et){
                    relX = et.pageX - parentOffset.left;
                    relY = et.pageY - parentOffset.top;
                    seekto = volume_deault-relY;
                    if(seekto>volume_deault){seekto = volume_deault;}
                    else if(seekto<0){seekto = 0;}
                    if(palyerType == 'html'){
                        $('.hdflvplayer')[0].volume = seekto/volume_deault;
                    }else{
                        $('#hflvplayerflash').externalInterface({method:'setVolume',args:seekto/volume_deault});
                    }
                    if(drg == true){
                        $('.hdlflv-volume-progress').height(seekto);
                    }
                    if(seekto/volume_deault>=0.5){
                    $('.hdflv-volume').css({'background-position': '-240px -4px'});
                    }else{
                         if(seekto/volume_deault<=0){$('.hdflv-volume').css({'background-position': '-239px -123px'});}
                         else {$('.hdflv-volume').css({'background-position': '-239px -94px'});}
                    }
                    volume_level = seekto;
                });
            });
            $('.hdlflv-mute').mousedown(function(e){
                if(!$(this).hasClass('hdflv-muted')){
                        $(this).addClass('hdflv-muted');
                        $('.hdflv-volume').css({'background-position': '-239px -123px'});
                        $('.hdflvplayer')[0].volume = 0;
                        $('.hdlflv-volume-progress').height(0);
                    }else{
                        $(this).removeClass('hdflv-muted');
                        $('.hdflv-volume').css({'background-position': '-240px -4px'});
                        $('.hdflvplayer')[0].volume = volume_level/volume_deault;
                        $('.hdlflv-volume-progress').height(volume_level);
                        if(volume_level/volume_deault>=0.5){
                        $('.hdflv-volume').css({'background-position': '-240px -4px'});
                        }else{
                             if(volume_level/volume_deault<=0){$('.hdflv-volume').css({'background-position': '-239px -123px'});}
                             else {$('.hdflv-volume').css({'background-position': '-240px -94px'});}
                        }
                    }
            });
            $('.hdlflv-mute,.hdflv-volume').hover(function(e){
               $(".hdflv-volume-bg").fadeIn(800);
               $(".setting_bg").fadeOut();
               qualityBg = speedBg = false;
               over = true;
               $('.hdflv-volume').on('mouseout',function(et){
                   setTimeout(function () {if(over == false){$(".hdflv-volume-bg").fadeOut();}}, 1000);
                   over = false;
               });
               $('.hdflv-volume').on('mousemove',function(et){
                   $('.hdflv-volume').stop("mouseout");
                   over = true;
               });
            });
            $('.hdflv-video-player,.hdflvFLASH,.hdflvplayer').hover(function(e){
                if(ads_playing == false){
                    $(".hdlfv-skin-container").fadeIn(600);
                    skinOver = true;
                    $('.hdflv-video-player').on('mouseout',function(et){
                        setTimeout(function () {if(skinOver == false &&  ads_playing == false){$(".hdlfv-skin-container").fadeOut(500);}}, 500);
                        skinOver = false;
                    });
                    $('.hdflv-video-player,.hdflvplayer').on('mousemove',function(et){
                        $('.hdflv-video-player').stop("mouseout");
                        skinOver = true;
                    });
                }
            });
            $(document).on('mouseup', function(evt) {
                    $(document).unbind("mousemove");
                     setTimeout(function () {drg = true;}, 50);
            });
            $('.hdlfv-skin-container').on('mousedown', function(evt) {
                 // evt.preventDefault();
            });
            $(document).bind("contextmenu",function(e){
                    return false;
            });
            $(document).on("mousedown", function (e) {
                $('.contextmenu').remove();
            });
            $('.hdflv-video-player').bind("contextmenu", function(event) {
                //event.preventDefault();
                $('.contextmenu').remove();
                $("<div class='contextmenu'><ul><li class='copyright'>HD FLV Player</li></ul></div>").appendTo("body").css({top: event.pageY + "px", left: event.pageX + "px", 'position': 'absolute','background': '#FFFEDB','border-radius':'5px', 'moz-border-radius':'5px', 'webkit-border-radius':'5px', 'opacity': '1', 'border': '2px solid #F1C85F','width': '150px'});
            });
            $(window).resize(function () {
                if (document.fullScreen == false || document.mozFullScreen == false || document.webkitIsFullScreen == false) {
                     getoriginalSize();
                }
            });
            $('.hdflv-video-player,.hdflvplayer,.dhflv_playlist,.hdflv_video0,.hdflv_thumb').on('touchstart click tap', function(e){
            });
            var adsManager;
            var adsLoader;
            var adDisplayContainer;
            var intervalTimer;
            var videoContent;
            function createAdDisplayContainer() {
                /**
                 * We assume the adContainer is the DOM id of the element that will house the ads.
                 */
                adDisplayContainer = new google.ima.AdDisplayContainer(document.getElementById('adContainer'));
            }
            function requestAds() {
                $('.hdflv-video-player').prepend('<div id="adContainer"></div>');
                $('#adContainer').prepend('<div class="ads_duraiton_ind">Advertisement: (00:00)</div>')
                $('.ads_duraiton_ind').css({'position':'absolute','width':'100%','background-color':'black','color': '#e5bb00','text-align': 'left','font': 'normal 12px arial,helvetica,sans-serif','min-width': '150px','padding': '6px 10px','top':'100%','margin-top': '-30px'});
                if(ads_provider == 'ima'){

                    videoContent = document.getElementById('hdflvplayer');
                    /**
                     * Create the ad display container.
                     */
                    createAdDisplayContainer();
                    /**
                     * Initialize the container. Must be done via a user action on mobile devices.
                     */
                    adDisplayContainer.initialize();
                    /**
                     * Create ads loader.
                     */
                    adsLoader = new google.ima.AdsLoader(adDisplayContainer);
                    /**
                     * Listen and respond to ads loaded and error events.
                     */
                    adsLoader.addEventListener(google.ima.AdsManagerLoadedEvent.Type.ADS_MANAGER_LOADED,onAdsManagerLoaded,false);
                    adsLoader.addEventListener(google.ima.AdErrorEvent.Type.AD_ERROR,onAdError,false);
                    /**
                     * Request video ads.
                     */
                    var adsRequest = new google.ima.AdsRequest();
                    adsRequest.adTagUrl =ads_url;
                    /**
                     * Specify the linear and nonlinear slot sizes. This helps the SDK to
                     * select the correct creative if multiple are returned.
                     */
                    adsRequest.linearAdSlotWidth = 640;
                    adsRequest.linearAdSlotHeight = 400;
                    adsRequest.nonLinearAdSlotWidth = 640;
                    adsRequest.nonLinearAdSlotHeight = 150;
                    adsLoader.requestAds(adsRequest);
                    ads_playing = true;
                    $('.adContainer').css({'display': 'black'});
                    $('.hdflv-video-play-button').css({'z-index': -1});
                    $('.hdlfv-skin-container').hide()
                }else if(ads_provider == 'http'){
                    $('#adContainer').prepend('<video width="'+hflv_option.width+'" height="'+hflv_option.height+'" class="hdflv_adsplayer" autoplay>\n\
                                                  <source class="playersource" src="'+ads_url+'"></source>\n\
                                               </video>');
                    $('#adContainer').prepend('<div class="videoAdUiSkipButton">\n\
                                                <span class="skipbtText" style="padding: 0px 0 0 28px; float:left;"></div>\n\
                                               </div>')
                    ads_playing = true;
                    $('.hdflv-video-play-button').css({'z-index': -1});
                    $('.hdlfv-skin-container').hide()
                    $('.hdflv_adsplayer').bind('ended', function(){
                        ads_playing = false;
                        $('.hdlfv-skin-container').show();
                        $('.hdflv-video-play-button').css({'z-index': 0});
                        setTimeout(function () {$('#adContainer').remove();}, 100);
                        playpausevideo()
                    });
                    $('.videoAdUiSkipButton').on('click',function(e){
                        ads_playing = false;
                        $('.hdlfv-skin-container').show();
                        $('.hdflv-video-play-button').css({'z-index': 0});
                        setTimeout(function () {$('#adContainer').remove();}, 100);
                        playpausevideo()
                    });
                    $('.hdflv_adsplayer').bind("timeupdate",function(event){
                        $('.ads_duraiton_ind').text('Advertisement: ('+gTimeFormat(this.duration-this.currentTime)+')')
                        if(Math.floor(this.currentTime)<5){
                            if(!$('.videoAdUiSkipButton').hasClass('skipbefore')){
                                $('.videoAdUiSkipButton').removeAttr("style");
                                $('.videoAdUiSkipButton').addClass('skipbefore');
                                $('.skipbtText').css({'padding': '0px 0px 0px 13px', 'float':'left'})
                                $('.videoAdUiSkipButton').css({'position':'absolute','background': 'rgba(0,0,0,0.8)','left': '100%','margin-left': '-165px','top': '100%','margin-top': '-70px','color': '#e6e6e6','text-align': 'center','font': 'normal 11px arial, helvetica, sans-serif','min-width': '170px','padding': '10px 7px','cursor':'pointer'})
                            }
                            $('.skipbtText').text('You can skip to video in '+Math.floor(5-this.currentTime))
                        }else{
                            if(!$('.videoAdUiSkipButton').hasClass('skip')){
                                $('.skipbtText').text('Skip Ad')
                                $('.skipbtText').css({'padding': '0px 0 0 28px', 'float':'left'})
                                $('.videoAdUiSkipButton').removeAttr("style");
                                $('.videoAdUiSkipButton').css({'position':'absolute','background': 'rgba(0,0,0,0.8)','border-right':'0','left': '100%','border': '1px solid rgba(0,0,0,0)','margin-left': '-165px','top': '100%','margin-top': '-77px','color': 'white','text-align': 'center','font': 'normal 18px arial,helvetica,sans-serif','min-width': '150px','padding': '10px 7px','cursor':'pointer'})
                                $('.videoAdUiSkipButton').addClass('skip');
                                $('.videoAdUiSkipButton').prepend('<div class="videoAdUiSkipIcon"></div>');
                                $('.videoAdUiSkipIcon').css({'position':'absolute','background': 'url(./skin/skip_image.png) no-repeat','height': '25px','margin-left': '98px','width': '20px','vertical-align':'middle'});
                                $('.videoAdUiSkipButton').hover(function(e){
                                    $(this).css({'border': '1px solid rgba(255,255,255,0.5)'});
                                }, function() {
                                    $(this).css({'border': '1px solid rgba(0,0,0,0)'});
                                });
                            }
                        }
                     });
                }
            }
            function onAdsManagerLoaded(adsManagerLoadedEvent) {
                /**
                 * Get the ads manager.
                 */
                adsManager = adsManagerLoadedEvent.getAdsManager(videoContent);  // should be set to the content video element
                /**
                 * Add listeners to the required events.
                 */
                adsManager.addEventListener(google.ima.AdErrorEvent.Type.AD_ERROR,onAdError);
                adsManager.addEventListener(google.ima.AdEvent.Type.CONTENT_PAUSE_REQUESTED,onContentPauseRequested);
                adsManager.addEventListener(google.ima.AdEvent.Type.CONTENT_RESUME_REQUESTED,onContentResumeRequested);
                adsManager.addEventListener(google.ima.AdEvent.Type.ALL_ADS_COMPLETED,onAdEvent);
                /**
                 * Listen to any additional events, if necessary.
                 */
                adsManager.addEventListener(google.ima.AdEvent.Type.LOADED,onAdEvent);
                adsManager.addEventListener(google.ima.AdEvent.Type.STARTED,onAdEvent);
                adsManager.addEventListener(google.ima.AdEvent.Type.COMPLETE,onAdEvent);

                try {
                    /**
                    * Initialize the ads manager. Ad rules playlist will start at this time.
                    */
                    adsManager.init(hflv_option.width, hflv_option.height, google.ima.ViewMode.NORMAL);
                    /**
                    * Call play to start showing the ad. Single video and overlay ads will
                    * start at this time; the call will be ignored for ad rules.
                    */
                    adsManager.start();
                } catch (adError) {
                    /**
                    * An error may be thrown if there was a problem with the VAST response.
                    */
                    videoContent.play();
                }
            }
            function onAdEvent(adEvent) {
                /**
                 * Retrieve the ad from the event. Some events (e.g. ALL_ADS_COMPLETED)
                 * don't have ad object associated.
                 */
                var ad = adEvent.getAd();
                switch (adEvent.type) {
                    case google.ima.AdEvent.Type.LOADED:
                        /**
                        * This is the first event sent for an ad - it is possible to determine whether the ad is a video ad or an overlay.
                        */
                        if (!ad.isLinear()) {
                         /**
                        * Position AdDisplayContainer correctly for overlay.
                        * Use ad.width and ad.height.
                        */
                        }
                        break;
                    case google.ima.AdEvent.Type.STARTED:
                        ads_playing = true;
                        /**
                        * This event indicates the ad has started - the video player can adjust the UI, for example display a pause button and remaining time.
                        */
                        if (ad.isLinear()) {
                            /**
                            * For a linear ad, a timer can be started to poll for the remaining time.
                            */
                            intervalTimer = setInterval(
                            function() {
                              var remainingTime = adsManager.getRemainingTime();
                              $('.ads_duraiton_ind').text('Advertisement: ('+gTimeFormat(remainingTime)+')')
                            },
                            300); // every 300ms
                        }
                        break;
                    case google.ima.AdEvent.Type.COMPLETE:
                        /**
                        * This event indicates the ad has finished - the video player
                        * can perform appropriate UI actions, such as removing the timer for
                        * remaining time detection.
                        */
                        if (ad.isLinear()) {
                        clearInterval(intervalTimer);
                        }
                        ads_playing = false;
                        $('.hdlfv-skin-container').show();
                        $('.hdflv-video-play-button').css({'z-index': 0});
                        setTimeout(function () {$('#adContainer').remove();}, 100);
                        playpausevideo()
                        break;
                }
            }
            function onAdError(adErrorEvent) {
                /**
                * Handle the error logging.
                */
                console.log(adErrorEvent.getError());
                adsManager.destroy();
            }
            function onContentPauseRequested() {
                //videoContent.pause();
                /**
                * This function is where you should setup UI for showing ads (e.g.display ad timer countdown, disable seeking etc.)
                * setupUIForAds();
                */
            }
            function onContentResumeRequested() {
                //videoContent.play();
                /**
                * This function is where you should ensure that your UI is ready
                * to play content. It is the responsibility of the Publisher to
                * implement this function when necessary.
                */
            }

            function loadpreview(){
                if(autoplay == 'true'){
                    playpausevideo();
                }else{
                  $('.preview_image').remove();
                  $('.player_container').prepend('<img class="preview_image" src="'+poster+'">')
                  $('.preview_image').css({'position':'absolute','width':'100%','height':'100%','cursor':'pointer'})
                  $('.preview_image').bind(handleClick,playpausevideo);
                }
            }
        });
    };
});
