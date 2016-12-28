//
// gameoflife.js
//
// First rule of hacker club is you do talk about game of life
//
// Authors : Gokcehan Kara <gokcehankara@gmail.com>
// License : This file is placed in the public domain.
//


'use strict';

/* global document */
/* global window */

var topSideSpace = 20;
var topScreenSpace = 65;
var botScreenSpace = 75;

var sideSpace;
var minSideSpace = 20;

var rows;
var cols;

var width;
var height;

var size;
var w;

var ctx;
var canvas;
var board;
var pattern;


function initBoard() {
  var i, j;

  width = window.innerWidth - (2 * minSideSpace);
  height = window.innerHeight - (topScreenSpace + botScreenSpace);

  rows = Math.floor(width / size);
  cols = Math.floor(height / size);

  board = new Array(rows);
  for (i = 0; i < rows; i++) {
    board[i] = new Array(cols);
    for (j = 0; j < cols; j++) {
      board[i][j] = false;
    }
  }

  markPattern();
}

function resizeBoard() {
  var i, j;
  var a, b, c, d;
  var width, height;
  var newBoard;
  var newRows, newCols;
  var minRows, minCols;

  width = window.innerWidth - (2 * minSideSpace);
  height = window.innerHeight - (topScreenSpace + botScreenSpace);

  newRows = Math.floor(width / size);
  newCols = Math.floor(height / size);

  newBoard = new Array(newRows);
  for (i = 0; i < newRows; i++) {
    newBoard[i] = new Array(newCols);
    for (j = 0; j < newCols; j++) {
      newBoard[i][j] = false;
    }
  }

  minRows = Math.min(rows, newRows);
  minCols = Math.min(cols, newCols);

  for (i = 0; i < minRows; i++) {
    for (j = 0; j < minCols; j++) {
      a = newRows > rows ? Math.floor((newRows - rows) / 2) + i : i;
      b = newCols > cols ? Math.floor((newCols - cols) / 2) + j : j;
      c = rows > newRows ? Math.floor((rows - newRows) / 2) + i : i;
      d = cols > newCols ? Math.floor((cols - newCols) / 2) + j : j;
      newBoard[a][b] = board[c][d];
    }
  }

  rows = newRows;
  cols = newCols;

  board = newBoard;
}

function clearBoard() {
  var i, j;

  for (i = 0; i < rows; i++) {
    for (j = 0; j < cols; j++) {
      board[i][j] = false;
    }
  }
}

function markCell(i, j) {
  if ((0 <= i && i < rows) && (0 <= j && j < cols) && !board[i][j]) {
    board[i][j] = true;
    drawCell(i, j);
  }
}

function unmarkCell(i, j) {
  if ((0 <= i && i < rows) && (0 <= j && j < cols) && board[i][j]) {
    board[i][j] = false;
    drawCell(i, j);
  }
}

function countNeighbours(i, j) {
  var neighbours = 0;
  if (board[(i - 1 + rows) % rows][(j - 1 + cols) % cols]) neighbours++;
  if (board[(i - 1 + rows) % rows][(j + 0 + cols) % cols]) neighbours++;
  if (board[(i - 1 + rows) % rows][(j + 1 + cols) % cols]) neighbours++;
  if (board[(i + 0 + rows) % rows][(j - 1 + cols) % cols]) neighbours++;
  if (board[(i + 0 + rows) % rows][(j + 1 + cols) % cols]) neighbours++;
  if (board[(i + 1 + rows) % rows][(j - 1 + cols) % cols]) neighbours++;
  if (board[(i + 1 + rows) % rows][(j + 0 + cols) % cols]) neighbours++;
  if (board[(i + 1 + rows) % rows][(j + 1 + cols) % cols]) neighbours++;
  return neighbours;
}

