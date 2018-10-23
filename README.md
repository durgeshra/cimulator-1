# cimulator

[![Build Status](https://travis-ci.org/cimulator/cimulator.svg?branch=master)](https://travis-ci.org/cimulator/cimulator)

To Install Dependencies:

`go get -u golang.org/x/tools/cmd/goyacc`
`go get -u golang.org/x/tools/cmd/goimports`

To Build:

```
git clone git@github.com:cimulator/cimulator.git
cd cimulator
mkdir build
go generate
```

To run:

```
cd build
go run *.go input.txt
```
where input.txt can be:
```
a = 4
b = a + 3
```