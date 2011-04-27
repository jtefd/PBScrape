use Test::More;

BEGIN { 
	use_ok('Getopt::Long');
	use_ok('HTML::TreeBuilder');
	use_ok('LWP::UserAgent'); 
	use_ok('Pod::Usage');
}

done_testing();