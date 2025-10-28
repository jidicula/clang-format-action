# test/test-install-clang-format.bats
#!/usr/bin/env bats

setup() {
	load ../install-clang-format.sh
}

@test "extract_major_version handles numeric versions" {
	run extract_major_version "18"
	[ "$status" -eq 0 ]
	[ "$output" = "18" ]
}

@test "extract_major_version handles complex versions" {
	run extract_major_version "18.1.0"
	[ "$status" -eq 0 ]
	[ "$output" = "18" ]

	run extract_major_version "12.0.1"
	[ "$status" -eq 0 ]
	[ "$output" = "12" ]

	run extract_major_version "9.0.0"
	[ "$status" -eq 0 ]
	[ "$output" = "9" ]

	run extract_major_version "10.2"
	[ "$status" -eq 0 ]
	[ "$output" = "10" ]

	run extract_major_version "3.9"
	[ "$status" -eq 0 ]
	[ "$output" = "3" ]
}

@test "extract_major_version handles non-numeric versions" {
	run extract_major_version "latest"
	[ "$status" -eq 0 ]
	[ "$output" = "" ]
}
