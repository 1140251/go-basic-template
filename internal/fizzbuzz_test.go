package internal

import "testing"

func TestFizzbuzz(t *testing.T) {
	tests := []struct {
		name    string
		numbers []int
		want    string
	}{
		{
			"displayNumber", []int{1, 2, 4, 8}, "",
		},
		{
			"displayFizz", []int{3, 6, 9, 12}, "fizz",
		},
		{
			"displayBuzz", []int{5, 10, 20}, "buzz",
		},
		{
			"displayFizzBuzz", []int{15, 30, 45}, "fizzbuzz",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			for _, number := range tt.numbers {
				if got := Fizzbuzz(number); got != tt.want {
					t.Errorf("Fizzbuzz() = %v, want %v", got, tt.want)
				}
			}

		})
	}
}