function tick() {
  var i, j;

  var next = new Array(rows);
  for (i = 0; i < rows; i++) {
    next[i] = new Array(cols);
    for (j = 0; j < cols; j++) {
      switch (countNeighbours(i, j)) {
        case 2:
          next[i][j] = board[i][j];
          break;
        case 3:
          next[i][j] = true;
          break;
        default:
          next[i][j] = false;
          break;
      }
    }
  }
  board = next;
  drawBoard();
}

function drawCell(i, j) {
  ctx.clearRect(i * size + w, j * size + w, size - w, size - w);

  if (board[i][j]) {
    ctx.fillRect(i * size + w, j * size + w, size - w, size - w);
  }
}

function drawBoard() {
  var i, j;

  ctx.fillStyle = 'black';
  ctx.strokeStyle = 'gray';
  ctx.lineWidth = w;

  ctx.clearRect(0, 0, width, height);

  for (i = 0; i <= rows; i++) {
    ctx.beginPath();
    ctx.moveTo(i * size + (w / 2), 0);
    ctx.lineTo(i * size + (w / 2), height);
    ctx.stroke();
  }

  for (j = 0; j <= cols; j++) {
    ctx.beginPath();
    ctx.moveTo(0, j * size + (w / 2));
    ctx.lineTo(width, j * size + (w / 2));
    ctx.stroke();
  }

  for (i = 0; i < rows; i++) {
    for (j = 0; j < cols; j++) {
      if (board[i][j]) {
        ctx.fillRect(i * size + w, j * size + w, size - w, size - w);
      }
    }
  }
}

function resizeEvent(e) {
  width = window.innerWidth - (2 * minSideSpace);
  height = window.innerHeight - (topScreenSpace + botScreenSpace);

  width = Math.floor(width / size) * size + w;
  height = Math.floor(height / size) * size + w;

  sideSpace = Math.floor((window.innerWidth - width) / 2);
  canvas.style.marginLeft = sideSpace + 'px';
  canvas.style.marginRight = sideSpace + 'px';

  canvas.width = width;
  canvas.height = height;

  resizeBoard();
  drawBoard();
}

function registerEvents() {
  var i, j;
  var erasing;
  var eraseCheck;
  var leftPressed, rightPressed;

  window.onresize = resizeEvent;

  document.oncontextmenu = function() { return false; };
  document.ondragstart = function() { return false; };

  $('#canvas').on('vmousedown', function(e) {
    i = Math.floor((e.clientX - sideSpace - (w / 2)) / size);
    j = Math.floor((e.clientY - topScreenSpace - (w / 2)) / size);
    if (e.button === undefined || e.button === 0) {
      leftPressed = true;
      if (erasing) {
        unmarkCell(i, j);
      } else {
        markCell(i, j);
      }
    } else if (e.button === 2) {
      rightPressed = true;
      unmarkCell(i, j);
    }
  });

  $(document).on('vmouseup', function(e) {
    i = Math.floor((e.clientX - sideSpace - (w / 2)) / size);
    j = Math.floor((e.clientY - topScreenSpace - (w / 2)) / size);
    if (e.button === undefined || e.button === 0) {
      leftPressed = false;
    } else if (e.button === 2) {
      rightPressed = false;
    }
    drawBoard();
  });

  $('#canvas').on('vmousemove', function(e) {
    i = Math.floor((e.clientX - sideSpace - (w / 2)) / size);
    j = Math.floor((e.clientY - topScreenSpace - (w / 2)) / size);
    if (!erasing && leftPressed) {
      markCell(i, j);
    } else if (erasing && leftPressed) {
      unmarkCell(i, j);
    } else if (rightPressed) {
      unmarkCell(i, j);
    }

    // XXX: android chrome bug workaround
    // https://code.google.com/p/android/issues/detail?id=19827
    e.preventDefault();
  });

  eraseCheck = document.getElementById('erase-check');

  $('#erase-check').on('change', function(e) {
    erasing = eraseCheck.checked;
  });
}

