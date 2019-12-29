package jgo

import "testing"

var tests = []struct {
	name, expected string
}{
	{"", "Hello, you."},
	{"Alice", "Hello, Alice."},
	{"Bob", "Hello, Bob."},
}

func TestHello(t *testing.T) {
	for _, test := range tests {
		if observed := Hello(test.name); observed != test.expected {
			t.Fatalf("Hello(%s) = \"%v\", want \"%v\"", test.name, observed, test.expected)
		}
	}
}
