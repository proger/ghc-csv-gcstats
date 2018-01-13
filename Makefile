
gcstats.csv: gcstats
	awk -f csv-gcstats.awk $< > $@

gcstats: Benchmark
	./Benchmark 1000000 +RTS -S -vgt 2>gcstats

Benchmark: Benchmark.hs
	stack exec -- ghc -O2 -optc-O3 -rtsopts=all -eventlog -debug -fforce-recomp Benchmark.hs
