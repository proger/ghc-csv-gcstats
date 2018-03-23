# use inside nix-shell or redefine to smth like 'stack exec -- ghc'
GHC ?= ghc

gcstats.csv: gcstats
	awk -f csv-gcstats.awk $< > $@

gcstats: Benchmark
	./Benchmark 1000000 +RTS -S -vgt 2>gcstats

Benchmark: Benchmark.hs
	$(GHC) -g -O2 -optc-O3 -rtsopts=all -eventlog -debug -fforce-recomp Benchmark.hs
