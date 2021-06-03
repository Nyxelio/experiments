#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  test.pl
#
#        USAGE:  ./test.pl 
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  [], <>
#      COMPANY:  
#      VERSION:  0.1
#      CREATED:  27/11/2012 22:30:41 CET
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use HTTP::Proxy;
use HTTP::Recorder;

my $proxy = HTTP::Proxy->new( port => 3128 );

# create a new HTTP::Recorder object
my $agent = new HTTP::Recorder;

# set the log file (optional)
$agent->file("/tmp/myfile");

# set HTTP::Recorder as the agent for the proxy
$proxy->agent( $agent );

# start the proxy
$proxy->start();

1;

