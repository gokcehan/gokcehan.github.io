//
// simplisp.js
//
// Mostly SICP compatible scheme subset in javascript
//
// Authors: Gokcehan Kara <gokcehankara@gmail.com>
// License: This file is placed in the public domain.
//


function parse(inp) {
  var tokens;
  var ind = 0;
  var out = [];

  function tokenize(inp) {
    var tokens = [];
    for (var i = 0; i < inp.length; i++) {
      if (inp[i] === ';') {
        i++;
        while (inp[i] !== '\n' && i < inp.length) {
          i++;
        }
        continue;
      } else if (inp[i] === ' ' ||
                 inp[i] === '\n' ||
                 inp[i] === '\r' ||
                 inp[i] === '\t') {
        continue;
      } else if (inp[i] === '(' ||
                 inp[i] === ')') {
        tokens.push(inp[i]);
      } else {
        var token = "";
        while (inp[i] !== ';' &&
               inp[i] !== ' ' &&
               inp[i] !== '\n' &&
               inp[i] !== '\r' &&
               inp[i] !== '\t' &&
               inp[i] !== '(' &&
               inp[i] !== ')' &&
               i < inp.length) {
          token += inp[i];
          i++;
        }
        i--;  // FIXME: why the hack?
        if (!isNaN(token)) {
          tokens.push(+token);
        } else {
          tokens.push(token);
        }
      }
    }
    return tokens;
  }

  tokens = tokenize(inp);

  function parseList() {
    ind++;
    var lst = [];
    while (ind < tokens.length) {
      if (tokens[ind] === '(') {
        lst.push(parseList());
      } else if (tokens[ind] === ')') {
        return lst;
      } else {
        lst.push(tokens[ind]);
      }
      ind++;
    }
  }

  while (ind < tokens.length) {
    if (tokens[ind] === '(') {
      out.push(parseList());
    } else if (tokens[ind] === ')') {
      error("unexpected ')'");
    } else {
      out.push(tokens[ind]);
    }
    ind++;
  }

  return out;
}

function eval(exp, env) {
  if (typeof exp === 'number') {
    return exp;
  } else if (typeof exp === 'string') {
    return getVariable(exp, env);
  } else if (exp[0] === 'quote') {
    return exp[1];
  } else if (exp[0] === 'set!') {
    return setVariable(exp, env);
  } else if (exp[0] === 'define') {
    return defVariable(exp, env);
  } else if (exp[0] === 'if') {
    if (eval(exp[1], env)) {
      return eval(exp[2], env);
    } else {
      return eval(exp[3], env);
    }
  } else if (exp[0] === 'lambda') {
    return {
      type: 'compound',
      vars: exp[1],
      body: exp.slice(2),
      env: env,
    };
  } else if (exp[0] === 'begin') {
    return evalSequence(exp.slice(1), env);
  } else if (exp instanceof Array) {
    var proc = eval(exp[0], env);
    var args = exp.slice(1).map(function(e) { return eval(e, env); });
    return apply(proc, args);
  } else {
    error('unknown expression type');
  }
}

function apply(proc, args) {
  if (proc.type === 'primitive') {
    return proc.func(args);
  } else if (proc.type === 'compound') {
    var env = {};
    env.outer = proc.env;
    if (args.length === proc.vars.length) {
      for (var i = 0; i < args.length; i++) {
        env[proc.vars[i]] = args[i];
      }
    } else {
      error('wrong number of arguments');
    }
    return evalSequence(proc.body, env);
  } else {
    error('unknown procedure type');
  }
}

function getVariable(exp, env) {
  var frame = env;
  do {
    if (exp in frame) {
      return frame[exp];
    }
    frame = frame.outer;
  } while (frame !== undefined)
  error('unbound variable');
}

function setVariable(exp, env) {
  var value = eval(exp[2], env);
  var frame = env;
  do {
    if (exp[1] in frame) {
      frame[exp[1]] = value;
      return;
    }
    frame = frame.outer;
  } while (frame !== undefined)
  error('unbound variable');
}

