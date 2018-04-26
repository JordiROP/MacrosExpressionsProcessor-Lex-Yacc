# Macros Expressions Processor with Lex and Yacc
This project was made for the subject of Language processors in University of Lleida (UDL).

Subject directed by Dr.Jordi Planes Cid.

## Goal
The goal of this project is to develop a simple macro expression processor using a binary tree as a data structure.

## Input
1. Creating and initializing variables.  
  ```
  x := a + 3;  
  y := x * 2;
  ```
2. Giving an expression.  
  ```
   y + x + b;
  ```
3. Creating and initializing variales with a lamda.  
  ```
  h := lamda q , w . 1 + q * w;
  ```
4. Giving an expression with a lamda.  
  ```
  4 + h a b;
  ```
5. Giving an expression with lamda that has a variable assigned to a macro.  
  ```
  z := lamda t ,w ,s . 3 + t * s - w;  
  
  p - z y b c;
  ```
## Output
1. For the given expression in 2.
  ```
  ((a+3)*2)+(a+3)+b
  ```
2. For the given expression in 4.  
  ```
  4+(1+a*b)
  ```
3. For the given expression in 5.  
  ```
  p-(3+((a+3)*2)*c-b)
  ```
  
## Built With
[Lex] - Lexical Parser.

[Yacc] - Sintactical Parser.

[C/C++] - Code implementation.

## Authors
* **Jordi Ricard Onrubia Palacios** - *Programming* - [JordiROP](https://github.com/JordiROP)

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/JordiROP/MacrosExpressionsProcessor-Lex-Yacc/blob/master/LICENSE) file for details
