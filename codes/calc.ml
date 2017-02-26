(*
 * calc.ml
 *
 * Calculator for simple expressions
 *
 * The expression grammar is as follows:
 *
 *     E ::= T {+ T}
 *     T ::= F {* F}
 *     F ::= ( E ) | Int
 *
 * Expressions are parsed and evaluated on the fly.
 *
 * You can compile this file with the following command:
 *
 *     ocamlc -I +camlp4 -pp camlp4o calc.ml -o calc
 *)

(* Lex *)

module Token =
  struct
    type token =
      | LPar
      | RPar
      | Plus
      | Star
      | Number of float
  end

let rec lex = parser
  | [< ' (' ' | '\n' | '\r' | '\t'); stream >] -> lex stream
  | [< ' ('('); stream >] -> [< 'Token.LPar; lex stream >]
  | [< ' (')'); stream >] -> [< 'Token.RPar; lex stream >]
  | [< ' ('+'); stream >] -> [< 'Token.Plus; lex stream >]
  | [< ' ('*'); stream >] -> [< 'Token.Star; lex stream >]
  | [< ' ('0' .. '9' as c); stream >] ->
    let buffer = Buffer.create 1 in
    Buffer.add_char buffer c;
    lex_number buffer stream
  | [< >] -> [< >]

and lex_number buffer = parser
  | [< ' ('0' .. '9' | '.' as c); stream >] ->
    Buffer.add_char buffer c;
    lex_number buffer stream
  | [< stream >] ->
    let contents = Buffer.contents buffer in
    let number = float_of_string contents in
    [< 'Token.Number number; lex stream >]

let print_token token = match token with
  | Token.LPar -> print_endline "LPar"
  | Token.RPar -> print_endline "RPar"
  | Token.Plus -> print_endline "Plus"
  | Token.Star -> print_endline "Star"
  | Token.Number value -> print_endline @@ "Number: " ^ string_of_float value

(* Parse *)

module Expr =
  struct
    type expr =
      | Add of expr * expr
      | Mul of expr * expr
      | Num of float
  end

(* E -> T E' *)
let rec parse_expr = parser
  | [< lhs=parse_term; expr=parse_expr_rhs lhs >] -> expr

(* E' -> + T E' | eps *)
and parse_expr_rhs lhs = parser
  | [< 'Token.Plus;
       rhs=parse_term;
       expr=parse_expr_rhs (Expr.Add (lhs, rhs)) >] -> expr
  | [< >] -> lhs

(* T -> F T' *)
and parse_term = parser
  | [< lhs=parse_factor; expr=parse_term_rhs lhs >] -> expr

(* T' -> * F T' | eps *)
and parse_term_rhs lhs = parser
  | [< 'Token.Star;
       rhs=parse_factor;
       term=parse_term_rhs (Expr.Mul (lhs, rhs)) >] -> term
  | [< >] -> lhs

(* F -> ( E )  | Num *)
and parse_factor = parser
  | [< 'Token.LPar; expr=parse_expr; 'Token.RPar >] -> expr
  | [< 'Token.Number value >] -> Expr.Num value

let parse = parse_expr

let rec print_expr = function
  | Expr.Add (lhs, rhs) ->
    print_string "Add(";
    print_expr lhs;
    print_string ", ";
    print_expr rhs;
    print_string ")"
  | Expr.Mul (lhs, rhs) ->
    print_string "Mul(";
    print_expr lhs;
    print_string ", ";
    print_expr rhs;
    print_string ")"
  | Expr.Num value ->
    print_string "Num(";
    print_float value;
    print_string ")"

(* Eval *)

let rec eval = function
  | Expr.Add (lhs, rhs) -> eval lhs +. eval rhs
  | Expr.Mul (lhs, rhs) -> eval lhs *. eval rhs
  | Expr.Num value -> value

(* Main *)

let print_result result =
  print_string "= ";
  print_float result;
  print_endline "";
  flush stdout

let () =
  try
    while true do
      try
        print_string "> "; flush stdout;
        let line = input_line stdin in
        (*Stream.of_string line |> lex |> Stream.iter print_token*)
        (*Stream.of_string line |> lex |> parse |> print_expr; print_endline ""*)
        Stream.of_string line |> lex |> parse |> eval |> print_result
      with
      | End_of_file -> raise Exit
      | exc -> print_endline @@ Printexc.to_string exc
    done
  with Exit -> ()
