# addAnchors.pl -- add anchors to a file.

use strict;

my $inputFile   = $ARGV[0];

my $idPrefix = "a";
my $pageNumber = 0;
my $lineNumber = 0;
my $addLineNumbers = 0;

open(INPUTFILE, $inputFile) || die("Could not open $inputFile");

while (<INPUTFILE>)
{
    my $line = $_;

    if ($line =~ /<!-- BEGIN ICELANDIC TEXT -->/) {
        # print STDERR "BEGIN\n";
        $addLineNumbers = 1;
    }

    if ($line =~ /<!-- END ICELANDIC TEXT -->/) {
        # print STDERR "END\n";
        $addLineNumbers = 0;
    }

    if ($line =~ /<pb(.*?)>/) {
        my $attrs = $1;
        $pageNumber = getAttrVal("n", $attrs);
        $lineNumber = 1;
    }

    if ($line =~ /<ab type=lineNum>([0-9]+).*<\/ab>/) {
        $lineNumber = $1;
    }

    if ($addLineNumbers == 1) {

        if ($line !~ /^\s*$/ && 
            $line !~ /<div/ && 
            $line !~ /<head/ && 
            $line !~ /<item/ && 
            $line !~ /^<pb(.*?)>$/ && 
            $line !~ /<\/?list(.*?)>/ && 
            $line !~ /<\/?lg(.*?)>/ && 
            $line !~ /<note place=margin>\[.*?\]<\/note>$/ &&
            $line !~ /<milestone unit=tb>/ &&
            $line !~ /<!-- BEGIN ICELANDIC TEXT -->/) {

            if ($line =~ /<([pl])\b(.*?)>/) {
                my $before = $`;
                my $tag = $1;
                my $attrs = $2;
                my $after = $';
                print "$before<$tag$attrs><anchor id=$idPrefix$pageNumber.$lineNumber>$after";
            } else {
                print "<anchor id=$idPrefix$pageNumber.$lineNumber>$line";
            }
            $lineNumber++;
        } else {
            print $line;
        }
    } else {
        print $line;
    }
}


#
# getAttrVal: Get an attribute value from a tag (if the attribute is present)
#
sub getAttrVal($$)
{
    my $attrName = shift;
    my $attrs = shift;
    my $attrVal = "";

    if ($attrs =~ /$attrName\s*=\s*([\w.]+)/i)
    {
        $attrVal = $1;
    }
    elsif ($attrs =~ /$attrName\s*=\s*\"(.*?)\"/i)
    {
        $attrVal = $1;
    }
    return $attrVal;
}
