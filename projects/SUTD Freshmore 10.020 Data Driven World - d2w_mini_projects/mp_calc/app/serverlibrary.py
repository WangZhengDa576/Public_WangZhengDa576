def mergesort(array:list, byfunc=None) -> None:
    # splitting the array
    if len(array) > 1:
        left_array = array[:len(array)//2]
        right_array = array[len(array)//2:]
        
        
        # recursion
        mergesort(left_array, byfunc)
        mergesort(right_array, byfunc)
        
        # merge
        i = 0 # keep track of leftmost element in left_array
        j = 0 # keep track of leftmost element in right_array
        k = 0 # keep track of leftmost element in the merged array
        
        get_key = byfunc if byfunc is not None else (lambda x: x)
        
        while i < len(left_array) and j < len(right_array):
            if get_key(left_array[i]) < get_key(right_array[j]):
                array[k] = left_array[i]
                i += 1
            else:
                array[k] = right_array[j]
                j += 1
            k += 1
            
        while i < len(left_array):
            array[k] = left_array[i]
            i += 1
            k += 1
            
        while j < len(right_array):
            array[k] = right_array[j]
            j += 1
            k += 1


class Stack:
    def __init__(self) -> None:
        self._Stack__items: list[any] = []
        
    def push(self, item: any):
        return self._Stack__items.append(item)

    def pop(self) -> any:
        if (self._Stack__items == []):
            return None
        else:
            return self._Stack__items.pop()

    def peek(self) -> any:
        if (self._Stack__items == []):
            return None
        else:
            return self._Stack__items[-1]

    @property
    def is_empty(self) -> bool:
        return (self._Stack__items == [])

    @property
    def size(self):
        return len(self._Stack__items)


class EvaluateExpression:
    def __init__(self, expression):
        self.expression = expression.replace(' ', '')  # Remove any spaces

    # Define operator precedence
    def precedence(self, op):
        if op in ('+', '-'):
            return 1
        if op in ('*', '/'):
            return 2
        return 0

    # Apply operation to two operands
    def apply_operation(self, a, b, op):
        if op == '+':
            return a + b
        if op == '-':
            return a - b
        if op == '*':
            return a * b
        if op == '/':
            if b == 0:
                return 'Error'
            else:
                return int(a / b)  # Integer division like Python's //

    # Convert infix to postfix using the Shunting Yard algorithm
    def infix_to_postfix(self):
        output = []
        operators = []

        i = 0
        while i < len(self.expression):
            # If the token is a number, add it to the output
            if self.expression[i].isdigit():
                num = ''
                while i < len(self.expression) and self.expression[i].isdigit():
                    num += self.expression[i]
                    i += 1
                output.append(num)
                i -= 1  # step back since i will increment in the next loop

            # If the token is an opening parenthesis, push it onto the stack
            elif self.expression[i] == '(':
                operators.append(self.expression[i])

            # If the token is a closing parenthesis, pop until matching '('
            elif self.expression[i] == ')':
                while operators and operators[-1] != '(':
                    output.append(operators.pop())
                operators.pop()  # pop '('

            # If the token is an operator
            else:
                while (operators and self.precedence(operators[-1]) >= self.precedence(self.expression[i])):
                    output.append(operators.pop())
                operators.append(self.expression[i])
            i += 1

        # Pop all the operators from the stack
        while operators:
            output.append(operators.pop())
        return output


    # Evaluate the postfix expression
    def evaluate_postfix(self, postfix):
        stack = []

        for token in postfix:
            if token.isdigit():
                stack.append(int(token))
            else:
                b = stack.pop()
                a = stack.pop()
                result = self.apply_operation(a, b, token)
                stack.append(result)

        return stack[0]

    # Main method to evaluate the infix expression
    def evaluate(self):
        postfix = self.infix_to_postfix()
        return self.evaluate_postfix(postfix)


def get_smallest_three(challenge):
  records = challenge.records
  times = [r for r in records]
  mergesort(times, lambda x: x.elapsed_time)
  return times[:3]