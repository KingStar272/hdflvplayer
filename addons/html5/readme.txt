Step1:Copy the below code and paste it your webpage



<div name='mediaspace' id='mediaspace'>
</div>
<script type="text/javascript">

var s1 = new SWFObject('hdflvplayer/hdplayer.swf', 'player', '640', '360', '9');
s1.addParam('allowfullscreen', 'true'); 
s1.addParam('allowscriptaccess', 'always');
s1.addParam('wmode', 'transparent'); 
s1.write('mediaspace');
</script>

  <div id="htmlplayer">
        <video id="video" src="videosrc" poster="previewpath" width="640" height="360" autobuffer controls onerror="failed(event)">
         Html5 Not support This video Format.
        </video>
</div>
         <script>
           var txt =  navigator.platform ;

            if(txt =='iPod'|| txt =='iPad'|| txt =='iPhone' || txt =='Linux armv7I')
            {
			
                document.getElementById("htmlplayer").style.display = "block";
                document.getElementById("mediaspace").style.display = "none";


            }
           else
            {
                 document.getElementById("htmlplayer").style.display = "none";

            }
   function failed(e)
                   {
	      if(txt =='iPod'|| txt =='iPad'|| txt =='iPhone' || txt =='Linux armv7I')
                       {
                           alert('Player doesnot support this video.');
                       }
                  }
        </script>


Step2 : Just change the text  “videosrc” to video path, “previewpath” to preview image path
