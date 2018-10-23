// Package main is a lexer for integers, variables and operators.
package main

import (
	"log"
	"regexp"
	"strconv"
	"unicode"
	"unicode/utf8"
)

//go:generate goyacc -o build/cim.go -p cim parse.go.y
//go:generate bash -c "cp *.go build && mv y.output build"
//go:generate bash -c "gofmt -s -w ./build/*.go"
//go:generate bash -c "goimports -w ./build/*.go"
//go:generate bash -c "gofmt -s -w ./build/*.go"

type cimLex struct {
	source []byte
	peek   rune
}

// The parser expects the lexer to return 0 on EOF. Give it a name for clarity.
const eof = 0

var Regex = map[int]*regexp.Regexp{}

// init specifies regex for variables and numerals.
func init() {
	Regex[NUM] = regexp.MustCompile(`^[0-9][0-9\.eE]*`)
	Regex[VAR] = regexp.MustCompile(`^[a-zA-Z]`)
}

// next returns the next rune for the lexer.
func (x *cimLex) next() rune {
	if x.peek != eof {
		r := x.peek
		x.peek = eof
		return r
	}
	if len(x.source) == 0 {
		return eof
	}
	c, size := utf8.DecodeRune(x.source)
	if c == utf8.RuneError && size == 1 {
		log.Print("invalid utf8")
		return x.next()
	}
	return c
}

// fromRegex returns matched string.
func (x *cimLex) fromRegex(ret int, yylval *cimSymType) string {
	out := Regex[ret].Find(x.source)
	if len(out) == 0 {
		log.Fatal("Failed parse at: ", x.source[:10], "...")
	}
	x.source = x.source[len(out):]
	return string(out)
}

// variable lexes a variable.
func (x *cimLex) variable(yylval *cimSymType) int {
	v := x.fromRegex(VAR, yylval)
	yylval.Id = rune(v[0])
	return VAR
}

// num lexes a number.
func (x *cimLex) num(yylval *cimSymType) int {
	b := x.fromRegex(NUM, yylval)
	a, err := strconv.Atoi(b)
	if err != nil {
		log.Printf("bad number %q", b)
		return eof
	}
	yylval.Num = a
	return NUM
}

// Lex is called by the parser to get each new token. This implementation
// returns operators and NUM.
func (x *cimLex) Lex(yylval *cimSymType) int {
	for {
		c := x.next()
		switch {
		case c == eof:
			return eof
		case InSlice(c, []rune("0123456789")):
			return x.num(yylval)
		case InSlice(c, []rune("+=")):
			x.source = x.source[size(c):]
			return int(c)

		case unicode.IsLetter(c):
			return x.variable(yylval)
		case InSlice(c, []rune(" \t\n\r")):
			x.source = x.source[size(c):]
		default:
			log.Printf("unrecognized character %q", c)
		}
	}
}

func size(r rune) int {
	return len(string(r))
}

// Error is called by the parser on a parse error.
func (x *cimLex) Error(s string) {
	log.Printf("parse error: %s", s)
}
