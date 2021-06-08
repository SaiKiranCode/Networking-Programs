set val(file_size)	[expr 4*1024*1024]	;     #  Send a file of size 4 MB
LanRouter set debug_ 0
set ns [new Simulator]

# Open tracefile
set tracefile [open out.tr w]
$ns trace-all $tracefile
set namfile [open out.nam w]
$ns namtrace-all $namfile

# Define the finish procedure
proc finish {} {
    global ns tracefile
    $ns flush-trace
    close $tracefile
    exit 0
}

# Create six nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

# Create links between the nodes
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns simplex-link $n2 $n3 0.3Mb 100ms DropTail
$ns simplex-link $n3 $n2 0.3Mb 100ms DropTail

# Set queue size of link(n2-n3) to 20
$ns queue-limit $n2 $n3 20

# Set up the LAN
set lan [$ns newLan "$n3 $n4 $n5 $n6" 0.5Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel]

# Set error model
set loss_module [new ErrorModel]
$loss_module set rate_ 0.2
$loss_module ranvar [new RandomVariable/Uniform]
$loss_module drop-target [new Agent/Null]
$ns lossmodel $loss_module $n2 $n3

# Setup TCP connection
set tcp [new Agent/TCP]
$ns attach-agent $n1 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n5 $sink
$ns connect $tcp $sink
$tcp set packet_size_ 1500

# Set ftp over tcp connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp

# Scheduling the events
$ns at 1.5 "$ftp send $val(file_size)"

$ns at 2000.0 "finish"

$ns run

Close 
