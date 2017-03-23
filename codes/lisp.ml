(*
 * lisp.ml
 *
 * Basic lisp evaluator
 *
 * You can compile this file with the following command:
 *
 *     ocamlc -I +camlp4 -pp camlp4o lisp.ml -o lisp
 *)

(* Lex *)

module Tok =
  struct
    type token =
      | LPar
      | RPar
      | Def
      | Lam
      | If
      | True
      | False
      | Num of float
      | Var of string
  end

let rec lex = parser
  | [< ' (' ' | '\n' | '\r' | '\t'); stream >] -> lex stream
  | [< ''('; stream >] -> [< 'Tok.LPar; lex stream >]
  | [< '')'; stream >] -> [< 'Tok.RPar; lex stream >]
  | [< ' ('0' .. '9' as c); stream >] ->
    let buffer = Buffer.create 1 in
    Buffer.add_char buffer c;
    lex_number buffer stream
  | [< 'c; stream >] ->
    let buffer = Buffer.create 1 in
    Buffer.add_char buffer c;
    lex_item buffer stream
  | [< >] -> [< >]

and lex_number buffer = parser
  | [< ' ('0' .. '9' | '.' as c); stream >] ->
    Buffer.add_char buffer c;
    lex_number buffer stream
  | [< stream >] ->
    let contents = Buffer.contents buffer in
    let value = float_of_string contents in
    let token = Tok.Num value in
    [< 'token; lex stream >]

and lex_item buffer = parser
  | [< ' (' ' | '\n' | '\r' | '\t'); stream >] ->
    [< 'identify buffer; lex stream >]
  | [< ''('; stream >] -> [< 'identify buffer; 'Tok.LPar; lex stream >]
  | [< '')'; stream >] -> [< 'identify buffer; 'Tok.RPar; lex stream >]
  | [< 'c; stream >] ->
    Buffer.add_char buffer c;
    lex_item buffer stream
  | [< >] -> [< 'identify buffer >]

and identify buffer =
  let contents = Buffer.contents buffer in
  match contents with
  | "define" -> Tok.Def
  | "lambda" -> Tok.Lam
  | "if" -> Tok.If
  | "#t" -> Tok.True
  | "#f" -> Tok.False
  | contents -> Tok.Var contents

let string_of_token = function
  | Tok.LPar -> "("
  | Tok.RPar -> ")"
  | Tok.Def -> "define"
  | Tok.Lam -> "lambda"
  | Tok.If -> "if"
  | Tok.True -> "#t"
  | Tok.False -> "#f"
  | Tok.Num num -> string_of_float num
  | Tok.Var var -> var

let print_token token = token |> string_of_token |> print_endline

(* Parse *)

module Exp = struct
  type expr =
    | Nil
    | Bool of bool
    | Num of float
    | Var of string
    | Cond of expr * expr * expr
    | Def of expr * expr
    | Lam of expr list * expr
    | Blt of (expr list -> expr)
    | App of expr * expr list
end

let rec parse = parser
  | [< expr=parse_expr; stream >] ->
    print_string "-> "; flush stdout;
    [< 'expr; parse stream >]
  | [< >] -> [< >]

and parse_expr = parser
  | [< 'Tok.LPar; stream >] -> parse_list stream
  | [< 'Tok.True; _ >] -> Exp.Bool true
  | [< 'Tok.False; _ >] -> Exp.Bool false
  | [< 'Tok.Num num; _ >] -> Exp.Num num
  | [< 'Tok.Var var; _ >] -> Exp.Var var

and parse_list = parser
  | [< 'Tok.RPar; _ >] -> Exp.Nil
  | [< 'Tok.If;
       con=parse_expr;
       expr1=parse_expr;
       expr2=parse_expr;
       'Tok.RPar; _ >] -> Exp.Cond (con, expr1, expr2)
  | [< 'Tok.Def; (var, expr)=parse_def; 'Tok.RPar; _ >] -> Exp.Def (var, expr)
  | [< 'Tok.Lam;
       'Tok.LPar;
       args=parse_args [];
       expr=parse_expr;
       'Tok.RPar; _ >] -> Exp.Lam (args, expr)
  | [< func=parse_expr; args=parse_args []; _ >] -> Exp.App (func, args)

and parse_def = parser
  | [< 'Tok.LPar;
       var=parse_expr;
       args=parse_args [];
       expr=parse_expr; _ >] -> (var, Exp.Lam (args, expr))
  | [< var=parse_expr; expr=parse_expr; _ >] -> (var, expr)

and parse_args acc = parser
  | [< 'Tok.RPar; _ >] -> List.rev acc
  | [< arg=parse_expr; stream >] -> parse_args (arg :: acc) stream

let rec string_of_expr = function
  | Exp.Nil -> "nil"
  | Exp.Num num -> string_of_float num
  | Exp.Var var -> var
  | Exp.Bool true -> "#t"
  | Exp.Bool false -> "#f"
  | Exp.Cond (con, expr1, expr2) ->
    let con = string_of_expr con in
    let expr1 = string_of_expr expr1 in
    let expr2 = string_of_expr expr2 in
    "(if " ^ con ^ " " ^ expr1 ^ " " ^ expr2 ^ ")"
  | Exp.Def (var, expr) ->
    let var = string_of_expr var in
    let expr = string_of_expr expr in
    "(define " ^ var ^ " " ^ expr ^ ")"
  | Exp.Lam (args, expr) ->
    let args = args |> List.map string_of_expr |> String.concat " " in
    let expr = string_of_expr expr in
    "(lambda (" ^ args ^ ") " ^ expr ^ ")"
  | Exp.App (func, args) ->
    let func = string_of_expr func in
    let args = args |> List.map string_of_expr |> String.concat " " in
    "(" ^ func ^ " " ^ args ^ ")"
  | Exp.Blt blt -> assert false

let print_expr expr = expr |> string_of_expr |> print_endline

(* Eval *)

let rec eval env = parser
  | [< 'expr; stream >] ->
    begin try
      let (res, env) = eval_expr env expr in
      print_expr res;
      eval env stream
    with
    | Failure err -> print_endline err; eval env stream
    end;
  | [< >] -> [< >]

and eval_expr env = function
  | Exp.Nil as nil -> (nil, env)
  | Exp.Bool _ as con -> (con, env)
  | Exp.Num _ as num -> (num, env)
  | Exp.Var _ as var ->
    let res = lookup var env in
    (res, env)
  | Exp.Cond (cond, expr1, expr2) ->
    begin match fst(eval_expr env cond) with
    | Exp.Bool true -> eval_expr env expr1
    | Exp.Bool false -> eval_expr env expr2
    | _ -> failwith "ERROR: expected boolean"
    end
  | Exp.Def (var, expr) -> (Exp.Nil, (var, expr) :: env)
  | Exp.Lam (_, _) as lam -> (lam, env)
  | Exp.Blt _ as blt -> (blt, env)
  | Exp.App (func, args) ->
    let args = List.map (fun expr -> fst(eval_expr env expr)) args in
    begin match fst(eval_expr env func) with
    | Exp.Lam (vars, expr) ->
      if List.length vars <> List.length args
      then failwith "ERROR: wrong number of arguments";
      let binds = List.combine vars args in
      let res = fst(eval_expr (binds @ env) expr) in
      (res, env)
    | Exp.Blt func ->
      let res = func args in
      (res, env)
    | _ -> failwith "ERROR: expected function"
    end

and lookup var = function
  | (v, e) :: tl -> if v = var then e else lookup var tl
  | _ -> failwith "ERROR: unbound variable"

(* Built-in functions *)

let eq = function
  | x :: y :: [] -> Exp.Bool (x = y)
  | _ -> assert false

let lt = function
  | x :: y :: [] -> Exp.Bool (x < y)
  | _ -> assert false

let gt = function
  | x :: y :: [] -> Exp.Bool (x > y)
  | _ -> assert false

let le = function
  | x :: y :: [] -> Exp.Bool (x <= y)
  | _ -> assert false

let ge = function
  | x :: y :: [] -> Exp.Bool (x >= y)
  | _ -> assert false

let binop f x z =
  match (x, z) with
  | ((Exp.Num x), (Exp.Num z)) -> Exp.Num (f x z)
  | _ -> assert false

let add = List.fold_left (binop (+.)) (Exp.Num 0.0)

let mul = List.fold_left (binop ( *. )) (Exp.Num 1.0)

let sub = function
  | Exp.Num hd :: [] -> Exp.Num (0.0 -. hd)
  | Exp.Num hd :: tl ->
    begin match add tl with
    | Exp.Num rest -> Exp.Num (hd -. rest)
    | _ -> assert false
    end
  | _ -> assert false

let div = function
  | Exp.Num hd :: [] -> Exp.Num (1.0 /. hd)
  | Exp.Num hd :: tl ->
    begin match mul tl with
    | Exp.Num rest -> Exp.Num (hd /. rest)
    | _ -> assert false
    end
  | _ -> assert false

let env = [
  (Exp.Var "+", Exp.Blt add);
  (Exp.Var "-", Exp.Blt sub);
  (Exp.Var "*", Exp.Blt mul);
  (Exp.Var "/", Exp.Blt div);
  (Exp.Var "=", Exp.Blt eq);
  (Exp.Var "<", Exp.Blt lt);
  (Exp.Var ">", Exp.Blt gt);
  (Exp.Var "<=", Exp.Blt le);
  (Exp.Var ">=", Exp.Blt ge);
]

(* Read-Eval-Print-Loop (REPL) *)

let rec print = parser
  | [< 'expr; stream >] ->
    print_expr expr;
    print stream
  | [< >] -> ()

let () =
  stdin
  |> Stream.of_channel
  |> lex
  |> parse
  |> eval env
  |> print
