This is a perl script to resize images in a directory to the flickr suffix standards. 
	( http://www.flickr.com/services/api/misc.urls.html )

This script complements the justified gallery code.
	( https://github.com/miromannino/Justified-Gallery )


It automatically resizes the images in the current working directory by reading everything into an array, making a copy of each image file and then resizing the file using mogrify.

Currently it processes only .jpg suffixed files.  I'm planning on adding resizing for animated .gif files and .png files in the near future.


Requirements: imagemagick's mogrify command

Tested: Linux Mint 12.04
