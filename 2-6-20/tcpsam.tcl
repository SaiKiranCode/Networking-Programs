set ns [new Simulator]
$ns color 1 Blue
set tracefile [open out.tr w]
$ns trace-all $tracefile

set namfile [open out.nam w]
$ns namtrace-all $namfile

proc finish {} {
     global ns tracefile
     $ns flush-trace
     close $tracefile
     exit 0
}
set n0 [$ns node]
set n1 [$ns node]
$ns duplex-link $n0 $n1 2Mb 20ms DropTail

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 1.0 "$ftp start"
$ns at 9.0 "$ftp stop"
$ns at 10.0 "finish"

$ns run
