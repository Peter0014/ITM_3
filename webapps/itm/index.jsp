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
    <title>ITM 3 2016</title>
    
	<script type="text/javascript" src="js/raphael.js"></script>
	<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
    <script type="text/javascript" src="js/dracula_graffle.js"></script>
    <script type="text/javascript" src="js/dracula_graph.js"></script>
    
    <!-- Bootstrap Player - see https://github.com/iainhouston/bootstrap3_player -->
	<link href="css/bootstrap3_player.css" rel="stylesheet">
    <script type="text/javascript" src="./js/bootstrap3_player.js"></script>
    
    <!-- Bootstrap -->
	<link href="css/bootstrap.css" rel="stylesheet">
	<script type="text/javascript" src="./js/bootstrap.js"></script>

	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
		  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
		<![endif]-->
</head>
<body>

<h1>Welcome to the ITM media library</h1>
        <a href="graph.jsp">graph</a>
         
<div class="container">
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
            // iterate over all available media objects
            for ( AbstractMedia medium : media ) {
				
				if ( c % 3 == 0 ) {
                %>
                    <div class="row">
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
                    <div class="img-thumbnail well" style="width:230px; height:180px;">
                        <a href="media/img/<%= img.getInstance().getName()%>">
                        <img class="img-rounded" src="media/md/<%= img.getInstance().getName() %>.thumb.png" border="0"/>
                        </a>
                    </div>
                    <div class="text-center well">
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
                        <embed src="media/md/<%= audio.getInstance().getName() %>.wav" autostart="false" width="200" height="30" />
                        <br/>
                        <a class="media-object" href="media/audio/<%= audio.getInstance().getName()%>">
                            Download <%= audio.getInstance().getName()%>
                        </a>
                    </div>
                    <div>
                    <div class="text-center well">
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
                            <embed src="media/md/<%= video.getInstance().getName() %>_thumb.avi" width="200" height="200">
                            </embed>
                        </object>

                        </a>
                    </div>
                    <div class="text-center well">
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
        
</body>
</html>