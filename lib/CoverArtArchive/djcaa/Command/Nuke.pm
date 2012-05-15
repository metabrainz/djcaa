package CoverArtArchive::djcaa::Command::Nuke;
use Moose;
use 5.10.0;

extends 'CoverArtArchive::djcaa::Command';

use LWP::UserAgent;
use XML::XPath;

sub command_names { qw( nuke ) }
sub usage_desc { 'djcaa nuke [bucket | -]' }
sub description {
    "Remove all files in a bucket"
}
sub options { () }
sub validate { }

sub execute {
    my ($self, $opts, $args) = @_;

    if (@$args) {
        $self->_nuke($_) for @$args;
    }
    else {
        while(my $bucket = <STDIN>) {
            chomp($bucket);
            $self->_nuke($bucket);
        }
    }
}

sub _nuke {
    my ($self, $bucket) = @_;

    state $lwp = LWP::UserAgent->new;

    my $response = $lwp->request(
        Net::Amazon::S3::Request::ListBucket->new(
            s3        => $self->s3,
            bucket    => $bucket,
        )->http_request
    );
    my $xp = XML::XPath->new( xml => $response->decoded_content );

    my @files = map { $_->string_value } $xp->findnodes('.//Contents/Key');

    if (grep { $_ =~ /\d+\.jpg/ } @files) {
        say "This bucket contains images, please run with --dangerous if you are certain this is correct";
        return;
    }
    else {
        say "Nuking $bucket";
    }

    for my $file (@files) {
        $lwp->request(
            Net::Amazon::S3::Request::DeleteObject(
                s3 => $self->s3,
                bucket => $bucket,
                key => $file
            )->http_request
        );
    }
}

1;
