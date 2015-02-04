.phony: load console unit run

load:
	swipl -g halt -l src/p99.pl

#run:
#	swipl -g $(filter-out $@, $(MAKECMDGOALS)),halt -l src/p99.pl

console:
	swipl -L0 -l src/p99.pl

unit:
	swipl -L0 -g unit_test:unit_test -l src/p99.pl -l src/unit-test.pl
