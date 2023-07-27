# Rego Language Basics

# modules:

The top unit of Rego is the module. One Rego file can be viewed as one module
The modules in OPA are similar to modules in general-purpose languages such as Go, but can be seen as policies instead of code, and the policies themselves can be viewed as code, so it is almost identical to modules in general-purpose languages
A package declaration is similar to a package declaration in a typical programming language, for example:

### package hello
It can also be used to represent a hierarchy using .
```
package hello.test.p1
```
Declared packages are used to isolate different modules when loading the contents of that module, and different package names can have different namespaces, so variables with the same name and functions can exist in different packages.

## Import:
Imports are used to import and use modules from other Rego files. Imports are primarily used to load modules that store policy data.

example:
import data.test.example
 if you import two modules: data.test.example and data.run.example, you can use an as statement to refer to data.test.sample as dtexample, data.run.sample as drexample.

```
import data.test.example as dtexample
import data.run.teample as drexample
```

## Policy
A policy consists of an arbitrary number of rules

- Scala Value:
- string
- Number
- true
- False
- Null

examples
```
s := "hello, world"
num := 5
exists := false
ret := null
```
## Composite Value:
A composite value has the form of an object, array, set, etc.
```
type_name({})
 "object"
type_name(set())
"set"

{
    "name1":"value1",
    "object": {"prop1":"value2", "prop2","value3"}
}
```

## Array:
```
numbers := ["zero", "one", "two", "three", "four"]

Empty array
empty_array := [ ]

Set
empty_set := set()
encodings := { "euc_kr", "cp949", "utf-8" }

{1,2,3} == {2,2,3,3,1,1,1}
"true"
```
## comprehension: This is a form of expression in programming language
Rego has three types of comprehension
Object Comprehension:
An object comprehension represents the rule that the : that constitutes the object must satisfy
```
fruits := ["banana", "apple", "pineapple"]
strlength := { st : count(st) | st = fruits[_] }
```
## Set Comprehension
A set comprehension declares a set by expressing the rules that the set must satisfy
```
fruits := ["banana", "apple", "pineapple"]
under7char := { st | st = fruits[_]; count(st) < 7 }
under7char["banana"]

## Array Comprehension
fruits := ["banana", "apple", "pineapple"]
under7char2 := [ st | st = fruits[_]; count(st) < 7 ]
under7char2[0]
```
## Variables and References:
The variables in Rego differ from those in a typical programming language. Rego finds a value for a variable that makes all expressions evaluated as true, and if not found, the variable becomes undefined. 
```
a := [1,2,3]
a[b] == 1
a[c] == 5
```
enter an expression with a[b] == 1 to find the value of b that can make that expression true. b is used as the index for the array, the first entry is 1 and the index starts at 0.

## Iteration:
The form of the reference using [ ] can be used for Iteration.

For example, in the following example, the fruitindex rule finds "apple" in the fruit array and returns the index. Enter the example below in REPL and enter fruitindex to return 0. This is because if a variable that meets the conditions exists while iterating the array, it is stored in the index variable, and if the rule is satisfied, the index is assigned to the rule.
```
fruits := ["apple", "banana", "pineapple"]
fruitindex = index { fruits[index] == "apple" }
```
The following example is a rule that does not locate an index, but only checks its existence. Enter in REPL and enter fruitxists to return true.
```
fruits := ["apple", "banana", "pineapple"]
fruitexists = true { fruits[_] == "apple" }
```
## Rules:
At the beginning of the rule, the default keyword is optionally placed, and a rule head exists. There may be several rule bodies behind the rule head, and no rule body may exist. Rules, such as value assignment and function, are separated by the form of the rule head, which is described in detail by examining by rule form.
```
Examples of Rules
default allow = false
 
allow = true {
    input.role == "admin"
}
 
allow = true {
    input.role == "user"
    input.has_permission == true
}
```
## Function:
A function is also a type of rule, and it has the following form.
```
<rule name> ( <argument>, ... ) = <variable to return> {
    <rule literal 1>
    <rule literal 2>
...
}

package function

multiply(a,b) = m {
    m := a*b
}

result1 = r {
    r := multiply(3,4)
}

result2 = r {
    r := multiply(3,9)
}

result3 = r {
    r := multiply(4,6,7)
}

result4 = r {
    r := multiply("23",5)
}
```