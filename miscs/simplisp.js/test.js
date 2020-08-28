#!/usr/bin/env node

var fs = require('fs');
var path = require('path');
var assert = require('assert');
var simplisp = require('./simplisp');
var util = require('util');

var run = simplisp.run;

// Test folder contains tests as individual files named as 'test-name.scm'
// First lines of these files have the commented result of evaluation

var testFolder = './test'
fs.readdir('./test', function(err, files) {
  for (var i = 0; i < files.length; i++) {
    var file = fs.readFileSync(path.join(testFolder, files[i]), 'utf8');
    var name = path.basename(files[i], path.extname(files[i])) + ' test';
    var beg = 2;  // skip comment characters
    var end = file.indexOf('\n') + 1;
    var ans = file.slice(beg, end);

    util.print('Running ' + name + ' ...');
    for (var j = 0; j < 60 - name.length; j++) { util.print(' '); }
    assert(run(file) === ans, name);
    util.print('PASSED\n');
  }
});
