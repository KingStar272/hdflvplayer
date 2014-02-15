jQuery(document).ready(function($) {
    $.fn.hdflv = function(hflv_option) 
    {
        return this.each(function() 
        {
            var $hdflv = $(this);
            var palyerType,currentTime,duration,totalWidth=0,drg=true,myVar,parentOffset,relX,relY,seekto,skinOver=true,over=true,playing=false,player,totalBytes,bytesLoaded;
            var $video_wrap = $('<div></div>').addClass('hdflv-video-player');
            palyerType = 'html';
            hflv_option.videotag = '<video width="'+hflv_option.width+'" height="'+hflv_option.height+'" class="hdflvplayer"  poster="'+hflv_option.poster+'" style="cursor: pointer">\n\
                                        <source class="playersource" src="'+hflv_option.file+'"></source>';
            if($.browser.msie && $.browser.version<9.0){
                palyerType = 'flash';
                hflv_option.videotag += '<div class="hdflvFLASH" id="hdflvFLASH"></div>';
            }
            hflv_option.videotag +='</video>';
            var $hdflv_player = $(hflv_option.videotag+'<div class="hdflv-video-play-button sprite-image"></div>\n\
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
                                        <span class="hdflv-hd-swipe sprite-image"></span>\n\
                                        <span class="hdflv-duration">/ 00:00</span>\n\
                                        <span class="hdflv-currentTime">00:00</span>\n\
                                        <span class="hdlflv-skin-progress-bg"></span>\n\
                                        <span class="hdlflv-skin-buffer"></span>\n\
                                        <span class="hdlflv-skin-seek"></span>\n\
                                    </div>');
            $hdflv.wrap($video_wrap);
	    $hdflv.after($hdflv_player);  
            $('.hdflv-video-player').css({'top': '0','left': '0'});
            function initFlash()
            {
                var flashvars = {};
                var params = {};
         	params.file = hflv_option.file;
                params.poster = hflv_option.poster;
                var attributes = {};  
                var s1 = new SWFObject('hdplayer.swf','hflvplayerflash',hflv_option.width,hflv_option.height,'9');
                    s1.addParam('allowfullscreen','true');
                    s1.addParam('allowscriptaccess','always');
                    s1.addParam('wmode','transparent');
                    s1.addVariable('file',hflv_option.file);
                    s1.addVariable('poster',hflv_option.poster);
                    s1.addVariable('autoplay',hflv_option.autoplay);
                    s1.write('hdflvFLASH');
            }
            if( palyerType == 'flash')initFlash();
            var $video_container = $hdflv.parent('.hdflv-video-player');
            var $video_main_control = $('.hdflv-video-play-button', $video_container);
            var rightpo = 35;
            var volume_level = 50;
            var volume_deault = 100;
            if(hflv_option.volume_level>100){
                hflv_option.volume_level = 100;
            }
            $('.hd-flv-player').remove();
            $('.sprite-image').css({'background': 'url(./skin/snippets-2.png) no-repeat'});
            $('.hdflv-video-player').css({'position': 'absolute', 'background': '#000','width': hflv_option.width+'px','height': hflv_option.height+'px'});
            $('.hdflv-video-play-button').css({'background-position': '-298px -12px','position': 'absolute', 'height': '70px', 'width': '70px', 'top': '50%', 'margin-top': '-35px', 'left': '50%', 'margin-left': '-35px', 'cursor': 'pointer', 'z-index': '999'});
            $('.hdflv-skinBg').css({'background': 'url(./skin/skin_bg.png) repeat-x', 'width':'100%' , 'position': 'absolute', 'height': '30px', 'bottom': '0%','z-index': '0', 'display': 'block'});
            $('.hdflv-play-pause').css({'background-position': '-1px -5px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
            if(hflv_option.fullscreen != 'false'){
                $('.hdflv-fullscreen').css({'background-position': '-115px -3px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'left': '100%', 'margin-left': -rightpo+'px', 'cursor': 'pointer'});
                rightpo = rightpo+30;
            }else{
                $('.hdflv-fullscreen').remove();
            }
            if(hflv_option.volume != 'false'){
                $('.hdflv-volume').css({'background-position': '-240px -4px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'left': '100%', 'margin-left': -rightpo+'px', 'cursor': 'pointer'});
                $('.hdflv-volume-bg').css({'background': 'url(./skin/volumbg.png) no-repeat','display': 'none','position': 'absolute', 'height': '103px', 'width': '28px', 'top': '100%', 'margin-top': '-134px', 'cursor': 'pointer','z-index': '0'});
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
                rightpo = rightpo+30;
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
            var playerstatus=function(){
            if(palyerType == 'html'){
                $hdflv_player.bind('play', function(){
                   $hdflv_player[0].volume = volume_level/volume_deault;
                   $('.hdflv-play-pause').css({'background-position': '0px -36px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                });
                $hdflv_player.bind('pause', function(){
                    $('.hdflv-play-pause').css({'background-position': '-1px -5px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                    $('.hdflv-video-play-button').show();
                });
                $hdflv_player.bind('ended', function(){
                    $('.hdflv-play-pause').css({'background-position': '-1px -5px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                    $('.hdflv-video-play-button').show();
                });
                totalWidth = $('.hdlflv-skin-progress-bg').width();
                $hdflv_player.on("timeupdate",function(event){
                    currentTime = this.currentTime;
                    duration = this.duration;
                    onTrackedVideoFrame(this.currentTime, this.duration);
                });
                }else{
                     var myVar2 = setInterval(function(){onTrackedVideoFrame2();},1);
                }
            }
             var playpausevideo = function() {
                 $('#posterimage').remove();
                 if(palyerType == 'flash'){
                     if(playing == false){
                        playing = true;
                        $('.hdflv-video-play-button').hide();
                        $('.hdflv-play-pause').css({'background-position': '0px -36px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                     }else{
                        playing = false;
                        $('.hdflv-video-play-button').show();
                        $('.hdflv-play-pause').css({'background-position': '-1px -5px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                     }
                     $('#hflvplayerflash').externalInterface({method:'playfun'});
                 }else{
                    if($hdflv_player[0].paused == false) {
                        $hdflv_player[0].pause();
                        $('.hdflv-video-play-button').show();
                    } else {
                        $hdflv_player[0].play();
                        $('.hdflv-video-play-button').hide();
                    } 
                 }
                 playerstatus()
             }
            if(hflv_option.autoplay == 'true')
            {
                playpausevideo()
            }else{
                $('.hdflv-video-player').prepend('<img id="posterimage" src="'+hflv_option.poster+'" width="'+hflv_option.width+'" height="'+hflv_option.height+'"/>')
                $('#posterimage').css({'float': 'left', 'position':'absolute','cursor': 'pointer'});
            }
            
            $('.hdflv-video-play-button,.hdflv-play-pause,.hdflvplayer,#posterimage,#hflvplayerflash').click(playpausevideo);
            $(".playersource").error(function (e) {
                palyerType = 'flash';
                $(".hdflvplayer").remove()
                $('.hdflv-video-player').prepend('<div class="hdflvFLASH" id="hdflvFLASH"></div>')
                $('#hdflvFLASH').css({'float': 'right'});
                initFlash();
            });
            function onTrackedVideoFrame2(){
                $('#hflvplayerflash').externalInterface({method:'getCurrentTime',success: function(response){currentTime= response;}});
                $('#hflvplayerflash').externalInterface({method:'getDuration',success: function(response){duration= response;}});
                $('#hflvplayerflash').externalInterface({method:'getbytesLoaded',success: function(response){totalBytes= response;}});
                $('#hflvplayerflash').externalInterface({method:'getbytesTotal',success: function(response){bytesLoaded= response;}});
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
                        if(!isNaN($hdflv_player.get(0).duration)){
                            $('.hdlflv-skin-buffer').width(($hdflv_player.get(0).buffered.end(0) / $hdflv_player.get(0).duration)*totalWidth);
                        }
                    }else if(!isNaN(totalBytes) && $('.hdlflv-skin-buffer').width()<=totalWidth && bytesLoaded !=0 && totalBytes !=0){
                        $('.hdlflv-skin-buffer').width(bytesLoaded * totalWidth / totalBytes);
                    }else{
                            $('.hdlflv-skin-buffer').width(totalWidth);
                        }
                }
            }          
            var gTimeFormat=function(seconds){
                var m=Math.floor(seconds/60)<10?"0"+Math.floor(seconds/60):Math.floor(seconds/60);
                var s=Math.floor(seconds-(m*60))<10?"0"+Math.floor(seconds-(m*60)):Math.floor(seconds-(m*60));
                return m+":"+s;
            };
            $('.hdlflv-skin-progress-bg,.hdlflv-skin-buffer,.hdlflv-skin-seek').mousedown(function(e){
                drg = false;
                parentOffset = $('.hdlflv-skin-seek,.hdlflv-skin-progress-bg,.hdlflv-skin-buffer').offset(); 
                relX = e.pageX - parentOffset.left;
                relY = e.pageY - parentOffset.top;
                seekto = relX * (duration / totalWidth);
                if(palyerType == 'html'){
                    $hdflv_player[0].currentTime = seekto;
                }else{
                    $('#hflvplayerflash').externalInterface({method:'seekVideo',args:seekto});
                }
                $('.hdlflv-skin-seek').width(relX);
                $(window).on('mousemove',function(et){
                    relX = et.pageX - parentOffset.left;
                    relY = et.pageY - parentOffset.top;
                    seekto = relX * (duration / totalWidth);
                     if(palyerType == 'html'){
                        $hdflv_player[0].currentTime = seekto;
                     }else{
                         $('#hflvplayerflash').externalInterface({method:'seekVideo',args:seekto});
                     }
                    if(relX<totalWidth){
                        $('.hdlflv-skin-seek').width(relX);
                    }else{
                        $('.hdlflv-skin-seek').width(totalWidth);
                    }
                });
            });
            var fullscreeEvent=function(){
                    if ($video_container[0].requestFullscreen) {
                       $video_container[0].requestFullscreen();
                    }else if ($video_container[0].msRequestFullscreen) {
                       $video_container[0].msRequestFullscreen();
                    }else if ($video_container[0].mozRequestFullScreen) {
                       $video_container[0].mozRequestFullScreen();
                    }else if ($video_container[0].webkitRequestFullscreen) {
                       $video_container[0].webkitRequestFullscreen();
                    }
                    $('#hflvplayerflash').attr({'width': $(document).width(),'height': $(window).height()-30});
                    $('.hdflvplayer').css({'position': 'absolute','width': '100%','height': '100%'});
                    $('.hdflv-video-player').css({'width': '100%','height': '100%','top': '0','left': '0'});
                    $('.hdlflv-skin-progress-bg').css({'position': 'absolute','width': ($(window).width()-(rightpo+15))+'px','height': '10px'});
            };
            var exitfullscreeEvent=function(){
                    $('#hflvplayerflash').attr({'width': hflv_option.width,'height': hflv_option.height});
                    $('.hdflv-video-player').css({'position': 'absolute','width': hflv_option.width+'px','height': hflv_option.height+'px'});
                    $('.hdflvplayer').css({'width': hflv_option.width+'px','height': hflv_option.height+'px'});
                    $('.hdlflv-skin-progress-bg').css({'position': 'absolute','width': (hflv_option.width-(rightpo+15))+'px','height': '10px'});
                    if (document.cancelFullScreen) {
                        document.cancelFullScreen();
                    } else if (document.mozCancelFullScreen) {
                        document.mozCancelFullScreen();
                    } else if (document.webkitCancelFullScreen) {
                        document.webkitCancelFullScreen();
                    }
            };
            $('.hdflv-fullscreen').click(function(){
                var $that = $(this);
                if(palyerType == 'flash'){
                    $('#hflvplayerflash').externalInterface({method:'fullScreenFun'});
                }
                if(!$that.hasClass('isFullScreenMode')){
                    fullscreeEvent();
                    $that.addClass('isFullScreenMode');
                    $('.hdflv-fullscreen').css({'background-position': '-115px -38px'});
                }else{
                    jQuery.event.trigger({ type : 'keyup', which : 27 });
                    $that.removeClass('isFullScreenMode');
                    exitfullscreeEvent()
                    $('.hdflv-fullscreen').css({'background-position': '-115px -3px'});
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
                parentOffset = $('.hdlflv-volume-progress-bg,.hdlflv-volume-progress').offset(); 
                relX = e.pageX - parentOffset.left;
                relY = e.pageY - parentOffset.top;
                seekto = volume_deault-relY;
                if(seekto>volume_deault){seekto = volume_deault;}
                else if(seekto<0){seekto = 0;}
                if(palyerType == 'html'){
                    $hdflv_player[0].volume = seekto/volume_deault;
                }else{
                    $('#hflvplayerflash').externalInterface({method:'setVolume',args:seekto/volume_deault});
                }
                $('.hdlflv-volume-progress').height(seekto);
                $(window).on('mousemove',function(et){
                    relX = et.pageX - parentOffset.left;
                    relY = et.pageY - parentOffset.top;
                    seekto = volume_deault-relY;
                    if(seekto>volume_deault){seekto = volume_deault;}
                    else if(seekto<0){seekto = 0;}
                    if(palyerType == 'html'){
                        $hdflv_player[0].volume = seekto/volume_deault;
                    }else{
                        $('#hflvplayerflash').externalInterface({method:'setVolume',args:seekto/volume_deault});
                    }
                    $('.hdlflv-volume-progress').height(seekto);
                    if(seekto/volume_deault>=0.5){
                    $('.hdflv-volume').css({'background-position': '-240px -4px'});
                    }else{
                         if(seekto/volume_deault<=0){$('.hdflv-volume').css({'background-position': '-239px -123px'});}
                         else {$('.hdflv-volume').css({'background-position': '-239px -94px'});}
                    }
                    volume_level = (seekto/volume_deault) *100;
                });
            });
            $('.hdlflv-mute').mousedown(function(e){
                if(!$(this).hasClass('hdflv-muted')){
                        $(this).addClass('hdflv-muted');
                        $('.hdflv-volume').css({'background-position': '-239px -123px'});
                        $hdflv_player[0].volume = 0;
                        $('.hdlflv-volume-progress').height(0);
                    }else{
                        $(this).removeClass('hdflv-muted');
                        $('.hdflv-volume').css({'background-position': '-240px -4px'});
                        $hdflv_player[0].volume = volume_level/volume_deault;
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
            $('.hdflv-video-player').hover(function(e){
               $(".hdlfv-skin-container").fadeIn(600);
               skinOver = true;
               $('.hdflv-video-player').on('mouseout',function(et){
                   setTimeout(function () {if(skinOver == false){$(".hdlfv-skin-container").fadeOut(500);}}, 500);
                   skinOver = false;
               });
               $('.hdflv-video-player,.hdflvplayer').on('mousemove',function(et){
                   $('.hdflv-video-player').stop("mouseout");
                   skinOver = true;
               });
            });
            $(document).on('mouseup', function(evt) {
                    $(window).unbind("mousemove");
                    drg = true;
            });
            
        });
    };
});
