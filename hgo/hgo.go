package main

import (
	"fmt"
	"log"
	"git.fury.io/furynix/jgo"
	"github.com/google/uuid"
)

func Hello(name string) string {
	if name == "" {
		name = "you"
	}

	return fmt.Sprintf("%s How are you?", jgo.Hello(name))
}

func main() {
	uid, err := uuid.NewUUID()

	if err == nil {
		fmt.Printf("%s Your UUID is: %s\n", Hello("Mark"), uid.String())
	} else {
		log.Fatalf("UUID generation failed")
	}
}
