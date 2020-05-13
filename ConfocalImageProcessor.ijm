/***
Liat Adler 
09.05.2020

This macro will allow you to:
-open series from a .lif file 
-batch alter the channel colours (this uses yellow and magenta as a colour blind friendly combo)
-batch add a defined scale bar
-batch merge of dedined channels
-save the images as JPEGs

***/


//function iterateseries(series)
#@ File (label = "Input file", style = "file") input 				//choose the .lif file
#@ File (label = "Output directory", style = "directory") output 	//choose where to save your JPEG images
#@ String (label = "Series start number", style = "string") m 		//choose the start of the series range
#@ String (label = "Series end number", style = "string") n 		//choose the end of your series range
#@ String (label = "Scalebar size", style = "string") scale 		//choose the width of your scale bar in micrometers


//choose the colour for each channel
colours = newArray("c1", "c2", "c3", "c4", "c5", "c6", "c7"); 					// this sets up an array of colour choices in the format the 'merge channel' tool will recognise
choices = newArray("Red", "Green", "Blue", "Grey", "Cyan", "Magenta", "Yellow");// this sets up an array of colour choices in the format the change channel colour tool will recognise

Dialog.create("Choose Channel Colours"); // allows user to choose channel colours from a drop down menu
Dialog.addChoice("Channel 1 colour", choices);
Dialog.addChoice("Channel 2 colour", choices);
Dialog.show();
colour1 = Dialog.getChoice();
for (i=0; i<choices.length; i++) { 		// this links the choice of a colour and converts it into the form recognised by the 'merge channel' tool, e.g converts 'red' to 'c1'
if (colour1 == choices[i]) {
ch1c = colours[i];
break;
 }
}


colour2 = Dialog.getChoice();
for (i=0; i<choices.length; i++) {
if (colour2 == choices[i]) {
ch2c = colours[i];
break;
 }
}



//This will iterate through a defined range of series in the .lif file (you will need to
//know the number of series in advance 
iterate();

function iterate(){
for (i=m; i<n ;i++) {
	processFile(input, i);
        }
}

//this is the function to open and process the images in the .lif file
function processFile(input, i) {
		f = "series_"+i;
	   	run("Bio-Formats Importer", "open=["+input+"] color_mode=Colorized rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT "+f+"");

		//change channel 1 to yellow and reset min max from autoscaling
		Stack.setChannel(1);
		run("Brightness/Contrast...");
		resetMinAndMax();
		run(colour1);
		
		//change channel 2 to magenta and reset min max from autoscaling
		Stack.setChannel(2);
		run("Brightness/Contrast...");
		resetMinAndMax();
		Stack.setDisplayMode("color");
		run(colour2);

//get the title of the stacked images
		title = getTitle();
		
//now split the channels, this will split stacked channels into individual image windows that will 
//start with "Cx-" where x is the channel number. So Channel 1 will be: "C1-......"
		run("Split Channels");

//create variables for each channel so we can generically use them when we merge the channels
		ch1 = "C1-"+title; 
		ch2 = "C2-"+title;
		ch3 = "C3-"+title;

//print(title); //uncomment to check the channel names make sense

//merge the channels. 
//c1 is red
//c2 is green
//c3 is blue
//c4 is grey
//c5 is cyan
//c6 is magenta and 
//c7 is yellow. Use the variables for the channel names to specify 
//what colour each channel should be in the composite image.
//square brackets is to allow there to be whitespace in the filenames.red = "c1";

		run("Merge Channels...", ""+ch2c+"=["+ch2+"] "+ch1c+"=["+ch1+"] create keep ignore");  
		saveAs("Jpeg", output+File.separator+title+"YFP + Chl merge");

	
		run("Scale Bar...", "width="+scale+" height=8 font=28 color=White background=None location=[Lower Right] bold overlay");
		saveAs("Jpeg", output+File.separator+title+"YFP + Chl merge scale bar"+scale);
	
		run("Merge Channels...", ""+ch2c+"=["+ch2+"] "+ch1c+"=["+ch1+"] c4=["+ch3+"] create keep ignore");  
		saveAs("Jpeg", output+File.separator+title+"YFP + Chl + TL merge");

		run("Scale Bar...", "width="+scale+" height=8 font=28 color=White background=None location=[Lower Right] bold overlay");
		saveAs("Jpeg", output+File.separator+title+"YFP + Chl +TL merge scale bar"+scale);

//Select channel 1 window, add a scale bar, save as Jpeg then close
		selectWindow(ch1);
		saveAs("Jpeg", output+File.separator+title+" mNeon channel");
		run("Scale Bar...", "width="+scale+" height=8 font=28 color=White background=None location=[Lower Right] bold overlay");
		saveAs("Jpeg", output+File.separator+title+" mNeon channel scale bar"+scale);
		close(ch1);

//Select channel 2 window, add a scale bar, save as Jpeg then close
		selectWindow(ch2);
		saveAs("Jpeg", output+File.separator+title+" Chl channel");
		run("Scale Bar...", "width="+scale+" height=8 font=28 color=White background=None location=[Lower Right] bold overlay");
		saveAs("Jpeg", output+File.separator+title+" Chl channel scale bar"+scale);
		
		
		selectWindow(ch3);
		saveAs("Jpeg", output+File.separator+title+" TL channel");
		run("Scale Bar...", "width="+scale+" height=8 font=28 color=White background=None location=[Lower Right] bold overlay");
		saveAs("Jpeg", output+File.separator+title+" TL channel scale bar"+scale);

}



