LanRouter set debug_ 0
set ns [new Simulator]
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
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

set lan [$ns newLan "$n0 $n1 $n2 $n3 $n4 $n5 $n6" 1Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel]

$ns duplex-link $n0 $n7 1.0Mb 50ms DropTail

set udp [new Agent/UDP]
$ns attach-agent $n7 $udp
set null [new Agent/Null]

$ns attach-agent $n6 $null
$ns connect $udp $null


set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 0.5Mb
$cbr set random_ false


$ns at 0.5 "$cbr start"
$ns at 24.5 "$cbr stop"
$ns at 25.0 "finish"

$ns run

