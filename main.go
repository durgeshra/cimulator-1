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

	data, err := ioutil.ReadFile(os.Args[1])

	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("File read successfully.\nContents:\n")
	fmt.Printf(string(data))

}
