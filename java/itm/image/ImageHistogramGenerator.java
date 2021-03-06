package itm.image;

import java.awt.Color;
import java.awt.color.ColorSpace;
import java.awt.image.BufferedImage;
import java.awt.image.ColorModel;

/*******************************************************************************
    This file is part of the ITM course 2016
    (c) University of Vienna 2009-2016
*******************************************************************************/


import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.imageio.ImageIO;
import javax.imageio.ImageWriter;

import itm.util.Histogram;

/**
    This class creates color and grayscale histograms for various images.
    It can be called with 3 parameters, an input filename/directory, an output directory and a various bin/interval size.
    It will read the input image(s), count distinct pixel values and then plot the histogram.

    If the input file or the output directory do not exist, an exception is thrown.
*/
public class ImageHistogramGenerator 
{
	final String STR_RED = "red";
	final String STR_GREEN = "green";
	final String STR_BLUE = "blue";

    /**
        Constructor.
    */
    public ImageHistogramGenerator() 
    {
    }

    /**
        Processes an image directory in a batch process.
        @param input a reference to the input image file
        @param output a reference to the output directory
        @param bins the histogram interval
        @return a list of the created files
    */
    public ArrayList<File> batchProcessImages( File input, File output, int bins) throws IOException
    {
        if ( ! input.exists() ) 
            throw new IOException( "Input file " + input + " was not found!" );
        if ( ! output.exists() ) 
            throw new IOException( "Output directory " + output + " not found!" );
        if ( ! output.isDirectory() ) 
            throw new IOException( output + " is not a directory!" );

        ArrayList<File> ret = new ArrayList<File>();
        
        if ( input.isDirectory() ) {
            File[] files = input.listFiles();
            for ( File f : files ) {
                try {
                    File result = processImage( f, output, bins );
                    System.out.println( "converted " + f + " to " + result );
                    ret.add( result );
                } catch ( Exception e0 ) {
                    System.err.println( "Error converting " + input + " : " + e0.toString() );
                    }
                 }
            } else {
            try {
                File result = processImage( input, output, bins );
                System.out.println( "created " + input + " for " + result );
                ret.add( result );
            } catch ( Exception e0 ) { System.err.println( "Error creating histogram from " + input + " : " + e0.toString() ); }
            } 
        return ret;
    }  
    
    /**
        Processes the passed input image and stores it to the output directory.
        @param input a reference to the input image file
        @param output a reference to the output directory
        @param bins the histogram interval
        already existing files are overwritten automatically
    */   
	protected File processImage( File input, File output, int bins ) throws IOException, Exception, IllegalArgumentException
    {
		if ( ! input.exists() ) 
            throw new IOException( "Input file " + input + " was not found!" );
        if ( input.isDirectory() ) 
            throw new IOException( "Input file " + input + " is a directory!" );
        if ( ! output.exists() ) 
            throw new IOException( "Output directory " + output + " not found!" );
        if ( ! output.isDirectory() ) 
            throw new IOException( output + " is not a directory!" );


		// compose the output file name from the absolute path, a path separator and the original filename
		String outputFileName = "";
		outputFileName += output.toString() + File.separator + input.getName().toString();
		File outputFile = new File( output, input.getName() + ".hist.png" );
		
       
        // ***************************************************************
        //  Fill in your code here!
        // ***************************************************************

		try
		{
	        // load the input image
			BufferedImage img = ImageIO.read(input);
			
			// get the color model of the image and the amount of color components
			ColorModel cm = img.getColorModel();
			int numColComp = cm.getNumColorComponents();
			
			// initiate a Histogram[color components] [bins]
			Histogram hg = new Histogram(numColComp, bins);
			
			// create a histogram array histArray[color components][bins]
			int[][] histArray = new int[numColComp][bins]; 
			
			int height = img.getHeight();
			int width = img.getWidth();

			//if(cm.getNumColorComponents() >= 3) //color pic
			if(cm.getColorSpace().getType() == ColorSpace.TYPE_RGB) 
			{
				for(int iC = 0; iC<width;iC++)
					for(int iC2 = 0; iC2<height;iC2++)
					{
						Color col = new Color(img.getRGB(iC, iC2));
	
						histArray[0] [(int)((double)col.getRed() / 255 * (bins-1))] +=1;
						histArray[1] [(int)((double)col.getGreen() / 255 * (bins-1))] +=1;
						histArray[2] [(int)((double)col.getBlue() / 255 * (bins-1))] +=1;
					}
			}
			else
	            throw new IOException( "The Color Space \""+cm.getColorSpace()+"\" is not supported." );
				
			
			// fill the array setHistogram(histArray)
			hg.setHistogram(histArray);
			
			// plot the histogram, try different dimensions for better visualization
	        // encode and save the image as png
			ImageIO.write(hg.plotHistogram(1028, 720), "png", outputFile);
			
	         
	        return outputFile;

		}
        catch(Exception ex)
        {
            throw new Exception( "An Error occured: \n" + ex.getMessage());
        }
    }

