package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
)

// four justs returns 4.
func four() int {
	return 4
}

func main() {
	fmt.Printf("Hello, world!\n")

	var data []byte
	var err error

	if len(os.Args) == 2 {
		data, err = ioutil.ReadFile(os.Args[1])
	} else {
		log.Fatalf("Number of commands should be 2, is %d", len(os.Args))
	}

	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("File read successfully.\nContents:\n%s", data)

}
