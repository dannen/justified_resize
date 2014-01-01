Justified_resize is a CLI perl script to resize images in a directory to the flickr suffix standards.<br>
	( http://www.flickr.com/services/api/misc.urls.html )

Justified_resize complements the Justified Gallery code and is intended for CLI operations.<br>
	( https://github.com/miromannino/Justified-Gallery )


Justified_resize automatically resizes the images in the current working directory by reading everything into an array, making a copy of each image file into the $resizeddir variable target and then resizing the file using convert or mogrify.  Justified_resize will not upscale images, instead it will use the original image as the target for the larger sized version.

 i.e. if file.jpg is smaller than 1024 pixels on the longest side, it will be copied to filename_b.jpg and will not be modified.

Justified_resize processes only .jpg, .gif, and .png suffixed files.

Justified_resize can detect animated gifs and using imagemagick convert to scale them appropriately. 
Justified_resize cannot currently detect or rescale animated png/apng files.


Requirements: <a href="http://www.imagemagick.org/">imagemagick's</a> convert and mogrify commands.

Tested: Linux Mint 12.04
