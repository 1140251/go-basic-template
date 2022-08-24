package main

import (
	"fmt"
	"go-basic-template/internal"
)

func main() {
	for i := 0; i <= 100; i++ {
		fmt.Printf("%s\n", internal.Fizzbuzz(i))
	}
}