function registerButtons() {
  var speed;
  var playing;
  var ticking;
  var playButton;
  var speedSlider, sizeSlider;

  speedSlider = document.getElementById('speed');
  speed = Math.pow(2, speedSlider.value);

  $('#speed').on('change', function(e, i) {
    speed = Math.pow(2, speedSlider.value);
    if (playing) {
      clearInterval(ticking);
      ticking = setInterval(tick, 1000 / speed);
    }
  });

  sizeSlider = document.getElementById('size');
  size = Math.pow(2, sizeSlider.value);
  w = size / 8;

  $('#size').on('change', function(e, i) {
    size = Math.pow(2, sizeSlider.value);
    w = size / 8;
    resizeBoard();
    resizeEvent();
    drawBoard();
  });

  selectPattern();

  $('#pattern').on('change', function(e) {
    selectPattern();
  });

  $('#reset').on('click', function(e) {
    clearBoard();
    markPattern();
    drawBoard();
  });

  $('#tick').on('click', function(e) {
    tick();
  });

  playButton = document.getElementById('play');

  $('#play').on('click', function(e) {
    if (!playing) {
      playButton.innerHTML = '<i class="fa fa-fw fa-pause"></i>';
      playing = true;
      ticking = setInterval(tick, 1000 / speed);
    } else if (playing) {
      playButton.innerHTML = '<i class="fa fa-fw fa-play"></i>';
      playing = false;
      clearInterval(ticking);
    }
  });

  $('#clear').on('click', function(e) {
    clearBoard();
    drawBoard();
  });
}

function selectPattern() {
  var name;
  var patternSelect;

  patternSelect = document.getElementById('pattern');
  name = patternSelect.value;

  switch (name) {
    case 'blank'           : pattern = blank;           break;
    case 'random'          : pattern = blank;           break;
    case 'gosperglidergun' : pattern = gosperglidergun; break;
    case 'acorn'           : pattern = acorn;           break;
    case 'bunnies'         : pattern = bunnies;         break;
    case 'herschel'        : pattern = herschel;        break;
    case 'lidka'           : pattern = lidka;           break;
    case 'rpentomino'      : pattern = rpentomino;      break;
    case 'switchengine'    : pattern = switchengine;    break;
    case 'beacon'          : pattern = beacon;          break;
    case 'blinker'         : pattern = blinker;         break;
    case 'figureeight'     : pattern = figureeight;     break;
    case 'pulsar'          : pattern = pulsar;          break;
    case 'queenbeeshuttle' : pattern = queenbeeshuttle; break;
    case 'toad'            : pattern = toad;            break;
    case 'twinbeesshuttle' : pattern = twinbeesshuttle; break;
    case 'blinkerpuffer1'  : pattern = blinkerpuffer1;  break;
    case 'noahsark'        : pattern = noahsark;        break;
    case 'puffer1'         : pattern = puffer1;         break;
    case 'glider'          : pattern = glider;          break;
    case 'lwss'            : pattern = lwss;            break;
    case 'mwss'            : pattern = mwss;            break;
    case 'hwss'            : pattern = hwss;            break;
    case 'aircraftcarrier' : pattern = aircraftcarrier; break;
    case 'beehive'         : pattern = beehive;         break;
    case 'block'           : pattern = block;           break;
    case 'boat'            : pattern = boat;            break;
    case 'eater1'          : pattern = eater1;          break;
    case 'loaf'            : pattern = loaf;            break;
    case 'pond'            : pattern = pond;            break;
    case 'ship'            : pattern = ship;            break;
    case 'snake'           : pattern = snake;           break;
    case 'tub'             : pattern = tub;             break;
  }
}

function init() {
  canvas = document.getElementById('canvas');
  if (!canvas.getContext) return;
  ctx = canvas.getContext('2d');

  canvas.style.marginTop = topSideSpace + 'px';

  $(document).ready(function() {
    registerEvents();
    registerButtons();
    initBoard();
    resizeEvent();
  });
}

