package main

import "testing"

var tests = []struct {
	name, expected string
}{
	{"", "Hello, you. How are you?"},
	{"Alice", "Hello, Alice. How are you?"},
	{"Bob", "Hello, Bob. How are you?"},
}

func TestHello(t *testing.T) {
	for _, test := range tests {
		if observed := Hello(test.name); observed != test.expected {
			t.Fatalf("Hello(%s) = \"%v\", want \"%v\"", test.name, observed, test.expected)
		}
	}
}
