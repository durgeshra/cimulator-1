%{
package main
import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"log"
	"math/big"
	"os"
	"unicode/utf8"
)

// int is an array of variables that stores their corresponding values
var symbols [52]int
%}

%union {
	Num int
	Id rune
}

%token	<Num>NUM
%token	<Id>VAR
%type 	<Num>EXP TERM LINE
%type	<Num>ASSIGN

%token '+' '='

%%

LINE
	: ASSIGN	{}
	| LINE ASSIGN	{}
ASSIGN
	: VAR '=' EXP	{ updateSymbolVal($1, $3); fmt.Printf("%c = %d\n",$1,$3) }
EXP
	: TERM  {}
	| EXP '+' TERM	{ $$=$1+$3 }
TERM
	: NUM	{ $$=$1 }
	| VAR	{ $$=symbolVal($1) }


%%

// computeSymbolIndex computes index from symbol,
// 0-25 are capital letters and next 26 are small
func computeSymbolIndex(token rune) int {
	var idx int
	idx = -1
	if token>='a' && token<='z' {
		idx = int(token - 'a' + 26)
	} else if token>='A' && token<='Z' {
		idx = int(token - 'A')
	}
	return idx
}

// symbolVal returns the value of symbol.
func symbolVal(symbol rune) int {
	var bucket int
	bucket = computeSymbolIndex(symbol)
	return symbols[bucket]
}

// updateSymbolVal updates value of symbol on assignment.
func updateSymbolVal(symbol rune, val int) {
	var bucket int
	bucket = computeSymbolIndex(symbol)
	symbols[bucket] = val
}

func main() {
	if len(os.Args) < 2 {
		fmt.Printf("USAGE: %s filename\n", filepath.Base(os.Args[0]))
		os.Exit(1)
	}
	content, err := ioutil.ReadFile(os.Args[1])

	if err != nil {
		log.Fatalln("Unable to read file:", err)
	}
	lexer := &cimLex{
		source: content,
	}

	// Value of variables by default is 0
	for i := 0; i < 52; i++ {
		symbols[i] = 0
	}

	cimParse(lexer)

}
