package main

import (
	"os"
	"testing"
)

func TestMain(m *testing.M) {
	os.Exec("mkdir build")
	os.Exit(m.Run())
}
