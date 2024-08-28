#!/usr/bin/expect
spawn ftp 159.107.220.96
expect "netsim):"
send "simadmin\r"
expect "Password:"
send "simadmin\r"
expect "ftp> "
send "cd /xharidu/GRAN_NRM5new/\r"
expect "ftp> "
send $env(ftpCmd)\r
expect "ftp> "
puts $expect_out(buffer)
