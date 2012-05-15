# djcaa

djcaa is a maintainance tool for the Cover Art Archive, named after the
MusicBrainz sysadmin djce.

djcaa can do a few things, each of which are separate commands:

## djcaa find-empty

Finds buckets that have no images in.

## djcaa nuke [bucket]

Delete all files in a single bucket. This will not run if the bucket contains
any images.

Without any arguments, this command reads from standard input, allowing you to
pipe the output of find-empty into it:

    djcaa find-empty | djcaa nuke
