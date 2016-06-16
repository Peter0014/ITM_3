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
<%
       
%>
<html>
    <head>
    </head>
    <body>

        <%
        
            String tag = null;

            // ***************************************************************
            //  Fill in your code here!
            // ***************************************************************

            // get "tag" parameter   
            
            // if no param was passed, forward to index.jsp (using jsp:forward)
            
            tag = request.getParameter("tag");
            
            if (tag == null || tag.equals(""))
            	response.sendRedirect("index.jsp");

        %>

        <h1>Media that is tagged with <%= tag %></h1>
        <a href="index.jsp">back</a><br/>

        <%

            // ***************************************************************
            //  Fill in your code here!
            // ***************************************************************
        
            // get all media objects that are tagged with the passed tag
            
            // iterate over all available media objects and display them
                
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
            	
            	// handle images
                if ( medium instanceof ImageMedia ) {
                	 // ***************************************************************
                    //  Fill in your code here!
                    // ***************************************************************
                    
                    // show the histogram of the image on mouse-over
                    
                    // display image thumbnail and metadata
                    ImageMedia img = (ImageMedia) medium;
                	boolean matchedTag = false;
                	 
                    for ( String t : img.getTags() )
                    	if (t.toLowerCase().equals(tag.toLowerCase()))
                    		matchedTag = true;
                    
                    if (matchedTag) {
                    	c++;
                    	%>
                        <div style="width:300px;height:550px;padding:10px;float:left;">
	                    <div style="width:200px;height:200px;padding:10px;">
	                        <a href="media/img/<%= img.getInstance().getName()%>">
	                        <img src="media/md/<%= img.getInstance().getName() %>.thumb.png" border="0"/>
	                        </a>
	                    </div>
	                    <div>
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
                    }
                } else 
                if ( medium instanceof AudioMedia ) {
                    // display audio thumbnail and metadata
                    AudioMedia audio = (AudioMedia) medium;

                	boolean matchedTag = false;
                	 
                    for ( String t : audio.getTags() )
                    	if (t.toLowerCase().equals(tag.toLowerCase()))
                    		matchedTag = true;
                    
                    if (matchedTag) {
                    	c++;
	                    %>
                        <div style="width:300px;height:550px;padding:10px;float:left;">
	                    <div style="width:200px;height:200px;padding:10px;">
	                        <br/><br/><br/><br/>
	                        <embed src="media/md/<%= audio.getInstance().getName() %>.wav" autostart="false" width="150" height="30" />
	                        <br/>
	                        <a href="media/audio/<%= audio.getInstance().getName()%>">
	                            Download <%= audio.getInstance().getName()%>
	                        </a>
	                    </div>
	                    <div>
	                        Name: <%= audio.getName() %><br/>
	                        Duration: <%= audio.getDuration() %><br/>
							Size: <%= audio.getSize() %> bytes <br/>
							album: <%= audio.getAlbum() %> <br/>
							author: <%= audio.getAuthor() %> <br/>
							bitrate: <%= audio.getBitrate() %> <br/>
							channels: <%= audio.getChannels() %> <br/>
							comment: <%= audio.getComment() %> <br/>
							composer: <%= audio.getComposer() %> <br/>
							date: <%= audio.getDate() %> <br/>
							encoding: <%= audio.getEncoding() %> <br/>
							frequency: <%= audio.getFrequency() %> <br/>
							genre: <%= audio.getGenre() %> <br/>
							title: <%= audio.getTitle() %> <br/>
							track: <%= audio.getTrack() %> <br/>
	                        Tags: <% for ( String t : audio.getTags() ) { %><a href="tags.jsp?tag=<%= t %>"><%= t %></a> <% } %><br/>
	                    </div>
	                    <%  
                    }
                } else
                if ( medium instanceof VideoMedia ) {
                    // handle videos thumbnail and metadata...
                    VideoMedia video = (VideoMedia) medium;
                    
                	boolean matchedTag = false;
                	 
                    for ( String t : video.getTags() )
                    	if (t.toLowerCase().equals(tag.toLowerCase()))
                    		matchedTag = true;
                    
                    if (matchedTag) {
                    	c++;
	                    %>
                        <div style="width:300px;height:550px;padding:10px;float:left;">
	                    <div style="width:200px;height:200px;padding:10px;">
	                        <a href="media/video/<%= video.getInstance().getName()%>">
	                            
	                        <object width="200" height="200">
	                            <param name="movie" value="media/md/<%= video.getInstance().getName() %>_thumb.avi">
	                            <embed src="media/md/<%= video.getInstance().getName() %>_thumb.avi" width="200" height="200">
	                            </embed>
	                        </object>
	
	                        </a>
	                    </div>
	                    <div>
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
                    }
                } else { }

                %>
                    </div>
                <%
                    if ( c % 3 == 0 ) {
                %>
                    <div style="clear:left" />
                <%
                        }

                } // for 
            
        %>
        
    </body>
</html>
