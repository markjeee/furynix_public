package jgo

import "fmt"

func Hello(name string) string {
	if name == "" {
		name = "you"
	}

	return fmt.Sprintf("Hello, %s.", name)
}