function getDimensions(pattern) {
  var i;
  var x, y;
  var count;

  count = 0;
  x = 0;
  y = -1;
  for (i = 0; i < pattern.length; i++) {
    switch (pattern[i]) {
      case '\n':
        y++;
        if (count > x) {
          x = count;
        }
        count = 0;
        break;
      case '.':
        count++;
        break;
      case 'O':
        count++;
        break;
    }
  }
  return [x, y];
}

function markPattern() {
  var i, j;
  var x, y;
  var m, n;
  var center;
  var dimensions;

  var patternSelect = document.getElementById('pattern');
  var name = patternSelect.value;
  if (name == 'random') {
    for (i = 0; i < rows; i++) {
      for (j = 0; j < cols; j++) {
        if (Math.random() < 0.5) {
          board[i][j] = true;
        }
      }
    }
  }

  dimensions = getDimensions(pattern);
  if ((dimensions[0] > rows) || (dimensions[1] > cols)) {
    $('#pattern-popup').popup('open');
  } else {
    center = [Math.floor(dimensions[0] / 2), Math.floor(dimensions[1] / 2)];
    x = 0;
    y = -1;
    for (i = 0; i < pattern.length; i++) {
      switch (pattern[i]) {
        case '\n':
          y++;
          x = 0;
          break;
        case '.':
          x++;
          break;
        case 'O':
          m = Math.floor(rows / 2) + x - center[0];
          n = Math.floor(cols / 2) + y - center[1];
          board[m][n] = true;
          x++;
          break;
      }
    }
  }
}

var blank = '\n';


// ========================================================================= //
// Patterns from http://www.conwaylife.com/wiki/Main_Page
// ========================================================================= //


// !Name: Gosper glider gun
// !Author: Bill Gosper
// !The first known gun and the first known finite pattern with unbounded growth.
// !www.conwaylife.com/wiki/index.php?title=Gosper_glider_gun
var gosperglidergun = '\n\
........................O\n\
......................O.O\n\
............OO......OO............OO\n\
...........O...O....OO............OO\n\
OO........O.....O...OO\n\
OO........O...O.OO....O.O\n\
..........O.....O.......O\n\
...........O...O\n\
............OO\n\
';


// !Name: Acorn
// !Author: Charles Corderman
// !A methuselah that stabilizes after 5206 generations.
// !www.conwaylife.com/wiki/index.php?title=Acorn
var acorn = '\n\
.O\n\
...O\n\
OO..OOO\n\
';


// !Name: Bunnies
// !Author: Robert Wainwright and Andrew Trevorrow
// !A parent of rabbits.
// !www.conwaylife.com/wiki/index.php?title=Bunnies
var bunnies = '\n\
O.....O\n\
..O...O\n\
..O..O.O\n\
.O.O\n\
';


// !Name: Herschel
// !A heptomino shaped like the lowercase letter h, which occurs at generation 20 of the B-heptomino.
// !www.conwaylife.com/wiki/index.php?title=Herschel
var herschel = '\n\
O\n\
OOO\n\
O.O\n\
..O\n\
';


// !Name: Lidka
// !Author: Andrzej Okrasinski and David Bell
// !A methuselah with lifespan 29055.
// !www.conwaylife.com/wiki/index.php?title=Lidka
var lidka = '\n\
.O\n\
O.O\n\
.O\n\
\n\
\n\
\n\
\n\
\n\
\n\
\n\
........O\n\
......O.O\n\
.....OO.O\n\
\n\
....OOO\n\
';


// !Name: R-pentomino
// !The most active polyomino with less than six cells; all of the others stabilize in at most 10 generations, but the R-pentomino does not do so until generation 1103, by which time it has a population of 116.
// !www.conwaylife.com/wiki/index.php?title=R-pentomino
var rpentomino = '\n\
.OO\n\
OO\n\
.O\n\
';


