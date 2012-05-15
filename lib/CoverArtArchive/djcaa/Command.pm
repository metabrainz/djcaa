package CoverArtArchive::djcaa::Command;
use Moose;

extends 'MooseX::App::Cmd::Command';

use Config::Tiny;
use Net::Amazon::S3;

has config_path => (
    isa => 'Str',
    is => 'ro',
    required => 1,
    traits => [ 'Getopt' ],
    cmd_aliases => [ 'config' ],
    default => 'config.ini'
);

has config => (
    is => 'ro',
    lazy => 1,
    traits => [ 'NoGetopt' ],
    default => sub {
        my $config_file = shift->config_path;
        die "Could not read $config_file" unless -f $config_file;

        return Config::Tiny->read($config_file);
    }
);

has s3 => (
    is => 'ro',
    lazy => 1,
    traits => [ 'NoGetopt' ],
    default => sub {
        my $self = shift;
        return Net::Amazon::S3->new(
            aws_access_key_id     => $self->config->{caa}{public_key},
            aws_secret_access_key => $self->config->{caa}{private_key}
        );
    }
);

1;
