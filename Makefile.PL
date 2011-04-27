use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'PBScrape',
    VERSION_FROM      => 'pbscrape.pl', # finds $VERSION
    PREREQ_PM         => { }, 
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT       => 'Search interface for the PirateBay',
       AUTHOR         => 'James Telford <james@tefd.co.uk>') : ()),
    EXE_FILES         => [ 'pbscrape.pl' ],
);
