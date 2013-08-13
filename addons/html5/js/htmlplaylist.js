jQuery(document).ready(function() {
                jQuery('#mycarousel').jcarousel({
                    vertical: true,
                    scroll: 3
                });
            });

            jQuery(document).ready(function(){
                jQuery("#play_list_open").click(function(){
                    video = document.getElementById("video");                   
                    videoOrig = video.offsetWidth;
                    video.style.width = videoOrig + "px";                  
                    jQuery("#playlist").animate({width:'toggle'},200,function(){
                    });
                    return false;
                });

                jQuery("#play_list_close").click(function(){
                    video_box = document.getElementById("video_box");                  
                    videoOrig = video_box.offsetWidth;
                    video.style.width = videoOrig + "px";
                    videoBox = document.getElementById("video_box");
                    videoBox.style.width = videoOrig + "px";
                    controls = document.getElementById("controls");
                    controls.style.width = videoOrig + "px";
                    sizeProgressBar();                                     
                    jQuery("#playlist").animate({width:'toggle'},200,function(){
                    });
                    return false;
                });
            });