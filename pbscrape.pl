#!/usr/bin/env perl

=pod

=head1 NAME

pbscrape

=head1 SYNOPSIS

pbscrape [--get-latest | -g ] "my torrent search"

=head1 OPTIONS

=over 8

List the top seeded torrents for the given search query

=item B<--get-latest | -g>

Get the number 1 top seeded torrent for the given search query

=item B<--directory | -d>

The directory in which to store the torrent file (defaults to current directory)

=back

=head1 DESCRIPTION

This application provides a simple interface to searching for the top
seeded torrent files on The Pirate Bay website.

=cut

use strict;
use warnings;

use File::Spec::Functions qw/catfile/;
use Getopt::Long;
use HTML::TreeBuilder;
use LWP::UserAgent;
use Pod::Usage;

use constant SEARCH_URL => 'http://thepiratebay.org/search/%s/0/7/0';

use vars qw/$VERSION/;

$VERSION = '0.1.0';

my %opts = ();

GetOptions(
    \%opts,
    'get-latest|g',
    'directory|d',
    'help|h|?'
);

if ($opts{'help'}) {
	pod2usage(-verbose => 1, -exitval => 0);
}

my $query = join(' ', @ARGV) || pod2usage(-verbose => 1, -exitval => 1);

my $query_url = sprintf(SEARCH_URL, $query);

my $ua = LWP::UserAgent->new();

my $response = $ua->get($query_url);

my $tree = HTML::TreeBuilder->new_from_content($response->content);

foreach (@{$tree->extract_links('a', 'href')}) {
    my $link = shift @{$_};
    
    if ($link =~ /\.torrent$/) {
    	my $filename = pop @{[split('/', $link)]};
    	
        if ($opts{'get-latest'}) {
            $response = $ua->get($link);
            
            if ($opts{'directory'} && -d $opts{'directory'}) {
            	$filename = catfile($opts{'directory'}, $filename);
            }
            
            open FILE, ">$filename";
            binmode FILE;
            print FILE $response->content;
            close FILE;
            
            last;	
        }
        else {
            $filename =~ s/\.torrent$//;
        
            print $filename, "\n";	
    	}
    }  
}