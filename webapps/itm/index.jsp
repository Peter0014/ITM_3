<!DOCTYPE html>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="itm.image.*" %>
<%@ page import="itm.model.*" %>
<%@ page import="itm.util.*" %>
<!--
/*******************************************************************************
 This file is part of the WM.II.ITM course 2016
 (c) University of Vienna 2009-2016
 *******************************************************************************/
-->
<html lang="en">
<head>
    <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ITM 3 2016 - Home</title>
    
	<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
	<script type="text/javascript" src="js/raphael.js"></script>
	<script type="text/javascript" src="js/dracula_graffle.js"></script>
    <script type="text/javascript" src="js/dracula_graph.js"></script>
    
    <!-- Font Awesome -->
    <link href="css/font-awesome.min.css" rel="stylesheet">
    
    <!-- Bootstrap -->
    <link href="css/bootstrap.css" rel="stylesheet">
	<script type="text/javascript" src="./js/bootstrap.js"></script>
</head>
<body>

<nav class="navbar navbar-default navbar-fixed-top">
  <div  style="background-image: url('img/itm_logo_bg_1.png'); background-repeat:repeat; background-position: center; background-size:contain;">
	      

	      <h3 style="text-align:center; overflow:hidden; padding: 20px; margin: 0px; padding-left: 8%;"> 
		      Welcome to the ITM media library

		      <a class="btn-default btn-sm" href="graph.jsp"  style=" float: right; margin-right: 1%;">
			      	<i class="fa fa-share-alt" aria-hidden="true"></i> Graph
		      </a>
	      </h3> 
  </div>
</nav>

