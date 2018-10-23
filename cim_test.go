package main

import "testing"

func TestParse(t *testing.T) {

	_, output = parse([]byte("a = 4\nb = a + 3\n"))
	expected := "a=4\nb=7\n"

	if output != expected {
		t.Errorf("parse function returns incorrect value. Got: %v, Want: %v", output, expected)
	}
}