// !Name: Switch engine
// !Author: Charles Corderman
// !A methuselah that is unstable by itself, but can be used to make c/12 diagonal puffers and spaceships.
// !www.conwaylife.com/wiki/index.php?title=Switch_engine
var switchengine = '\n\
.O.O\n\
O\n\
.O..O\n\
...OOO\n\
';


// !Name: Beacon
// !Author: John Conway
// !The third most common oscillator (after the blinker and toad).
// !www.conwaylife.com/wiki/index.php?title=Beacon
var beacon = '\n\
OO\n\
O\n\
...O\n\
..OO\n\
';


// !Name: Blinker
// !Author: John Conway
// !The smallest and most common oscillator.
// !www.conwaylife.com/wiki/index.php?title=Blinker
var blinker = '\n\
OOO\n\
';


// !Name: Figure eight
// !Author: Simon Norton
// !A period 8 oscillator found in 1970.
// !www.conwaylife.com/wiki/index.php?title=Figure_eight
var figureeight = '\n\
OO\n\
OO.O\n\
....O\n\
.O\n\
..O.OO\n\
....OO\n\
';


// !Name: Pulsar
// !Author: John Conway
// !Despite its size, this is the fourth most common oscillator (and by far the most common of period greater than 2).
// !www.conwaylife.com/wiki/index.php?title=Pulsar
var pulsar = '\n\
..OOO...OOO\n\
\n\
O....O.O....O\n\
O....O.O....O\n\
O....O.O....O\n\
..OOO...OOO\n\
\n\
..OOO...OOO\n\
O....O.O....O\n\
O....O.O....O\n\
O....O.O....O\n\
\n\
..OOO...OOO\n\
';


// !Name: Queen bee shuttle
// !Author: Bill Gosper
// !A period 30 oscillator.
// !www.conwaylife.com/wiki/index.php?title=Queen_bee_shuttle
var queenbeeshuttle = '\n\
.........O\n\
.......O.O\n\
......O.O\n\
OO...O..O...........OO\n\
OO....O.O...........OO\n\
.......O.O\n\
.........O\n\
';


// !Name: Toad
// !Author: Simon Norton
// !The second most common oscillator (after the blinker).
// !www.conwaylife.com/wiki/index.php?title=Toad
var toad = '\n\
.OOO\n\
OOO\n\
';


// !Name: Twin bees shuttle
// !Author: Bill Gosper
// !Twin bees shuttle was found in 1971 and is the basis of all known period 46 oscillators.
// !www.conwaylife.com/wiki/index.php?title=Twin_bees_shuttle
var twinbeesshuttle = '\n\
.................OO\n\
OO...............O.O.......OO\n\
OO.................O.......OO\n\
.................OOO\n\
\n\
\n\
\n\
.................OOO\n\
OO.................O\n\
OO...............O.O\n\
.................OO\n\
';


// !Name: Blinker puffer 1
// !Author: Robert Wainwright
// !The first blinker puffer to be found.
// !www.conwaylife.com/wiki/index.php?title=Blinker_puffer_1
var blinkerpuffer1 = '\n\
...O\n\
.O...O\n\
O\n\
O....O\n\
OOOOO\n\
\n\
\n\
\n\
.OO\n\
OO.OOO\n\
.OOOO\n\
..OO\n\
\n\
.....OO\n\
...O....O\n\
..O\n\
..O.....O\n\
..OOOOOO\n\
';


// !Name: Noah's ark
// !Author: Charles Corderman
// !A diagonal puffer made up of two switch engines that was found in 1971.
// !www.conwaylife.com/wiki/index.php?title=Noah's_ark
var noahsark = '\n\
..........O.O\n\
.........O\n\
..........O..O\n\
............OOO\n\
\n\
\n\
\n\
\n\
\n\
.O\n\
O.O\n\
\n\
O..O\n\
..OO\n\
...O\n\
';


