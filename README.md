# makednp
C64 tools for packing and unpacking DNP and D64 image files.

The files ending in .o are executable programs, assembled from their .a source code files, in TurboMacroPro format. 

The files ending in .asm are text exports of the binary TMP formatted files.

makednp.o - creates a DNP image from a native partition

maked64.o - creates a D64 image from a 1541 drive or a 1541 emulation mode partition

unpackdnp.o - unpacks a DNP image to a native partition

makedxx.note - a BASIC program with notes for how to use these programs. 

# makedXX Usage

Use JiffyDOS @x to set destination number

Use JiffyDOS @# to set source device number

Use JiffyDOS @cp to set the current partition on both the source and destination devices.

Load and run makednp.o if the source device/partition is native mode

Load and run maked64.o if the source device/partition is 1541 or 1541 emulation mode

Creates/overwrites standard file named "image.dnp" or "image.d64" in the current directory and partition of the destination device.

# unpackdnp Usage

Use JiffyDOS @x to set destination number

Use JiffyDOS @# to set source device number

Use JiffyDOS @cp to set the current partition on both the source and destination devices.

Load and run unpackdnp.o to unpack a file named "image.dnp" from the current directory and partition of the source device, to the current native mode partition in the destination device.

