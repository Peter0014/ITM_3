package itm.audio;

/*******************************************************************************
 This file is part of the ITM course 2016
 (c) University of Vienna 2009-2016
 *******************************************************************************/

import java.io.File;
import java.io.IOException;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;
import javax.sound.sampled.UnsupportedAudioFileException;

/**
 * Plays an audio file using the system's default sound output device
 * 
 */
public class AudioPlayer {

	/**
	 * Constructor
	 */
	public AudioPlayer() {

	}

	/**
	 * Plays audio data from a given input file to the system's default sound
	 * output device
	 * 
	 * @param input
	 *            the audio file
	 * @throws IOException
	 *             general error when accessing audio file
	 */
	protected void playAudio(File input) throws IOException {

		if (!input.exists())
			throw new IOException("Input file " + input + " was not found!");

		AudioInputStream audio = null;
		try {
			audio = openAudioInputStream(input);
		} catch (UnsupportedAudioFileException e) {
			throw new IOException("could not open audio file " + input
					+ ". Encoding / file format not supported");
		}

		try {
			rawplay(audio);
		} catch (LineUnavailableException e) {
			throw new IOException("Error when playing sound from file "
					+ input.getName() + ". Sound output device unavailable");
		}

		audio.close();

	}

	/**
	 * Decodes an encoded audio file and returns a PCM input stream
	 * 
	 * Supported encodings: MP3, OGG (requires SPIs to be in the classpath)
	 * 
	 * @param input
	 *            a reference to the input audio file
	 * @return a PCM AudioInputStream
	 * @throws UnsupportedAudioFileException
	 *             an audio file's encoding is not supported
	 * @throws IOException
	 *             general error when accessing audio file
	 */
	private AudioInputStream openAudioInputStream(File input)
			throws UnsupportedAudioFileException, IOException {

		AudioInputStream din = null;

		// ***************************************************************
		// Fill in your code here!
		// ***************************************************************
		
		// open audio stream
		AudioInputStream in = AudioSystem.getAudioInputStream(input);
		
		// get format
		AudioFormat aformat = in.getFormat();
		
		  
		// get decoded format
		  AudioFormat  decodedFormat = new AudioFormat(
			  AudioFormat.Encoding.PCM_SIGNED,
			  aformat.getSampleRate(),
			  16,
			  aformat.getChannels(),
			  aformat.getChannels() * 2,
			  aformat.getSampleRate(),
			  false);
		
		// get decoded audio input stream
		  din = AudioSystem.getAudioInputStream(decodedFormat, in);

		
		return din;
	}

	/**
	 * Writes audio data from an AudioInputStream to a SourceDataline
	 * 
	 * @param audio
	 *            the audio data
	 * @throws IOException
	 *             error when writing audio data to source data line
	 * @throws LineUnavailableException
	 *             system's default source data line is not available
	 */
	private void rawplay(AudioInputStream audio) throws IOException,
			LineUnavailableException {

		
		
		// ***************************************************************
		// Fill in your code here!
		// ***************************************************************
		
		
		// get a source data line
		AudioFormat af = audio.getFormat();
		
		// erzeugen einer DataLine um abzufragen ob dieser Line type überhaupt suppored wird.   
		DataLine.Info dataLineInfo = new DataLine.Info(SourceDataLine.class, af);
		if(! AudioSystem.isLineSupported(dataLineInfo)) {
			System.out.println("AudioSystem does not support the line type: " + dataLineInfo);
			return;
		}
		//auf die sourceDaaLine werden die Audiobis bgeschreiben, welchen dem mixwer weiergeleie werden, 
		//der diese daruaf mit verschiedenen lines mixen und abspielen kann. 
		SourceDataLine sourceDataLine = (SourceDataLine)AudioSystem.getLine(dataLineInfo);

		try {
			//oeffnen und starten der dataline
			sourceDataLine.open(af);
			sourceDataLine.start();
			
			//die akuellen bis die gelesen werden
			int actualBitsRead;
			
			//die groesse des Buffers, wie viele bytes pro durchgang von der audiodaei gelesen werden sollen 
			byte[] buffer = new byte[1024];
			
			//liest die anaahl an bis (abhaengig von der buffer groesse) aus, gib sie der sourcedataline weiter welche diese abspielt.
			while( (actualBitsRead = audio.read(buffer, 0, buffer.length)) != -1 ) {
				if(actualBitsRead > 0) {
					// schreibt nun die daten auf die lane, die es den lautsprechern ausliefert und somit zu hoeren ist.
					sourceDataLine.write(buffer, 0, actualBitsRead);
				}
			}

			//connection wieder sauber schließen 
			sourceDataLine.drain();
			sourceDataLine.close();
		}catch(Exception ex) {
			System.out.println("error occured: " + ex.getMessage());
		}
		// properly close the line!
	}

	/**
	 * Main method. Parses the commandline parameters and prints usage
	 * information if required.
	 */
	public static void main(String[] args) throws Exception {

		if (args.length < 1) {
			System.out
					.println("usage: java itm.audio.AudioPlayer <input-audioFile>");
			System.exit(1);
		}
		File fi = new File(args[0]);
		AudioPlayer player = new AudioPlayer();
		player.playAudio(fi);
		System.exit(0);

	}

}
