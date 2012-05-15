package CoverArtArchive::djcaa;
use Moose;

extends qw(MooseX::App::Cmd);

use Moose::Util qw( ensure_all_roles );
use Net::Amazon::S3::HTTPRequest;

Net::Amazon::S3::HTTPRequest->meta->make_mutable;
ensure_all_roles('Net::Amazon::S3::HTTPRequest', 'CoverArtArchive::IAS3Request');

1;