// !Name: Puffer 1
// !Author: Bill Gosper
// !An orthogonal, period-128 puffer and the first puffer to be discovered
// !http://www.conwaylife.com/wiki/index.php?title=Puffer_1
var puffer1 = '\n\
.OOO......O.....O......OOO\n\
O..O.....OOO...OOO.....O..O\n\
...O....OO.O...O.OO....O\n\
...O...................O\n\
...O..O.............O..O\n\
...O..OO...........OO..O\n\
..O...OO...........OO...O\n\
';


// !Name: Glider
// !Author: Richard K. Guy
// !The smallest, most common, and first discovered spaceship.
// !www.conwaylife.com/wiki/index.php?title=Glider
var glider = '\n\
.O\n\
..O\n\
OOO\n\
';


// !Name: LWSS
// !Author: John Conway
// !The smallest known orthogonally moving spaceship, and the second most common spaceship (after the glider).
// !www.conwaylife.com/wiki/index.php?title=Lightweight_spaceship
var lwss = '\n\
.O..O\n\
O\n\
O...O\n\
OOOO\n\
';


// !Name: MWSS
// !Author: John Conway
// !The third most common spaceship (after the glider and lightweight spaceship).
// !www.conwaylife.com/wiki/index.php?title=Middleweight_spaceship
var mwss = '\n\
...O\n\
.O...O\n\
O\n\
O....O\n\
OOOOO\n\
';


// !Name: HWSS
// !Author: John Conway
// !The fourth most common spaceship (after the glider, lightweight spaceship and middleweight spaceship).
// !www.conwaylife.com/wiki/index.php?title=Heavyweight_spaceship
var hwss = '\n\
...OO\n\
.O....O\n\
O\n\
O.....O\n\
OOOOOO\n\
';


// !Name: Aircraft carrier
// !The smallest still life that has more than one island.
// !www.conwaylife.com/wiki/index.php?title=Aircraft_carrier
var aircraftcarrier = '\n\
OO\n\
O..O\n\
..OO\n\
';


// !Name: Beehive
// !Author: John Conway
// !The second most common still life.
// !www.conwaylife.com/wiki/index.php?title=Beehive
var beehive = '\n\
.OO\n\
O..O\n\
.OO\n\
';


// !Name: Block
// !The most common still life.
// !www.conwaylife.com/wiki/index.php?title=Block
var block = '\n\
OO\n\
OO\n\
';


// !Name: Boat
// !The only 5-cell still life.
// !www.conwaylife.com/wiki/index.php?title=Boat
var boat = '\n\
OO\n\
O.O\n\
.O\n\
';


// !Name: Eater 1
// !Author: Bill Gosper
// !The first discovered eater.
// !http://www.conwaylife.com/wiki/index.php?title=Eater_1
var eater1 = '\n\
OO\n\
O.O\n\
..O\n\
..OO\n\
';


// !Name: Loaf
// !The third most common still life.
// !www.conwaylife.com/wiki/index.php?title=Loaf
var loaf = '\n\
.OO\n\
O..O\n\
.O.O\n\
..O\n\
';


// !Name: Pond
// !A still life.
// !www.conwaylife.com/wiki/index.php?title=Pond
var pond = '\n\
.OO\n\
O..O\n\
O..O\n\
.OO\n\
';


// !Name: Ship
// !A still life.
// !www.conwaylife.com/wiki/index.php?title=Ship
var ship = '\n\
OO\n\
O.O\n\
.OO\n\
';


// !Name: Snake
// !The twenty-first most common still life.
// !http://www.conwaylife.com/wiki/index.php?title=Snake
var snake = '\n\
OO.O\n\
O.OO\n\
';


// !Name: Tub
// !A very common still life.
// !www.conwaylife.com/wiki/index.php?title=Tub
var tub = '\n\
.O\n\
O.O\n\
.O\n\
';
