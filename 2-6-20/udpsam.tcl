set ns [new Simulator]
$ns color 2 Red

set tracefile [open out.tr w]
$ns trace-all $tracefile

set namfile [open out.nam w]
$ns namtrace-all $namfile

# define finish procedure
proc finish {} {
     global ns tracefile
     $ns flush-trace
     close $tracefile
     exit 0
}

set n0 [$ns node]
set n1 [$ns node]
$ns duplex-link $n0 $n1 2Mb 10ms DropTail

set udp [new Agent/UDP]
$ns attach-agent $n0 $udp
set null [new Agent/Null]
$ns attach-agent $n1 $null
$ns connect $udp $null
$udp set fid_ 2
                                                                                                                                                                                                                                                                                                                           
# setup CBR over UDP
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packetSize_ 1000
$cbr set rate_ 0.01Mb
$cbr set random_ false

$ns at 0.5 "$cbr start"
$ns at 9.5 "$cbr stop"
$ns at 10.0 "finish"

$ns run