<div class="main">
            <%
                // get the file paths - this is NOT good style (resources should be loaded via inputstreams...)
                // we use it here for the sake of simplicity.
                String basePath = getServletConfig().getServletContext().getRealPath( "media" );
                if ( basePath == null )
                    throw new NullPointerException( "could not determine base path of media directory! please set manually in JSP file!" );
                File base = new File( basePath );
                File imageDir = new File( basePath, "img");
                File audioDir = new File( basePath, "audio");
                File videoDir = new File( basePath, "video");
                File metadataDir = new File( basePath, "md");
                MediaFactory.init( imageDir, audioDir, videoDir, metadataDir );
                
                // get all media objects
                ArrayList<AbstractMedia> media = MediaFactory.getMedia();
                
                int c=0; // counter for rowbreak after 3 thumbnails.
                boolean firstAudio = true, firstVideo = true, firstImage = true;
                // iterate over all available media objects
                for ( AbstractMedia medium : media ) {
                    
                    if (firstImage) {
                        firstImage = false;
                        %>
                        <div class="bg-image">
    					<div class="container">
        					<div class="row">
                            <div class="page-header">
                            	<h1 class="h1 text-center">Images</h1>
                            </div>
                        <%
                    } else if ( medium instanceof AudioMedia ) {
                        if (firstAudio) {
                            c = 0;
                            firstAudio = false;
                        %>
                        </div>
                        </div>
                        </div>
                        </div>
                        <div class="bg-audio">
                        <div class="container">
                            <div class="row">
                            <div class="page-header">
                                <h1 class="h1 text-center">Audio</h1>
                            </div>
                        <%
                        }
                    } else if ( medium instanceof VideoMedia ) {
                        if (firstVideo) {
                            firstVideo = false;
                            c = 0;
                        %>
                        </div>
                        </div>
                        </div>
                        </div>
                        <div class="bg-video">
                        <div class="container">
                            <div class="row">
                            <div class="page-header">
                            	<h1 class="h1 text-center">Video</h1>
                            </div>
                        <%
                        }
                    }
                    
                    if ( c % 3 == 0 ) {
                    %>
                        <div class="col-xs-12">
                    <%
                    }
                    
                    c++;
                    %>
                        <div class="col-md-4 text-center">
                    <%
                
                    // handle images
                    if ( medium instanceof ImageMedia ) {
                         // ***************************************************************
                        //  Fill in your code here!
                        // ***************************************************************
                        
                        // show the histogram of the image on mouse-over
                        
                        // display image thumbnail and metadata
                        ImageMedia img = (ImageMedia) medium;
                        %>
                        <div class="img-thumbnail well" style="width:245px; height:195px;">
                            <a href="media/img/<%= img.getInstance().getName()%>">
                            <img style="width:100%;" class="img-rounded" onmouseover="getHist('<%= img.getInstance().getName() %>', this)" name="<%= img.getInstance().getName() %>" onmouseout="getPic('<%= img.getInstance().getName() %>', this)" src="media/md/<%= img.getInstance().getName() %>.thumb.png" border="0"/>
                            </a>
                        </div>
                        <button type="button" onclick="$('#<%= img.getName().replaceAll("\\[|\\]|\\.", "_") %>').toggle();" class="btn btn-default" data-toggle="collapse"><i class="fa fa-info-circle" aria-hidden="true"></i> Show Metadata</button>
                        <div id="<%= img.getName().replaceAll("\\[|\\]|\\.", "_") %>" class="text-center well collapse">
                            Name: <%= img.getName() %><br/>
                            Dimensions: <%= img.getWidth() %>x<%= img.getHeight() %>px<br/>
                            Size: <%= img.getSize() %> bytes<br/>
                            Pixelsize: <%= img.getPixelSize() %> <br/>
                            Number of Image Components: <%= img.getNumOfImgComp() %> <br/>
                            Number of Image Color Components: <%= img.getNumOfImgColComp() %> <br/>
                            Transparency: <%= img.getTransparency() %> <br/>
                            Oriantation: <%= img.getOriantation() %> <br/>
                            Tags: <% for ( String t : img.getTags() ) { %><a href="tags.jsp?tag=<%= t %>"><%= t %></a> <% } %><br/>
                        </div>
                        <%  
                        } else 
                    if ( medium instanceof AudioMedia ) {
                        // display audio thumbnail and metadata
                        AudioMedia audio = (AudioMedia) medium;
                        %>
                        
                        
                        <div class="media center-block well" style="width:230px; height:180px;">
                            <br/><br/>
                            <embed src="media/md/<%= audio.getInstance().getName() %>.wav" autostart="false" width="100%" height="30px" />
                            <br/>
                            <a class="media-object" href="media/audio/<%= audio.getInstance().getName()%>">
                                Download <%= audio.getInstance().getName()%>
                            </a>
                        </div>
                        <button onclick="$('#<%= audio.getName().replaceAll("\\[|\\]|\\.", "_") %>').toggle();" class="btn btn-default" data-toggle="collapse"><i class="fa fa-info-circle" aria-hidden="true"></i> Show Metadata</button>
                        <div id="<%= audio.getName().replaceAll("\\[|\\]|\\.", "_") %>" class="text-center well collapse">
                            Name: <%= audio.getName() %><br/>
                            title: <%= audio.getTitle() %> <br/>
                            Duration: <%= audio.getDuration() %><br/>
                            Size: <%= audio.getSize() %> bytes <br/>
                            Album: <%= audio.getAlbum() %> <br/>
                            Author: <%= audio.getAuthor() %> <br/>
                            date: <%= audio.getDate() %> <br/>
                            composer: <%= audio.getComposer() %> <br/>
                            genre: <%= audio.getGenre() %> <br/>
                            comment: <%= audio.getComment() %> <br/>
                            track: <%= audio.getTrack() %> <br/>
                            bitrate: <%= audio.getBitrate() %> <br/>
                            channels: <%= audio.getChannels() %> <br/>
                            encoding: <%= audio.getEncoding() %> <br/>
                            frequency: <%= audio.getFrequency() %> <br/>
                            Tags: <% for ( String t : audio.getTags() ) { %><a href="tags.jsp?tag=<%= t %>"><%= t %></a> <% } %><br/>
                        </div>
                        <%  
                        } else
                    if ( medium instanceof VideoMedia ) {
                        // handle videos thumbnail and metadata...
                        VideoMedia video = (VideoMedia) medium;
                        %>
                        <div class="media center-block well" style="width:240px; height:240px;">
                            <a href="media/video/<%= video.getInstance().getName()%>">
                                
                            <object class="media-object" width="200" height="200">
                                <param name="movie" value="media/md/<%= video.getInstance().getName() %>_thumb.avi">
                                <embed src="media/md/<%= video.getInstance().getName() %>_thumb.avi" width="100%">
                                </embed>
                            </object>
    
                            </a>
                        </div>
                        <button onclick="$('#<%= video.getName().replaceAll("\\[|\\]|\\.", "_") %>').toggle();" class="btn btn-default" data-toggle="collapse"><i class="fa fa-info-circle" aria-hidden="true"></i> Show Metadata</button>
                        <div id="<%= video.getName().replaceAll("\\[|\\]|\\.", "_") %>" class="text-center well collapse">
                            Name: <a href="media/video/<%= video.getInstance().getName()%>"><%= video.getName() %></a><br/>
                            Size: <%= video.getSize() %> bytes <br/>
                            Dimensions: <%= video.getVideoWidth() %>x<%= video.getVideoHeight() %>px<br/>
                            Video Length: <%= video.getVideoLength() %> sec <br/>
                            Video Framerate: <%= (int) (video.getVideoFrameRate() + 0.5) %> <br/>
                            Audio Bitrate: <%= video.getAudioBitRate() %> <br/>
                            Audio Channels: <%= video.getAudioChannels() %> <br/>
                            Audio Codec: <%= video.getAudioCodec() %> <br/>
                            Audio CodecID: <%= video.getAudioCodecID() %> <br/>
                            Audio Samplerate: <%= video.getAudioSampleRate() %> <br/>
                            Video Codec: <%= video.getVideoCodec() %> <br/>
                            Video CodecID: <%= video.getVideoCodecID() %> <br/>
                            Tags: <% for ( String t : video.getTags() ) { %><a href="tags.jsp?tag=<%= t %>"><%= t %></a> <% } %><br/>
                        </div>
                        <%  
                        } else {
                            }
    
                    %>
                    </div>
                    <%
                    
                    if ( c % 3 == 0 ) {
                    %>
                        </div>
                    <%
                    }
    
                } // for 
                    
            %>
    </div>
</div>
</body>
<script>

    function getPic(fileName, img) {
        var rendImg = document.getElementsByName(fileName)[0];
        img.src="media/md/"+fileName+".thumb.png";
    }
    
        function getHist(fileName, img) {
            var rendImg = document.getElementsByName(fileName)[0];
            img.src="media/md/"+fileName+".hist.png";
            img.style.height = rendImg.clientHeight;
            img.style.width = rendImg.clientWidth;
        }
</script>
</html>