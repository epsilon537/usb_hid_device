\ Application
module[ application"

false constant DEBUG

include usb-defs.fs
include io-access.fs
include descriptors.fs
include device.fs

ROM
: main ( --)
    begin  do-transfer  again ;

]module
