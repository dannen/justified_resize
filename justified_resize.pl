#!/usr/bin/perl
#
# justified masony jpg resizer
#
# for use with https://github.com/miromannino/Justified-Gallery
#
# dannen harris (c) 2013

umask 033;

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
        if ( ( $picture =~ /.jpg$/ )  && ( $picture !~ /_[b,c,n,m,t,z]/ ) ) {
		&resize;
        }
}
close DIR;

# set perms on directory and files
system ("chmod 755 .");
system ("chmod 644 *.jpg");

# resize images
sub resize {

	chomp $picture;
        ($image,$suffix) = split (/\./, $picture);

	print "Working with $picture\n";
	foreach $key (sort keys %sizes) {
	
		$target = join "", $image, "_", $key, ".jpg";

		# only copy original for resizing if it doesn't already exist
		if ( ! -e $target ) {
			system ("cp $picture $target");		
		

			# identify width and height
                	my $ratio = `identify -format \"\%wx\%h\" $target`;
                	chomp $ratio;
                	($width, $height) = split ( /x/, $ratio);
                	$height = int ($height);
                	$width  = int ($width);
                	#print "height: $height, width: $width\n";

			my $scale = $sizes{$key};
			#print "key: $key\n scale: $scale\n";

                	if ( $height > $width ) {
				# optional parsing for wider than tall
                        	# print "wider than taller $height x $width $target\n";
                        	system ("mogrify -scale x$scale  $target");
                	} else {
				# no special processing yet for taller than wide
                        	system ("mogrify -scale x$scale  $target");
                	}
		}
	}
}

