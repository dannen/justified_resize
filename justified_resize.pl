#!/usr/bin/perl
#
# justified masony jpg resizer
#
# for use with https://github.com/miromannino/Justified-Gallery
#
# dannen harris (c) 2013

# expected sizes as per Justified-Gallery (aka flickr) expectations
#
#"_t": thumbnail: 100px  on longest side
#"_m": small:     240px  on longest side
#"_n": small:     320px  on longest side
#"" : medium:     500px  on longest side  (unused in my script -dannen)
#"_z": medium:    640px  on longest side
#"_c": medium:    800px  on longest side
#"_b": large:     1024px on longest side

# array of size options and suffixes
%sizes = ( 't', '100', 'm', '240', 'n', '320', 'z', '640', 'c', '800', 'b', '1024' );

# target directory for resized images
$resizeddir = "resized";

# find out where we are
$pwd = `pwd`;
chomp $pwd;
print "Running in: $pwd\n";

# read all filenames into an array
opendir (DIR,$pwd);
foreach $picture (sort readdir DIR ) {
        $dirnames{$picture}++;
}
close DIR;

# resize each image, excluding the previously resized images
foreach $picture (sort keys %dirnames ) {
	chomp $picture;
        if ( $picture !~ /_[b,c,n,m,t,z]\./ ) {
        	if ( $picture =~ /\.jpg$/ ) {
			&resize;
        	} elsif ( ( $picture =~ /\.gif$/) || ( $picture =~ /\.png/) ) {
			&testanimated;
			&resize;
		}
	}
}
close DIR;

# set perms on directory and files
#system ("chmod 755 .");
#system ("chmod 644 *.jpg");
#system ("chmod 644 *.gif");
#system ("chmod 644 *.png");

# examine gifs
sub testanimated {

	# animated png aka apng files cannot be detected as below, need to find an alternative method
	$animated = 0;

	print "Testing image $picture\n";

	# detect number of frames in image
	my $frames = `identify -format %n $picture`;
	chomp $frames;
	#print "frames = $frames\n";

	if ( $frames >= "2" ) {
		$animated = 1;
	}
	if ( $animated == 1 ) {
		print "$picture is animated.\n\n";
	} else {
		print "$picture is not animated.\n\n";
	}
	
}

# resize images
sub resize {

        ($image,$suffix) = split (/\./, $picture);

	print "Working with $picture\n";
	foreach $key (sort keys %sizes) {
	
		$target = join "", $image, "_", $key, ".", $suffix;
		print "target is $target\n";

		# only copy original for resizing if it doesn't already exist
		if ( ! -e "$resizeddir/$target" ) {
			
			# copy original into resized directory for justified_gallery_builder
			# make a copy of original. if scale > original dimensions, original image will be used rather than upscaling
			mkdir $resizeddir,0777;
			system ("cp $picture $resizeddir/$picture");		
			system ("cp $picture $resizeddir/$target");		
		

			# identify width and height
                	my $fullratio = `identify -format \"\%wx\%h:\" $resizeddir/$target`;
                	chomp $fullratio;
			#print "fullratio $fullratio\n";

			# animated images have 100x100:100x100: so we take the first value split on : to compensate
			(my $ratio, $null) = split ( /:/, $fullratio);

			# parse dimensions of image
                	($width, $height) = split ( /x/, $ratio);
                	$height = int ($height);
                	$width  = int ($width);
                	#print "height: $height, width: $width\n";

			my $scale = $sizes{$key};
			#print "key: $key\n scale: $scale\n";

			if ( ( $height > $scale) || ( $width > $scale) ) {
				if ( $suffix =~ /jpg/ ) {
                			if ( $height > $width ) {
						# optional parsing for wider than tall
                        			# print "wider than taller $height x $width $target\n";
                        			system ("mogrify -scale x$scale  $resizeddir/$target");
                			} else {
						# no special processing yet for taller than wide
                        			system ("mogrify -scale x$scale  $resizeddir/$target");
					}
                		} elsif ( $suffix =~ /gif/ ) {
					print "processing $suffix\n";
					if ( $animated == 1 ) {
						# resize animated gifs or pngs
						# darken and sharpen image slighly during resizing
						print "animated\n";
						#system ("convert -sharpen 2 -gamma 0.75 -size $original_dimensions $picture -resize $new_dimensions $target");
						system ("convert -sharpen 2 -gamma 0.75 $picture -scale x$scale $resizeddir/$target");
					} else {
						#print "not animated\n";
						# no special processing yet for taller than wide
						system ("mogrify -scale x$scale  $resizeddir/$target");
					}
                		} elsif ( $suffix =~ /png/ ) {
					# animated png/apng files not presently supported
					print "processing $suffix\n";
					system ("mogrify -scale x$scale  $resizeddir/$target");

				}
			}
		}
	}
}

