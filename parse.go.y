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
	"strconv"
)

type variable struct {
	datatype string
	varname string
	val int
}

var decl []variable

// int is an array of variables that stores their corresponding values
var output string

%}

%union {
	Num int
	Id string
	Datatype string
}

%token		<Num>NUM
%token		<Id>VARNAME
%token		<Datatype>DATATYPE
%type		<Num>EXP TERM LINE DECL
%type		<Num>ASSIGN

%token '+' '-' '*' '=' ';'

%%

LINE
	: DECL	{}
	| ASSIGN	{}
	| LINE DECL	{}
	| LINE ASSIGN	{}
ASSIGN
	: VARNAME '=' EXP ';'	{ modifyVar($1, $3); output = output + string($1) + "=" + strconv.Itoa($3) + "\n" }
DECL
	: DATATYPE VARNAME '=' EXP ';' { declSymbol($1, $2, $4); output = output + string($1) + " " + string($2) + "=" + strconv.Itoa($4) + "\n" }
	| DATATYPE VARNAME ';'  { declSymbol($1, $2, 0); output = output + string($1) + " " + string($2)+ "\n" }
EXP
	: TERM	{}
	| EXP '+' TERM	{ $$=$1+$3 }
	| EXP '-' TERM	{ $$=$1-$3 }
	| EXP '*' TERM	{ $$=$1*$3 }
TERM
	: NUM	{ $$=$1 }
	| VARNAME	{ $$=valOfVar($1) }


%%

//isDeclared checks if variable has been declared or not
func isDeclared(newVar string, arr []variable) bool {
	for _, b := range arr {
  	if b.varname == newVar {
    	return true
			}
		}
  return false
}

// ValOfVar returns value of variable.
func valOfVar(varname string) int {
	for _, b := range decl {
		if b.varname == varname {
			return b.val
		}
	}
	fmt.Printf("Variable %s is undeclared.", varname)
	os.Exit(1)
	return 0
}

func declSymbol(datatype string, varname string, val int) int {
	if isDeclared(varname, decl) {
		fmt.Printf("Variable %s has already been declared.", varname)
		os.Exit(1)
	} else {
		decl = append(decl, variable{datatype, varname, val})
	}
	return val
}

// modifyVar updates value of symbol on assignment.
func modifyVar(varname string, val int) int {
	for a, b := range decl {
		if b.varname == varname {
			decl[a].val = val
			return val
			}
		}
	fmt.Printf("Variable %s is undeclared.", varname)
	os.Exit(1)
	return 0
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

	parse(content)
	fmt.Println(output)
}

func parse(content []byte) (int, string) {


	lexer := &cimLex{
		source: content,
	}
	return cimParse(lexer), output

}
