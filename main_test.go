package main

import "testing"

func TestFour(t *testing.T) {
	if got, want := four(), 4; got != want {
		t.Errorf("four() returns incorrect value. Got: %v, Want: %v", got, want)
	}
}