	public ArrayList<String> GetDominantColors( File input, int dominantColorOffsetInPercent, int recognizeBlackWhiteOffset) throws IOException, Exception, IllegalArgumentException
    {
		if ( ! input.exists() ) 
            throw new IOException( "Input file " + input + " was not found!" );
        if ( input.isDirectory() ) 
            throw new IOException( "Input file " + input + " is a directory!" );


        // ***************************************************************
        //  Fill in your code here!
        // ***************************************************************

		try
		{
	        // load the input image
			BufferedImage img = ImageIO.read(input);
			
			ArrayList<String> toRet = new ArrayList<>();
			
			int height = img.getHeight();
			int width = img.getWidth();
			
			int red=0;
			int green=0;
			int blue=0;
			
			//if(cm.getNumColorComponents() >= 3) //color pic
			//if(cm.getColorSpace().getType() == ColorSpace.TYPE_RGB) 
			{
				for(int iC = 0; iC<width;iC++)
					for(int iC2 = 0; iC2<height;iC2++)
					{
						Color col = new Color(img.getRGB(iC, iC2));
						int totalColor = col.getBlue()+col.getGreen()+col.getRed();

						float percRed = (float)((float)col.getRed() / (float)totalColor) * 100f;
						float percGreen = (float)((float)col.getGreen() / (float)totalColor) * 100f;
						float percBlue = (float)((float)col.getBlue() / (float)totalColor) * 100f;
						
						boolean foundDominant = false;
						boolean isBlackOrWhite = false;
						
						float twoColors = percRed+percGreen;
						
						if(percRed >= percGreen-recognizeBlackWhiteOffset && percRed <= percGreen+recognizeBlackWhiteOffset)
						{
							if(percRed >= percBlue-recognizeBlackWhiteOffset && percRed <= percBlue+recognizeBlackWhiteOffset)
							{
								isBlackOrWhite=true;
							}
						}
						
						if(!isBlackOrWhite)
						{
							
							if(isFirstColGreaterThanSecond(percBlue, twoColors))
							{
								blue++;
								foundDominant=true;
							}
							
							twoColors = percRed+percBlue;
							if(isFirstColGreaterThanSecond(percGreen, twoColors))
							{
								green++;
								foundDominant=true;
							}
							
							twoColors = percGreen+percBlue;
							if(isFirstColGreaterThanSecond(percRed, twoColors))
							{
								red++;
								foundDominant=true;
							}
							
							//Gibt es bis jetzt noch keine dominante farbe, probier das gleiche nochmal, nur diesmal abzueglich dem mtgegebenen Offset
							if(!foundDominant)
							{
								
								twoColors = percRed+percGreen-dominantColorOffsetInPercent;
								if(isFirstColGreaterThanSecond(percBlue, twoColors))
								{
									blue++;
									foundDominant=true;
								}
								
								twoColors = percRed+percBlue-dominantColorOffsetInPercent;
								if(isFirstColGreaterThanSecond(percGreen, twoColors))
								{
									green++;
									foundDominant=true;
								}
								
								twoColors = percGreen+percBlue-dominantColorOffsetInPercent;
								if(isFirstColGreaterThanSecond(percRed, twoColors))
								{
									red++;
									foundDominant=true;
								}
								
								//Wurde noch immer keine Dominante Farbe gefunden, gibt es mehrere dominante farben
								if(!foundDominant)
								{
									if(percRed >= percGreen-dominantColorOffsetInPercent && percRed <= percGreen+dominantColorOffsetInPercent)
									{
										red++;
										green++;
										foundDominant=true;
									}
									if(percRed >= percBlue-dominantColorOffsetInPercent && percRed <= percBlue+dominantColorOffsetInPercent)
									{
										if(!foundDominant)
											red++;
										
										blue++;
										foundDominant=true;
									}
									
									if(!foundDominant)
									{
										if(percGreen >= percRed-dominantColorOffsetInPercent && percGreen <= percRed+dominantColorOffsetInPercent)
										{
											blue++;
											red++;
											foundDominant=true;
										}
										if(percGreen >= percBlue-dominantColorOffsetInPercent && percGreen <= percBlue+dominantColorOffsetInPercent)
										{
											if(!foundDominant)
												blue++;
											
											green++;
											foundDominant=true;
										}
										
										if(!foundDominant)
										{
											if(percBlue >= percGreen-dominantColorOffsetInPercent && percBlue <= percGreen+dominantColorOffsetInPercent)
											{
												blue++;
												green++;
												foundDominant=true;
											}
											if(percBlue >= percRed-dominantColorOffsetInPercent && percBlue <= percRed+dominantColorOffsetInPercent)
											{
												if(!foundDominant)
													blue++;
												
												red++;
												foundDominant=true;
											}
										}
									}
								}
							}
	
	
							
							if(!foundDominant)
							{
								if(percRed > percGreen && percRed > percBlue)
								{
									red++;
									foundDominant=true;
								}
	
								if(percBlue > percGreen && percBlue > percRed)
								{
									blue++;
									foundDominant=true;
								}
	
								if(percGreen > percBlue && percRed > percRed)
								{
									green++;
									foundDominant=true;
								}
							}
							
						}

					}
			}
				

			int totalColor = red+green+blue;

			float percRed = (float)((float)red / (float)totalColor) * 100f;
			float percGreen = (float)((float)green / (float)totalColor) * 100f;
			float percBlue = (float)((float)blue / (float)totalColor) * 100f;
			
			boolean foundDominant = false;
			
			float twoColors = percRed+percGreen;
			if(isFirstColGreaterThanSecond(percBlue, twoColors))
			{
				toRet.add(STR_BLUE);
				foundDominant=true;
			}
			
			twoColors = percRed+percBlue;
			if(isFirstColGreaterThanSecond(percGreen, twoColors))
			{
				toRet.add(STR_GREEN);
				foundDominant=true;
			}
			
			twoColors = percGreen+percBlue;
			if(isFirstColGreaterThanSecond(percRed, twoColors))
			{
				toRet.add(STR_RED);
				foundDominant=true;
			}
			
			//Gibt es bis jetzt noch keine dominante farbe, probier das gleiche nochmal, nur diesmal abzueglich dem mtgegebenen Offset
			if(!foundDominant)
			{
				
				twoColors = percRed+percGreen-dominantColorOffsetInPercent;
				if(isFirstColGreaterThanSecond(percBlue, twoColors))
				{
					toRet.add(STR_BLUE);
					foundDominant=true;
				}
				
				twoColors = percRed+percBlue-dominantColorOffsetInPercent;
				if(isFirstColGreaterThanSecond(percGreen, twoColors))
				{
					toRet.add(STR_GREEN);
					foundDominant=true;
				}
				
				twoColors = percGreen+percBlue-dominantColorOffsetInPercent;
				if(isFirstColGreaterThanSecond(percRed, twoColors))
				{
					toRet.add(STR_RED);
					foundDominant=true;
				}
				
				//Wurde noch immer keine Dominante Farbe gefunden, gibt es mehrere dominante farben
				if(!foundDominant)
				{
					if(percRed >= percGreen-dominantColorOffsetInPercent && percRed <= percGreen+dominantColorOffsetInPercent)
					{
						toRet.add(STR_RED);
						toRet.add(STR_GREEN);
						foundDominant=true;
					}
					if(percRed >= percBlue-dominantColorOffsetInPercent && percRed <= percBlue+dominantColorOffsetInPercent)
					{
						if(!foundDominant)
							toRet.add(STR_RED);

						toRet.add(STR_BLUE);
						foundDominant=true;
					}
					
					if(!foundDominant)
					{
						if(percGreen >= percRed-dominantColorOffsetInPercent && percGreen <= percRed+dominantColorOffsetInPercent)
						{
							toRet.add(STR_BLUE);
							toRet.add(STR_RED);
							foundDominant=true;
						}
						if(percGreen >= percBlue-dominantColorOffsetInPercent && percGreen <= percBlue+dominantColorOffsetInPercent)
						{
							if(!foundDominant)
								toRet.add(STR_BLUE);

							toRet.add(STR_GREEN);
							foundDominant=true;
						}
						
						if(!foundDominant)
						{
							if(percBlue >= percGreen-dominantColorOffsetInPercent && percBlue <= percGreen+dominantColorOffsetInPercent)
							{
								toRet.add(STR_BLUE);
								toRet.add(STR_GREEN);
								foundDominant=true;
							}
							if(percBlue >= percRed-dominantColorOffsetInPercent && percBlue <= percRed+dominantColorOffsetInPercent)
							{
								if(!foundDominant)
									toRet.add(STR_BLUE);

								toRet.add(STR_RED);
								foundDominant=true;
							}
						}
					}
				}
			}

			if(!foundDominant)
			{
				if(percRed > percGreen && percRed > percBlue)
				{
					toRet.add(STR_RED);
					foundDominant=true;
				}

				if(percBlue > percGreen && percBlue > percRed && !foundDominant)
				{
					toRet.add(STR_BLUE);
					foundDominant=true;
				}

				if(percGreen > percBlue && percGreen > percRed && !foundDominant)
				{
					toRet.add(STR_GREEN);
					foundDominant=true;
				}
			}
	        return toRet;

		}
        catch(Exception ex)
        {
            throw new Exception( "An Error occured: \n" + ex.getMessage());
        }
    }
	
	boolean isFirstColGreaterThanSecond(float firstCol, float secondCol)
	{
		if(firstCol > secondCol)
			return true;
		return false;
	}
        
    /**
        Main method. Parses the commandline parameters and prints usage information if required.
    */
    public static void main( String[] args ) throws Exception
    {
        if ( args.length < 3 ) {
            System.out.println( "usage: java itm.image.ImageHistogramGenerator <input-image> <output-directory> <bins>" );
            System.out.println( "usage: java itm.image.ImageHistogramGenerator <input-directory> <output-directory> <bins>" );
            System.out.println( "");
            System.out.println( "bins:default 256" );
            System.exit( 1 );
        }
        // read params
        File fi = new File( args[0] );
        File fo = new File( args[1] );
        int bins = Integer.parseInt(args[2]);
        ImageHistogramGenerator histogramGenerator = new ImageHistogramGenerator();
        histogramGenerator.batchProcessImages( fi, fo, bins );        
    }    
}