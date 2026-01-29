from org.transcrypt.stubs.browser import *
import random

def gen_random_int(number, seed):
	record = []
	random.seed(seed)
	for digit in range(number):
		record.append(digit)
	random.shuffle(record)
	return record


def generate():
	number = 10
	seed = 200
	array = gen_random_int(number, seed)
	array_str = ', '.join(array)	
	document.getElementById("generate").innerHTML = array_str


# Bubble Sort chosen as sorting method for simplicity of implementation for small count of numbers.
def bubble_sort(array: list[int]) -> list[int]:
	n = len(array) - 1 #Exclude the last variable as we are comparing the current index with the one ahead in the list
	sorted = False #Local variable to be used throughout the function
	while not sorted:
		sorted = True #Deactivates the sorting on the next step if array no longer needs to be sorted
		for idx in range(0, n):
				if array[idx] > array[idx + 1]:
					sorted = False #Reactivates the sorting function once it finds that its been unsorted
					array[idx], array[idx + 1] = array[idx + 1], array[idx]
	return array


# New function made to abstract away repeated steps in sortnumber1() & sortnumber2()
def processed_numbers(string: str) -> str:
	array = string.split(",")#Conversion from string to an array
	cleaned_array = [int(item.strip()) for item in array] #Removes any trailing or leading spaces in the list
	sorted_array = bubble_sort(cleaned_array)
	final_string = ', '.join(map(str, sorted_array)) + "." #Converts the array back into a string for printing
	return final_string


def sortnumber1():
	old_string = document.getElementById("generate").innerHTML
	array_str = processed_numbers(old_string)
	document.getElementById("sorted").innerHTML = array_str


def sortnumber2():
	# The following line get the value of the text input called "numbers"
	value = document.getElementsByName("numbers")[0].value

	# Throw alert and stop if nothing in the text input
	if value == "":
		window.alert("Your textbox is empty")
		return

	array_str = processed_numbers(value)
	document.getElementById("sorted").innerHTML = array_str