package main

import "testing"

func TestParse(t *testing.T) {

	_, output = parse([]byte("int a = 4;\nint b;\nb=3;\na = a + b;\n"))
	expected := "int a=4\nint b\nb=3\na=7\n"

	if output != expected {
		t.Errorf("parse function returns incorrect value. Got: %v, Want: %v", output, expected)
	}
}
