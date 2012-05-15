use strict;
use warnings;
use inc::Module::Install;

name 'CoverArtArchive-djcaa';
version '1.0';

requires 'App::Cmd';
requires 'Net::Amazon::S3';

auto_install;
WriteAll;
