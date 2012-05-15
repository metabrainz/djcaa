# djcaa

djcaa is a maintainance tool for the Cover Art Archive, named after the
MusicBrainz sysadmin djce.

djcaa can do a few things, each of which are separate commands:

## djcaa find-orphans

Finds images that are orphaned. Orphaned means the image exists in the file
store, but there is no corresponding row in the `cover_art_archive.cover_art`
table.
