set val(stop)   150.0;
set val(file_size)	[expr 10*1024*1024];    
set ns [new Simulator]
$ns color 1 Blue
#Open the NS trace file
set tracefile [open ftp.tr w]
$ns trace-all $tracefile
set namfile [open out.nam w]
$ns namtrace-all $namfile
set n0 [$ns node]
set n1 [$ns node]
$ns duplex-link $n0 $n1 5.0Mb 50ms DropTail
$ns queue-limit $n0 $n1 10


set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
$ns connect $tcp0 $sink1
$tcp0 set packetSize_ 1500
$tcp0 set fid_ 1

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP

$ns at 1.5 "$ftp0 send $val(file_size)"	

proc finish {} {
    global ns tracefile
    $ns flush-trace
    close $tracefile
    exit 0
}


$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"

$ns run

