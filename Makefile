.PHONY: get gen format analyze test check

get:
	flutter pub get

gen:
	dart run build_runner build --delete-conflicting-outputs

format:
	dart format .

analyze:
	flutter analyze

test:
	flutter test

check: get gen format analyze test
