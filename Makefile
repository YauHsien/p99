phony: unit

unit:
	swipl -g unit_test -l src/p99.pl -l src/unit-test.pl
