set ns [new Simulator]
set tracefile [open out.tr w]
 $ns trace-all $tracefile
 set namfile [open out.nam w]
 $ns namtrace-all $namfile

