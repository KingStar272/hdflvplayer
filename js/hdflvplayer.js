jQuery(document).ready(function($) {
    $.fn.hdflv = function(hflv_option) 
    {
        return this.each(function() 
        {
            var $hdflv = $(this);
            var palyerType,currentTime,duration,totalWidth=0,drg=true,myVar,parentOffset,relX,relY,seekto,speedOver=true,skinOver=true,over=true,playing=false,player,totalBytes,bytesLoaded,myVar2,src_error=false,speedBg=false,playbackrate = 1;
            var $video_wrap = $('<div></div>').addClass('hdflv-video-player');
            palyerType = 'html';
            hflv_option.videotag = '<video width="'+hflv_option.width+'" height="'+hflv_option.height+'" class="hdflvplayer"  style="cursor: pointer">\n\
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
                                              </div>\n\
                                        </span>\n\
                                        <span class="hdflv-duration">/ 00:00</span>\n\
                                        <span class="hdflv-currentTime">00:00</span>\n\
                                        <span class="hdlflv-skin-progress-bg"></span>\n\
                                        <span class="hdlflv-skin-buffer"></span>\n\
                                        <span class="hdlflv-skin-seek"></span>\n\
                                    </div>\n\
                                    <canvas id="imageView" style="display:none; left: 0; top: 0; z-index: 0;border:none" width="100" height="50"></canvas>\n\
                                    <div id="imgs"><div>');
            $hdflv.wrap($video_wrap);
	    $hdflv.after($hdflv_player);  
            $('.hdflv-video-player').css({'top': '0','left': '0'});
            function initFlash()
            {
                src_error = true
                palyerType = 'flash';
                $(".hdflvplayer").remove()
                $('.hdflv-video-player').prepend('<div class="hdflvFLASH" id="hdflvFLASH"></div>')
                $('#hdflvFLASH').css({'float': 'right'});
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
                $('.hdflv-volume-bg').css({'background': 'url(./skin/volumbg.png) no-repeat','display': 'none','position': 'absolute', 'height': '103px', 'width': '28px', 'top': '100%', 'margin-top': '-134px','z-index': '0'});
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
                $('.setting_bg').css({'display':'none','position': 'absolute','width': '120px','height': '24px', 'bottom': '32px', 'left': '-88px','background': 'rgb(54, 49, 49)','opacity': '1', 'border': '1px solid rgb(27, 27, 27)'});
                $('.speed_button').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute','width': '70px','height': '20px', 'bottom': '1px', 'left': '47px','display': 'block','background': 'rgb(255, 255, 255)','opacity': '1', 'border': '1px solid rgb(27, 27, 27)'});
                $('.speed_bg').css({'position': 'absolute','width': '70px','height': '102px', 'bottom': '22px', 'left': '-1px', 'display': 'none','background': 'rgb(255, 255, 255)','opacity': '1', 'border': '1px solid rgb(27, 27, 27)'});
                $('.speed_text').css({'font-family': 'arial', 'font-size': '12px', 'color': '#fff', 'position': 'absolute', 'top': '3px', 'left': '4px'});
                $('.current_speed').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '2px', 'left': '4px'});
                $('.speed_downn_arraow').css({'position': 'absolute','left':'54px','bottom':'7px','width': '0px', 'height': '0px','border-left': '5px solid transparent','border-right': '5px solid transparent','border-bottom': '5px solid black'});
                $('.2xSp').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '4px', 'left': '20px'});
                $('.1_5xSp').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '24px', 'left': '20px'});
                $('.normalSp').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '44px', 'left': '20px'});
                $('.0_5xSp').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '64px', 'left': '20px'});
                $('.0_25xSp').css({'font-family': 'arial', 'font-size': '12px', 'color': '#000', 'position': 'absolute', 'top': '84px', 'left': '20px'});
                $('.speed_select').css({'font-family': 'arial', 'font-size': '44px', 'color': '#000', 'position': 'absolute', 'top': '14px', 'left': '2px'});
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
                   $('.hdflv-video-play-button').hide();
                   $('.hdflv-play-pause').css({'background-position': '0px -36px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                });
                $hdflv_player.bind('pause', function(){
                    $('.hdflv-play-pause').css({'background-position': '-1px -5px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                    $('.hdflv-video-play-button').show();
                });
                $hdflv_player.bind('ended', function(){
                    $('#posterimage').show();
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
                     myVar2 = setInterval(function(){onTrackedVideoFrame2();},1);
                }
                $hdflv_player.bind('volumechange',function() {
                    if($("video").prop('muted')){
                        $(this).addClass('hdflv-muted');
                        $('.hdflv-volume').css({'background-position': '-239px -123px'});
                        $hdflv_player[0].volume = 0;
                        $('.hdlflv-volume-progress').height(0);
                    }else if($(this).hasClass('hdflv-muted')){
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
            };
             var errorMessage = function(msg) {
                $('.hdflv-video-play-button').hide();
                $('.error_message').text( msg );
             };
            var playpausevideo = function() {
                 $('#posterimage').hide();
                 var n=hflv_option.file.indexOf(".avi");
                 if(n>-1){
                     $('.error_board').show();
                     errorMessage('AVI is not supported by Flash or HTML5')
                 }else if(palyerType == 'flash'){
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
                     playerstatus();
                 }else{
                    if($hdflv_player[0].paused == false) {
                        $hdflv_player[0].pause();
                        $('.hdflv-video-play-button').show();
                    } else {
                        $hdflv_player[0].play();
                        $('.hdflv-video-play-button').hide();
                    } 
                    playerstatus();
                 }
                 
             };
             $('.hdflv-video-player').prepend('<div class="error_board" id="error_board">\n\
                                                       <span class="error_message"></span>\n\
                                                  </div>')
             $('.error_board').css({'position': 'absolute','width': '310px','height': '50px', 'top': '50%', 'margin-top': '-20px', 'left': '50%', 'margin-left': '-155px', 'display': 'none','background': 'rgb(255, 255, 255)','opacity': '1', 'border': '1px solid rgb(27, 27, 27)'});
             $('.error_message').css({'font-family': 'arial', 'font-size': '16px', 'color': '#000', 'position': 'absolute', 'top': '17px', 'left': '13px'});
            if(hflv_option.autoplay == 'true'){
                playpausevideo();
            }else{
                $('.hdflv-video-player').prepend('<img id="posterimage" src="'+hflv_option.poster+'" width="'+hflv_option.width+'" height="'+hflv_option.height+'"/>');
                $('#posterimage').css({'float': 'left', 'position':'absolute','cursor': 'pointer'});
            }
            
            $('.hdflv-video-play-button,.hdflv-play-pause,.hdflvplayer,#posterimage,#hflvplayerflash').click(playpausevideo);
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
            $hdflv_player.bind('error',function(e,ui) {
                if(src_error == false){
                    initFlash();
                }
            });
            function onTrackedVideoFrame2(){
                $('#hflvplayerflash').externalInterface({method:'getCurrentTime',success: function(response){currentTime= response;}});
                $('#hflvplayerflash').externalInterface({method:'getDuration',success: function(response){duration= response;}});
                $('#hflvplayerflash').externalInterface({method:'getbytesLoaded',success: function(response){totalBytes= response;}});
                $('#hflvplayerflash').externalInterface({method:'getbytesTotal',success: function(response){bytesLoaded= response;}});
                $('#hflvplayerflash').externalInterface({method:'getplayerstate',success: function(response){
                        if(response == 'false'){
                          $('.hdflv-play-pause').css({'background-position': '-1px -5px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                          $('.hdflv-video-play-button').show();  
                        }else if(response == 'true'){
                          $('.hdflv-video-play-button').hide();
                          $('.hdflv-play-pause').css({'background-position': '0px -36px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});  
                        }else if(response == 'initial'){
                          clearInterval(myVar2)
                          $('#posterimage').show();
                          $('.hdflv-play-pause').css({'background-position': '-1px -5px','position': 'absolute', 'height': '30px', 'width': '30px', 'top': '100%', 'margin-top': '-30px', 'cursor': 'pointer'});
                          $('.hdflv-video-play-button').show();  
                        }}});
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
                    $('.hdlflv-skin-buffer').width(0)
                    if(palyerType == 'html'){
                        if(!isNaN($hdflv_player.get(0).duration)){
                            $('.hdlflv-skin-buffer').width(($hdflv_player.get(0).buffered.end(0) / $hdflv_player.get(0).duration)*totalWidth);
                        }
                    }else if(!isNaN(totalBytes) && $('.hdlflv-skin-buffer').width()<=totalWidth && bytesLoaded >2 && totalBytes >2){
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
                $(document).on('mousemove',function(et){
                    parentOffset = $('.hdlflv-skin-seek,.hdlflv-skin-progress-bg,.hdlflv-skin-buffer').offset(); 
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
                //capture();
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
                    $('#posterimage').css({'width': $(document).width(),'height': $(window).height()});
                    $('#hflvplayerflash').attr({'width': $(document).width(),'height': $(window).height()});
                    $('.hdflvplayer').css({'position': 'absolute','width': '100%','height': '100%'});
                    $('.hdflv-video-player').css({'width': '100%','height': '100%','top': '0','left': '0'});
                    $('.hdlflv-skin-progress-bg').css({'position': 'absolute','width': ($(window).width()-(rightpo+15))+'px','height': '10px'});
            };
            var exitfullscreeEvent=function(){
                    $('#posterimage').css({'width': hflv_option.width,'height': hflv_option.height});
                    $('.hdlflv-skin-seek').css({'position': 'absolute','width':0+'px','height': '8px','bottom': '10.5px', 'left': '33px', '-moz-border-radius': '10px', '-ms-border-radius': '10px', '-webkit-border-radius': '10px', 'border-radius':'10px', 'display': 'block','background': 'rgb(255, 253, 253)', 'background-image': '-webkit-gradient(linear, 0% 0%, 0% 100%, from(rgb(255, 252, 252)), to(rgb(255, 255, 255)))', 'box-shadow': 'rgb(216, 216, 216) 0px 1px 2px inset', 'cursor': 'pointer'});
                    $('.hdlflv-skin-buffer').css({'position': 'absolute','width': 0+'px','height': '8px','bottom': '10px', 'left': '33px', '-moz-border-radius': '10px', '-ms-border-radius': '10px', '-webkit-border-radius': '10px', 'border-radius':'10px', 'display': 'block','background': 'rgb(138, 135, 135)', 'background-image': '-webkit-gradient(linear, 0% 0%, 0% 100%, from(rgb(179, 179, 179)), to(rgb(61, 59, 59)))', 'box-shadow': 'rgb(134, 133, 133) 0px 1px 2px inset', 'cursor': 'pointer'});
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
                    exitfullscreeEvent();
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
                e.preventDefault();
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
                if(drg == true){
                    $('.hdlflv-volume-progress').height(seekto);
                }
                $(document).on('mousemove',function(et){
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
                    if(drg == true){
                        $('.hdlflv-volume-progress').height(seekto);
                    }
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
               $(".setting_bg").fadeOut();
               speedBg = false;
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
                    $(document).unbind("mousemove");
                    drg = true;
            });
            $('.hdlfv-skin-container').on('mousedown', function(evt) {
                  evt.preventDefault();
            });
            $(document).bind("contextmenu",function(e){
                   /// return false;
            });
            $(document).on("mousedown", function (e) {
                $('.contextmenu').remove();
            });
            $('.hdflv-video-player').bind("contextmenu", function(event) {
                event.preventDefault();
                $('.contextmenu').remove();
                $("<div class='contextmenu'><ul><li class='copyright'>HD FLV Player</li></ul></div>").appendTo("body").css({top: event.pageY + "px", left: event.pageX + "px",'z-index':'1000', 'position': 'absolute', 'background-color':'#FFFFFF' ,'border': '1px solid black','width': '150px'});
            });
            var getURIformcanvas=function() {
                var ImageURItoShow = "";
                var canvasFromVideo = document.getElementById("imageView");
                if (canvasFromVideo.getContext) {
                    var ctx = canvasFromVideo.getContext("2d"); // Get the context for the canvas.canvasFromVideo.
                    var ImageURItoShow = canvasFromVideo.toDataURL("image/png");
                }
                var imgs = document.getElementById("imgs");
                imgs.appendChild(Canvas2Image.convertToImage(canvasFromVideo,100, 50, 'png'));
            };
            var capture=function(){
                var video = $('.hdflvplayer');
                var canvasDraw = document.getElementById('imageView');
                var w = canvasDraw.width;
                var h = canvasDraw.height;
                var ctxDraw = canvasDraw.getContext('2d');
                ctxDraw.clearRect(0, 0, w, h);
                ctxDraw.drawImage($hdflv_player[0], 0, 0, w, h);
                ctxDraw.save();
                getURIformcanvas();
            };
            $('.hdflv-hd-swipe,.setting_bg').hover(function(e){
               $('.setting_bg').fadeIn(500);
               $(".hdflv-volume-bg").fadeOut();
               $('.setting_bg,.hdflv-hd-swipe').on('mouseout',function(et){
                   setTimeout(function () {if(speedOver == false){
                           $(".setting_bg").fadeOut();
                           $('.speed_bg').fadeOut();
                           speedBg = false;
                       }}, 1000);
                   speedOver = false;
               });
               $('.setting_bg').on('mousemove',function(et){
                   $('.setting_bg').stop("mouseout");
                   speedOver = true;
               });
            });
            $('.speed_button').on('mousedown',function(){
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
                $hdflv_player[0].playbackRate = playbackrate;
            });
        });
    };
});
