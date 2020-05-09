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
	   	run("Bio-Formats Importer", "open=["+input+"] autoscale color_mode=Colorized rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT "+f+"");

		//change channel 1 to yellow
		Stack.setChannel(1);
		run("Yellow");
		//change channel 2 to magenta 
		Stack.setChannel(2);
		Stack.setDisplayMode("color");
		run("Magenta");

//get the title of the stacked images
		title = getTitle();
		
//now split the channels, this will split stacked channels into individual image windows that will 
//start with "Cx-" where x is the channel number. So Channel 1 will be: "C1-......"
		run("Split Channels");

//create variables for each channel name so we can generically use them when we merge the channels
		c1 = "C1-"+title; 
		c2 = "C2-"+title;

//print(title); //uncomment to check the channel names make sense

//merge the channels. c6 is magenta and c7 is yellow. Use the variables for the channel names to specify 
//what colour each channel should be in the composite image.
//square brackets is to allow there to be whitespace in the filenames (I think).
		run("Merge Channels...", "c6=["+c2+"] c7=["+c1+"] create keep ignore");  
		saveAs("Jpeg", output+File.separator+title+"YFP + Chl merge");

	
		run("Scale Bar...", "width="+scale+" height=8 font=28 color=White background=None location=[Lower Right] bold overlay");
		saveAs("Jpeg", output+File.separator+title+"YFP + Chl merge scale bar"+scale);
		Close();

//Select channel 1 window, add a scale bar, save as Jpeg then close
		selectWindow(c1);
		run("Scale Bar...", "width="+scale+" height=8 font=28 color=White background=None location=[Lower Right] bold overlay");
		saveAs("Jpeg", output+File.separator+title+"YFP channel scale bar"+scale);
		close(c1);

//Select channel 2 window, add a scale bar, save as Jpeg then close
		selectWindow(c2);
		run("Scale Bar...", "width="+scale+" height=8 font=28 color=White background=None location=[Lower Right] bold overlay");
		saveAs("Jpeg", output+File.separator+title+"Chl channel scale bar"+scale);
		close();
		close();
		close();
		

}



