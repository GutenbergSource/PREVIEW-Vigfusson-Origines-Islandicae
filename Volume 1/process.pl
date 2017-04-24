# process.pl -- Process Vigfusson's Origines Islandicae.

use strict;
use warnings;
use FindBin qw($Bin);

my $filename = "OriginesIslandicae1-0.5.tei";

sub processFile($) {
    my $filename = shift;
    $filename =~ m/^([A-Za-z0-9-]*?)(-[0-9.]+?)\.tei$/;
    my $basename = $1;
    my $version = $2;
    my $outputFile = $basename . "-txt-0.5.tei";
    processText($filename, $outputFile);
    system ("perl -S tei2html.pl -u -t $outputFile");
}

processFile($filename);

sub processText($) {
    my $inputFile = shift;
    my $outputFile = shift;

    # Replace: "<ab type=lineNum>5.</ab>" -> " {5.} ".

    open(INPUTFILE, $inputFile) || die("Could not open input file $inputFile");
    open(OUTPUTFILE, "> $outputFile") || die("Could not open output file $outputFile");

    while (<INPUTFILE>) {
        $_ =~ s/\<ab type=lineNum>([0-9]+\.?)<\/ab>/ {$1}/g;
        $_ =~ s/\<pb id=pb[0-9a-z]+ n=([0-9]+)>/{p. $1} /g;
        print OUTPUTFILE;
    }
}