function defVariable(exp, env) {
  if (typeof exp[1] === 'string') {
    var value = eval(exp[2], env);
    env[exp[1]] = value;
  } else if (exp[1] instanceof Array) {
    var lst = ['lambda'];
    lst.push(exp[1].slice(1));
    lst = lst.concat(exp.slice(2));
    var value = eval(lst, env);
    env[exp[1][0]] = value;
  } else {
    error('wrong definition');
  }
}

function evalSequence(exps, env) {
  var results = exps.map(function(exp) { return eval(exp, env); });
  return results[results.length - 1];
}

var env = {
  '+' : {
    type : 'primitive',
    func : function(args) {
      var result = 0;
      for (var i = 0; i < args.length; i++) {
        result += args[i];
      }
      return result;
    }
  },
  '-' : {
    type : 'primitive',
    func : function(args) {
      if (args.length === 0) {
        error("wrong number of arguments to '-'");
        return;
      } else if (args.length === 1) {
        return -args[0];
      } else {
        var result = args[0];
        for (var i = 1; i < args.length; i++) {
          result -= args[i];
        }
        return result;
      }
    }
  },
  '*' : {
    type : 'primitive',
    func : function(args) {
      var result = 1;
      for (var i = 0; i < args.length; i++) {
        result *= args[i];
      }
      return result;
    }
  },
  '/' : {
    type : 'primitive',
    func : function(args) {
      // FIXME: make this work as rationals
      if (args.length === 0) {
        error("wrong number of arguments to '/'");
        return;
      } else if (args.length === 1) {
        return 1 / args[0];
      } else {
        var result = args[0];
        for (var i = 1; i < args.length; i++) {
          result /= args[i];
        }
        return result;
      }
    }
  },
  '=' : {
    type : 'primitive',
    func : function(args) {
      if (args.length < 2) {
        error("wrong number of arguments to '='");
        return;
      }
      var result = true;
      for (var i = 1; i < args.length; i++) {
        result = result && (args[i - 1] === args[i]);
      }
      return result;
    }
  },
  '<' : {
    type : 'primitive',
    func : function(args) {
      if (args.length < 2) {
        error("wrong number of arguments to '<'");
        return;
      }
      var result = true;
      for (var i = 1; i < args.length; i++) {
        result = result && (args[i - 1] < args[i]);
      }
      return result;
    }
  },
  '>' : {
    type : 'primitive',
    func : function(args) {
      if (args.length < 2) {
        error("wrong number of arguments to '>'");
        return;
      }
      var result = true;
      for (var i = 1; i < args.length; i++) {
        result = result && (args[i - 1] > args[i]);
      }
      return result;
    }
  },
  '<=' : {
    type : 'primitive',
    func : function(args) {
      if (args.length < 2) {
        error("wrong number of arguments to '<='");
        return;
      }
      var result = true;
      for (var i = 1; i < args.length; i++) {
        result = result && (args[i - 1] <= args[i]);
      }
      return result;
    }
  },
  '>=' : {
    type : 'primitive',
    func : function(args) {
      if (args.length < 2) {
        error("wrong number of arguments to '>='");
        return;
      }
      var result = true;
      for (var i = 1; i < args.length; i++) {
        result = result && (args[i - 1] >= args[i]);
      }
      return result;
    }
  },
};

var out;
function run(inp) {
  out = "";
  var res;
  var tree = parse(inp);
  for (var i = 0; i < tree.length; i++) {
    res = eval(tree[i], env);
    if (res instanceof Array) {
      // FIXME: use a deep array join instead
      out += JSON.stringify(res) + "\n";
    } else if (res instanceof Object) {
      out += "<" + String(res.type) + ">\n";
    } else if (res !== undefined) {
      out += String(res) + "\n";
    }
  }
  return out;
}

function display(s) {
  out += String(s) + "\n";
}

function error(s) {
  out += String(s) + "\n";
}

module.exports.run = run;
