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
<head>
    <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ITM 3 2016 - Graph</title>
    
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
	
	      <a class="btn-default btn-sm" href="index.jsp"  style=" float: left; margin-top: 1.25%; margin-left: 1%;">
				      	<i class="fa fa-chevron-left" aria-hidden="true"></i> Back
	      </a>
	      <h3 style="text-align:center; overflow:hidden; padding: 20px; margin: 0px; padding-left: 15%;"> 
		      Welcome to the ITM Graph (Made With Graph Dracula)
			      <a class="btn-default btn-sm" href="#"  style=" float: right; margin-right: 1%;">
				      	<i class="fa fa-tags" aria-hidden="true"></i> Tags
			      </a>
			      <a class="btn-default btn-sm" href="#"  style=" float: right; margin-right: 1%;">
				      	<i class="fa fa-users" aria-hidden="true"></i> Team
			      </a>
			      <a class="btn-default btn-sm" href="index.jsp"  style=" float: right; margin-right: 1%;">
				      	<i class="fa fa-share-alt" aria-hidden="true"></i> Home
			      </a>
	      </h3> 
  </div>
</nav>
        <%
            // get the file paths - this is NOT good style (resources should be loaded via inputstreams...)
            // we use it here for the sake of simplicity.
            String basePath = getServletConfig().getServletContext().getRealPath( "media"  );
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
    
            // ***************************************************************
            //  Fill in your code here!
            // ***************************************************************
            
        %>
        <div id="canvas" style="height: 1024px; width: 1024px; margin: auto; display: block; text-align:center;">
        <script>
            var g = new Graph();
            
            
            g.addNode("Tags", "", "./tags.jsp");
            
        <%
        	ArrayList<String> alreadyAddedMedia = new ArrayList<>();
            for ( AbstractMedia medium : media ) {
            	for ( String t : medium.getTags() ) {
            		String path = "./media/";
            		if ( medium instanceof ImageMedia )
            			path += "img/";
            		else if ( medium instanceof AudioMedia )
            			path += "audio/";
            		else if ( medium instanceof VideoMedia )
            			path += "video/";
            		path += medium.getName();
            		if (!alreadyAddedMedia.contains(t.toLowerCase())) {
            			alreadyAddedMedia.add(t.toLowerCase());
		        %>
		        		g.addNode("<%= t.toLowerCase() %>", "", "./tags.jsp?tag=<%= t %>");
		        		g.addEdge("Tags", "<%= t.toLowerCase() %>", "./tags.jsp?tag=<%= t %>");
		        <%
            		}
            		if (!alreadyAddedMedia.contains(medium.getName())) {
            			alreadyAddedMedia.add(medium.getName());
		        %>
		        		g.addNode("<%= medium.getName() %>", "", "<%= path %>")
		        <%
            		}
            	%>
                	g.addEdge("<%= t.toLowerCase() %>", "<%= medium.getName() %>");
            	<%
            	}
            }
        %>
            var layouter = new Graph.Layout.Spring(g);
            layouter.layout();
            
            var renderer = new Graph.Renderer.Raphael('canvas', g, 1024, 1024);
            renderer.draw();
        </script> 
        </div>
    </body>
</html>