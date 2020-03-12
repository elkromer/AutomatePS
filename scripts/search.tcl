proc on_visit {path} {
    puts $path
}

proc visit {base glob func} {
  if {[catch {
    foreach f [glob -nocomplain -types f -directory $base $glob] {
        eval $func [list [file join $base $f]]
    }
    foreach d [glob -nocomplain -types d -directory $base *] {
        visit [file join $base $d] $glob $func
    }
  } err]} {
    # puts stderr "error: $err" # Happens all the time when searching C:\Windows
  }

}

proc main {base filter} {
    visit $base $filter [list on_visit]
}

main [lindex $argv 0] [lindex $argv 1]