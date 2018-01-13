#
# Converts GHC RTS output enabled by +RTS -S -vgt into a csv
#

#
# Fields:
#
# Timestamp          - Nanoseconds since start, inferred from -vgt output.
# Alloc-bytes        - How many bytes we allocated this garbage collection.
# Copied-bytes       - How many bytes we copied this garbage collection.
# Live-bytes         - How many bytes are currently live.
# GC-user, GC-elap   - How long this garbage collection took (CPU time and elapsed wall clock time).
# TOT-user, TOT-elap - How long the program has been running (CPU time and elapsed wall clock time).
# Page               - How many page faults occurred this garbage collection.
# Flts               - How many page faults occurred since the end of the last garbage collection.
# Gen                - Which generation is being garbage collected.
#
#
# Legend taken from:
# https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/runtime_control.html#rts-options-to-produce-runtime-statistics
# Timestamp info: https://github.com/haskell/ghc-events/blob/8ff5c1d15aa70a7e35afa0e977b5b7fbaca78051/include/EventLogFormat.h#L302

#
# R import, assuming there are two generations:
#
# library(readr)
# gcstats <- read_csv("gcstats.csv", col_types = cols(Gen = col_factor(levels = c("0", "1"))))
#

BEGIN { OFS="," }
NR==1 { split($0, headers); next }
NR==2 {
  split($0, units);
  oORS=ORS; ORS=OFS;

  print "Timestamp";
  for (k = 1; k <= length(headers); k++) {
    print headers[k] (units[k] ? "-" units[k] : "")
  }
  ORS=oORS;
  print "Gen";
  next
}

/finished GC/ {
  timestamp = substr($1, 1, length($1)-1);
}

NF==11 {
  oORS=ORS; ORS=OFS;

  print timestamp;

  # all but last two fields
  for (k = 1; k < NF-1; k++) {
    print $k
  }

  ORS=oORS;

  # Generation number
  gen = substr($(NF), 1, 1);
  print gen;
}

/bytes allocated on the heap/ {exit}
