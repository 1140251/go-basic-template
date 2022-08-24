package internal

func Fizzbuzz(i int) (text string) {
	fizz := i%3 == 0
	buzz := i%5 == 0

	if fizz && buzz {
		return "fizzbuzz"
	} else if fizz {
		return "fizz"
	} else if buzz {
		return "buzz"
	} else {
		return ""
	}
}
