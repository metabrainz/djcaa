package CoverArtArchive::djcaa::Command::FindEmpty;
use Moose;
use 5.10.0;

extends 'CoverArtArchive::djcaa::Command';

use LWP::UserAgent;
use XML::XPath;

sub command_names { qw( find-empty ) }
sub usage_desc { 'djcaa find-empty' }
sub description {
    "Find buckets that do not contain any images"
}
sub options { () }
sub validate { }

sub execute {
    my ($self) = @_;
    say STDERR "Finding empty buckets...";

    my $http_request
        = Net::Amazon::S3::Request::ListAllMyBuckets->new( s3 => $self->s3 )
            ->http_request;

    my $lwp = LWP::UserAgent->new();
    my $response = $lwp->request($http_request);

    my $xp = XML::XPath->new( xml => $response->decoded_content );
    for my $bucket (map { $_->string_value } $xp->findnodes(".//Bucket/Name")) {
        $http_request = Net::Amazon::S3::Request::ListBucket->new(
            s3        => $self->s3,
            bucket    => $bucket,
        )->http_request;

        $response = $lwp->request($http_request);

        my $bucket_xp = XML::XPath->new( xml => $response->decoded_content );
        my @items = map { $_->string_value } $bucket_xp->findnodes(".//Contents/Key")
            or next;

        my @interesting_items = grep { $_ !~ /^(index.json|_thumb.jpg)/ } @items;

        if (@interesting_items == 0) {
            say $bucket;
        }
    }
}

1;
