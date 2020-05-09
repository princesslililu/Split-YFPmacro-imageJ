# Split-YFPmacro-imageJ
To batch open and process .lif files

This macro is useful when your microscopy images are all stored as 'series' in a .lif file and not seperately as individual .tiff files.

This macro will allow you to automatically open and apply changes to all series in a .lif file. 

In this particular macro the actions are:
 * Change the colours of the channels
 * Add a scalebar
 * Merge two channels
 * save 

Because there doesn't appear to be/I can't find a way to extract the number of series in a given .lif, the user has to define this manually. However, if you know the number of series in the .lif file then you can input this so that the macro processes them all. There is also an option to pick only one series, or a range. 

I will work on a way to pick arbitrary series but for now, if you wanted to process a handful of differnt series you would need to do one series per macro run. 

Language:
ImageJ macro language

Dependencies:
Bio-format ImageJ plugin https://imagej.net/Bio-Formats

I recommened using the Fiji distribution of ImageJ which has many plugins already installed for confocal microscopy image analysis https://imagej.net/Fiji/Downloads

Once in ImageJ, I use the macro by naviagting to Plugins>Macros>Run...  and then slecting the the .ijm file through the browser.
Unfortunately, it doesn't seem to work when I install it so far.
