//
// pushmeifyoucan.js
//
// Push the buttons before it is too late
//
// Authors : Gokcehan Kara <gokcehankara@gmail.com>
// License : This file is placed in the public domain.
//

'use strict'

var svg

var rows = 4
var cols = 4

var ticking

var speed
var score

var colors
var circles

var bestText
var scoreText
var speedText

var menuPanel
var restPanel
var exitPanel

function tick () {
  var i, j
  var count

  for (i = 0; i < rows; i++) {
    for (j = 0; j < cols; j++) {
      if (colors[i][j] >= 0) {
        colors[i][j] += 5
        circles[i][j].style.fill = 'rgb(' + colors[i][j] + ',' +
                                   127 + ',' +
                                   (255 - colors[i][j]) + ')'
      } else {
        circles[i][j].style.fill = 'black'
      }
      if (colors[i][j] >= 255) {
        clearInterval(ticking)
        circles[i][j].style.fill = '#cc3333'
        if (window.localStorage.bestScore === undefined ||
            score > window.localStorage.bestScore) {
          window.localStorage.bestScore = score
        }
        setTimeout(function () {
          menuPanel.setAttribute('display', 'inline')
        }, 3000)
      }
    }
  }

  bestText.textContent = window.localStorage.bestScore
  scoreText.textContent = score
  speedText.textContent = speed

  speed += 1

  count = speed * 0.001

  while (Math.random() < count) {
    i = Math.floor(Math.random() * rows)
    j = Math.floor(Math.random() * cols)
    if (colors[i][j] === -1) {
      colors[i][j] = 0
    }
    count -= 1
  }
}

function initGame () {
  var i, j

  speed = 0
  score = 0

  for (i = 0; i < rows; i++) {
    for (j = 0; j < cols; j++) {
      colors[i][j] = -1
    }
  }

  ticking = setInterval(tick, 100)
}

function resize (e) {
  svg.setAttribute('width', window.innerWidth)
  svg.setAttribute('height', window.innerHeight)
}

function init () {
  var i, j

  svg = document.getElementById('svg')

  window.onresize = resize

  resize()

  function click (i, j) {
    return function () {
      if (colors[i][j] > 0) {
        colors[i][j] = -1
        score += 1
      }
    }
  }

  colors = new Array(rows)
  circles = new Array(rows)
  for (i = 0; i < rows; i++) {
    colors[i] = new Array(cols)
    circles[i] = new Array(cols)
    for (j = 0; j < cols; j++) {
      colors[i][j] = -1
      circles[i][j] = document.getElementById('circle-' + i + '-' + j)
      circles[i][j].onclick = click(i, j)
    }
  }

  bestText = document.getElementById('bestText')
  scoreText = document.getElementById('scoreText')
  speedText = document.getElementById('speedText')

  menuPanel = document.getElementById('menuPanel')
  restPanel = document.getElementById('restPanel')
  exitPanel = document.getElementById('exitPanel')

  restPanel.onclick = function () {
    menuPanel.setAttribute('display', 'none')
    initGame()
  }

  exitPanel.onclick = function () { window.close() }

  initGame()
}
