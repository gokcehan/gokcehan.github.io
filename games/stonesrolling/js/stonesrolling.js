//
// stonesrolling.js
//
// Roll the stone until it is placed on the right position
//
// Authors : Gokcehan Kara <gokcehankara@gmail.com>
// License : This file is placed in the public domain.
//


'use strict';

/* global document */
/* global window */
/* global THREE */
/* global requestAnimationFrame */

var camera, scene, renderer;
var blockGeometry, blockMaterial, blockMesh;
var groundGeometry, groundMaterial, groundMesh;

var blockSize = 200;
var frameCount = 10;

var goal;
var ground;
var groundMeshes;
var groundMaterials;

var rotor; // is used to animate rolling on an edge of the cube

var FrameType = {
  ROLLING_NEG_X_BEG : 0,
  ROLLING_POS_Z_BEG : 1,
  ROLLING_NEG_Z_BEG : 2,
  ROLLING_POS_X_BEG : 3,

  ROLLING_NEG_X     : 4,
  ROLLING_POS_Z     : 5,
  ROLLING_NEG_Z     : 6,
  ROLLING_POS_X     : 7,

  ROLLING_NEG_X_END : 8,
  ROLLING_POS_Z_END : 9,
  ROLLING_NEG_Z_END : 10,
  ROLLING_POS_X_END : 11
};

var frameQueue = [];
var moveQueue = [];

var Orientation = {
  POS_X : 0,
  POS_Y : 1,
  POS_Z : 2,
  NEG_X : 3,
  NEG_Y : 4,
  NEG_Z : 5
};

var Movement = {
  POS_X : 0,
  POS_Z : 1,
  NEG_X : 2,
  NEG_Z : 3
};

var kindsOfMovements = 4;

var blockPosition = {
  x1 : 0,
  z1 : 0,
  x2 : 0,
  z2 : 0,
  orientation : Orientation.POS_Y // is used to distinguish opposite directions
};

var maxNumberOfMovements = 20;

function init() {
  initScene();
  registerEvents();
  animate();
}

function initScene() {
  var light;
  var width, height;
  var ratio;

  renderer = new THREE.CanvasRenderer();

  width = window.innerWidth;
  height = window.innerHeight;

  renderer.setSize(width, height);
  renderer.setClearColor(0x000000, 1);
  renderer.sortObjects = false;
  document.body.appendChild(renderer.domElement);

  scene = new THREE.Scene();

  ratio = width / height;
  camera = new THREE.PerspectiveCamera(75, ratio, 1, 10000);

  scene.add(camera);

  light = new THREE.DirectionalLight(0xffffff);
  light.position.set(1000, 1000, 1000);
  scene.add(light);

  blockGeometry = new THREE.BoxGeometry(blockSize, 2 * blockSize, blockSize);
  blockMaterial = new THREE.MeshLambertMaterial({
    color: 0xff0000,
    shading: THREE.FlatShading
  });
  blockMesh = new THREE.Mesh(blockGeometry, blockMaterial);
  blockMesh.position.y = blockSize;

  rotor = new THREE.Object3D();
  rotor.add(blockMesh);
  scene.add(rotor);

  generateLevel();
}

function movePosX(position) {
  switch (position.orientation) {
    case Orientation.POS_X:
      position.orientation = Orientation.NEG_Y;
      position.x1 += 2;
      position.x2 += 1;
      break;
    case Orientation.POS_Y:
      position.orientation = Orientation.POS_X;
      position.x1 += 1;
      position.x2 += 2;
      break;
    case Orientation.POS_Z:
      // position.orientation = Orientation.POS_Z;
      position.x1 += 1;
      position.x2 += 1;
      break;
    case Orientation.NEG_X:
      position.orientation = Orientation.POS_Y;
      position.x1 += 1;
      position.x2 += 2;
      break;
    case Orientation.NEG_Y:
      position.orientation = Orientation.NEG_X;
      position.x1 += 2;
      position.x2 += 1;
      break;
    case Orientation.NEG_Z:
      // position.orientation = Orientation.NEG_Z;
      position.x1 += 1;
      position.x2 += 1;
      break;
  }
}

function movePosZ(position) {
  switch (position.orientation) {
    case Orientation.POS_X:
      // position.orientation = Orientation.POS_X;
      position.z1 += 1;
      position.z2 += 1;
      break;
    case Orientation.POS_Y:
      position.orientation = Orientation.POS_Z;
      position.z1 += 1;
      position.z2 += 2;
      break;
    case Orientation.POS_Z:
      position.orientation = Orientation.NEG_Y;
      position.z1 += 2;
      position.z2 += 1;
      break;
    case Orientation.NEG_X:
      // position.orientation = Orientation.NEG_X;
      position.z1 += 1;
      position.z2 += 1;
      break;
    case Orientation.NEG_Y:
      position.orientation = Orientation.NEG_Z;
      position.z1 += 2;
      position.z2 += 1;
      break;
    case Orientation.NEG_Z:
      position.orientation = Orientation.POS_Y;
      position.z1 += 1;
      position.z2 += 2;
      break;
  }
}

function moveNegX(position) {
  switch (position.orientation) {
    case Orientation.POS_X:
      position.orientation = Orientation.POS_Y;
      position.x1 -= 1;
      position.x2 -= 2;
      break;
    case Orientation.POS_Y:
      position.orientation = Orientation.NEG_X;
      position.x1 -= 1;
      position.x2 -= 2;
      break;
    case Orientation.POS_Z:
      // position.orientation = Orientation.POS_Z;
      position.x1 -= 1;
      position.x2 -= 1;
      break;
    case Orientation.NEG_X:
      position.orientation = Orientation.NEG_Y;
      position.x1 -= 2;
      position.x2 -= 1;
      break;
    case Orientation.NEG_Y:
      position.orientation = Orientation.POS_X;
      position.x1 -= 2;
      position.x2 -= 1;
      break;
    case Orientation.NEG_Z:
      // position.orientation = Orientation.NEG_Z;
      position.x1 -= 1;
      position.x2 -= 1;
      break;
  }
}

function moveNegZ(position) {
  switch (position.orientation) {
    case Orientation.POS_X:
      // position.orientation = Orientation.POS_X;
      position.z1 -= 1;
      position.z2 -= 1;
      break;
    case Orientation.POS_Y:
      position.orientation = Orientation.NEG_Z;
      position.z1 -= 1;
      position.z2 -= 2;
      break;
    case Orientation.POS_Z:
      position.orientation = Orientation.POS_Y;
      position.z1 -= 1;
      position.z2 -= 2;
      break;
    case Orientation.NEG_X:
      // position.orientation = Orientation.NEG_X;
      position.z1 -= 1;
      position.z2 -= 1;
      break;
    case Orientation.NEG_Y:
      position.orientation = Orientation.POS_Z;
      position.z1 -= 2;
      position.z2 -= 1;
      break;
    case Orientation.NEG_Z:
      position.orientation = Orientation.NEG_Y;
      position.z1 -= 2;
      position.z2 -= 1;
      break;
  }
}

function move(position, movement) {
  switch (movement) {
    case Movement.POS_X:
      movePosX(position);
      break;
    case Movement.POS_Z:
      movePosZ(position);
      break;
    case Movement.NEG_X:
      moveNegX(position);
      break;
    case Movement.NEG_Z:
      moveNegZ(position);
      break;
  }
}

function randomWalk() {
  var i;
  var movement;
  var coords = [];
  var position = {
    x1 : 0,
    z1 : 0,
    x2 : 0,
    z2 : 0,
    orientation : Orientation.POS_Y
  };

  coords.push([position.x1, position.z1]);
  coords.push([position.x2, position.z2]);

  for (i = 0; i < maxNumberOfMovements; i++) {
    movement = Math.floor(Math.random() * kindsOfMovements);
    move(position, movement);
    coords.push([position.x1, position.z1]);
    coords.push([position.x2, position.z2]);
  }

  return coords;
}

function getBounds(coords) {
  var i;
  var x, y, z;

  var bounds = {
    xMin : 0,
    xMax : 0,
    zMin : 0,
    zMax : 0,
    xLen : 0,
    zLen : 0
  };

  for (i = 0; i < coords.length; i++) {
    x = coords[i][0];
    z = coords[i][1];
    if (x < bounds.xMin) { bounds.xMin = x; }
    if (z < bounds.zMin) { bounds.zMin = z; }
    if (x > bounds.xMax) { bounds.xMax = x; }
    if (z > bounds.zMax) { bounds.zMax = z; }
  }

  bounds.xLen = (bounds.xMax - bounds.xMin) + 1;
  bounds.zLen = (bounds.zMax - bounds.zMin) + 1;

  return bounds;
}

function initGround(coords, bounds) {
  var i, j;
  var x, z;
  var row;

  ground = [];
  for (i = 0; i < bounds.xLen; i++) {
    row = [];
    for (j = 0; j < bounds.zLen; j++) {
      row.push(false);
    }
    ground.push(row);
  }

  for (i = 0; i < coords.length; i++) {
    x = coords[i][0];
    z = coords[i][1];
    ground[x - bounds.xMin][z - bounds.zMin] = true;
  }
}

function loadGround(coords, bounds) {
  var i, j;
  var groundGeometry;
  var materialsRow;
  var meshesRow;

  goal = [[0, 0], [0, 0]];
  goal[0][0] = coords[coords.length - 1][0] - bounds.xMin;
  goal[0][1] = coords[coords.length - 1][1] - bounds.zMin;
  goal[1][0] = coords[coords.length - 2][0] - bounds.xMin;
  goal[1][1] = coords[coords.length - 2][1] - bounds.zMin;

  groundGeometry = new THREE.PlaneGeometry(blockSize, blockSize);

  groundMaterials = [];
  for (i = 0; i < ground.length; i++) {
    materialsRow = [];
    for (j = 0; j < ground[i].length; j++) {
      if ((i === goal[0][0] && j === goal[0][1]) ||
          (i === goal[1][0] && j === goal[1][1])) {
        groundMaterial = new THREE.MeshLambertMaterial({
          color: 0xff0000,
          shading: THREE.FlatShading,
          side: THREE.DoubleSide
        });
      } else {
        groundMaterial = new THREE.MeshLambertMaterial({
          color: 0x808080,
          shading: THREE.FlatShading,
          side: THREE.DoubleSide
        });
      }
      if (!ground[i][j]) { groundMaterial.wireframe = true; }
      materialsRow.push(groundMaterial);
    }
    groundMaterials.push(materialsRow);
  }

  groundMeshes = [];
  for (i = 0; i < ground.length; i++) {
    meshesRow = [];
    for (j = 0; j < ground[i].length; j++) {
      groundMesh = new THREE.Mesh(groundGeometry, groundMaterials[i][j]);
      groundMesh.position.set(i * blockSize, 0, j * blockSize);
      groundMesh.rotation.set(Math.PI / 2, 0, 0);
      scene.add(groundMesh);
      meshesRow.push(groundMesh);
    }
    groundMeshes.push(meshesRow);
  }
}

function initBlock(bounds) {
  blockPosition.x1 = -bounds.xMin;
  blockPosition.z1 = -bounds.zMin;
  blockPosition.x2 = -bounds.xMin;
  blockPosition.z2 = -bounds.zMin;
  blockPosition.orientation = Orientation.POS_Y;

  rotor.position.x = blockPosition.x1 * blockSize;
  rotor.position.z = blockPosition.z1 * blockSize;

  camera.position.set(blockPosition.x1 * blockSize, 1000, blockPosition.z1 * blockSize + 2500);
}

function generateLevel() {
  var i, j;
  var row;

  var coords = randomWalk();
  var bounds = getBounds(coords);

  initGround(coords, bounds);
  loadGround(coords, bounds);
  initBlock(bounds);
}

function validMove(movement) {
  var position = {
    x1 : blockPosition.x1,
    z1 : blockPosition.z1,
    x2 : blockPosition.x2,
    z2 : blockPosition.z2,
    orientation : blockPosition.orientation
  };
  move(position, movement);
  return position.x1 >= 0 && position.x1 < ground.length &&
         position.x2 >= 0 && position.x2 < ground.length &&
         position.z1 >= 0 && position.z1 < ground[position.x1].length &&
         position.z2 >= 0 && position.z2 < ground[position.x2].length &&
         ground[position.x1][position.z1] &&
         ground[position.x2][position.z2];
}

function rollPosX() {
  var i;
  frameQueue.push(FrameType.ROLLING_POS_X_BEG);
  for (i = 0; i < frameCount; i++) {
    frameQueue.push(FrameType.ROLLING_POS_X);
  }
  frameQueue.push(FrameType.ROLLING_POS_X_END);
}

function rollPosZ() {
  var i;
  frameQueue.push(FrameType.ROLLING_POS_Z_BEG);
  for (i = 0; i < frameCount; i++) {
    frameQueue.push(FrameType.ROLLING_POS_Z);
  }
  frameQueue.push(FrameType.ROLLING_POS_Z_END);
}

function rollNegX() {
  var i;
  frameQueue.push(FrameType.ROLLING_NEG_X_BEG);
  for (i = 0; i < frameCount; i++) {
    frameQueue.push(FrameType.ROLLING_NEG_X);
  }
  frameQueue.push(FrameType.ROLLING_NEG_X_END);
}

function rollNegZ() {
  var i;
  frameQueue.push(FrameType.ROLLING_NEG_Z_BEG);
  for (i = 0; i < frameCount; i++) {
    frameQueue.push(FrameType.ROLLING_NEG_Z);
  }
  frameQueue.push(FrameType.ROLLING_NEG_Z_END);
}

function roll(move) {
  switch (move) {
    case Movement.POS_X:
      rollPosX();
      break;
    case Movement.POS_Z:
      rollPosZ();
      break;
    case Movement.NEG_X:
      rollNegX();
      break;
    case Movement.NEG_Z:
      rollNegZ();
      break;
  }
}

function registerEvents() {
  // disable right click menu
  renderer.domElement.oncontextmenu = function() { return false; };

  var clickStartX, clickStartY;

  document.addEventListener('touchstart', function(e) {
    e.preventDefault();
    clickStartX = e.changedTouches[0].screenX;
    clickStartY = e.changedTouches[0].screenY;
  }, false);

  document.addEventListener('touchend', function(e) {
    e.preventDefault();
    var move = Movement.POS_X;
    var diff = e.changedTouches[0].screenX - clickStartX;
    if (diff < e.changedTouches[0].screenY - clickStartY) { move = Movement.POS_Z; diff = e.changedTouches[0].screenY - clickStartY; }
    if (diff < clickStartX - e.changedTouches[0].screenX) { move = Movement.NEG_X; diff = clickStartX - e.changedTouches[0].screenX; }
    if (diff < clickStartY - e.changedTouches[0].screenY) { move = Movement.NEG_Z; diff = clickStartY - e.changedTouches[0].screenY; }
    moveQueue.push(move);
  }, false);

  document.addEventListener('keydown', function(e) {
    var i;
    if (moveQueue.length > 1) { return; }
    switch (e.keyCode) {
      case 39: // <right>
      case 76: // l
        moveQueue.push(Movement.POS_X);
        break;
      case 40: // <down>
      case 74: // j
        moveQueue.push(Movement.POS_Z);
        break;
      case 37: // <left>
      case 72: // h
        moveQueue.push(Movement.NEG_X);
        break;
      case 38: // <up>
      case 75: // k
        moveQueue.push(Movement.NEG_Z);
        break;
    }
  }, false);
}

function rotateAroundWorldAxis(object, axis, radians) {
  var rotWorldMatrix;

  rotWorldMatrix = new THREE.Matrix4();
  rotWorldMatrix.makeRotationAxis(axis.normalize(), radians);
  rotWorldMatrix.multiply(object.matrix);
  object.matrix = rotWorldMatrix;
  object.rotation.setFromRotationMatrix(object.matrix);
}

function begAnimPosX() {
  switch (blockPosition.orientation) {
    case Orientation.POS_X:
      blockMesh.position.x = -blockSize;
      rotor.position.x = (blockPosition.x1 + 1.5) * blockSize;
      break;
    case Orientation.POS_Y:
      blockMesh.position.x = -blockSize / 2;
      rotor.position.x = (blockPosition.x1 + 0.5) * blockSize;
      break;
    case Orientation.POS_Z:
      blockMesh.position.x = -blockSize / 2;
      rotor.position.x = (blockPosition.x1 + 0.5) * blockSize;
      break;
    case Orientation.NEG_X:
      blockMesh.position.x = -blockSize;
      rotor.position.x = (blockPosition.x1 + 0.5) * blockSize;
      break;
    case Orientation.NEG_Y:
      blockMesh.position.x = -blockSize / 2;
      rotor.position.x = (blockPosition.x1 + 0.5) * blockSize;
      break;
    case Orientation.NEG_Z:
      blockMesh.position.x = -blockSize / 2;
      rotor.position.x = (blockPosition.x1 + 0.5) * blockSize;
      break;
  }
}

function endAnimPosX() {
  switch (blockPosition.orientation) {
    case Orientation.POS_X:
      blockMesh.position.x = 0;
      blockMesh.position.y = blockSize;
      break;
    case Orientation.POS_Y:
      blockMesh.position.x = blockSize / 2;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.POS_Z:
      blockMesh.position.x = 0;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.NEG_X:
      blockMesh.position.x = 0;
      blockMesh.position.y = blockSize;
      break;
    case Orientation.NEG_Y:
      blockMesh.position.x = -blockSize / 2;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.NEG_Z:
      blockMesh.position.x = 0;
      blockMesh.position.y = blockSize / 2;
      break;
  }
  movePosX(blockPosition);
  rotateAroundWorldAxis(blockMesh, new THREE.Vector3(0, 0, 1), -Math.PI / 2);
  rotor.position.x = blockPosition.x1 * blockSize;
  rotor.rotation.z = 0;
}

function begAnimNegX() {
  switch (blockPosition.orientation) {
    case Orientation.POS_X:
      blockMesh.position.x = blockSize;
      rotor.position.x = (blockPosition.x1 - 0.5) * blockSize;
      break;
    case Orientation.POS_Y:
      blockMesh.position.x = blockSize / 2;
      rotor.position.x = (blockPosition.x1 - 0.5) * blockSize;
      break;
    case Orientation.POS_Z:
      blockMesh.position.x = blockSize / 2;
      rotor.position.x = (blockPosition.x1 - 0.5) * blockSize;
      break;
    case Orientation.NEG_X:
      blockMesh.position.x = blockSize;
      rotor.position.x = (blockPosition.x1 - 1.5) * blockSize;
      break;
    case Orientation.NEG_Y:
      blockMesh.position.x = blockSize / 2;
      rotor.position.x = (blockPosition.x1 - 0.5) * blockSize;
      break;
    case Orientation.NEG_Z:
      blockMesh.position.x = blockSize / 2;
      rotor.position.x = (blockPosition.x1 - 0.5) * blockSize;
      break;
  }
}

function endAnimNegX() {
  switch (blockPosition.orientation) {
    case Orientation.POS_X:
      blockMesh.position.x = 0;
      blockMesh.position.y = blockSize;
      break;
    case Orientation.POS_Y:
      blockMesh.position.x = -blockSize / 2;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.POS_Z:
      blockMesh.position.x = 0;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.NEG_X:
      blockMesh.position.x = 0;
      blockMesh.position.y = blockSize;
      break;
    case Orientation.NEG_Y:
      blockMesh.position.x = blockSize / 2;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.NEG_Z:
      blockMesh.position.x = 0;
      blockMesh.position.y = blockSize / 2;
      break;
  }
  moveNegX(blockPosition);
  rotateAroundWorldAxis(blockMesh, new THREE.Vector3(0, 0, 1), Math.PI / 2);
  rotor.position.x = blockPosition.x1 * blockSize;
  rotor.rotation.z = 0;
}

function begAnimPosZ() {
  switch (blockPosition.orientation) {
    case Orientation.POS_X:
      blockMesh.position.z = -blockSize / 2;
      rotor.position.z = (blockPosition.z1 + 0.5) * blockSize;
      break;
    case Orientation.POS_Y:
      blockMesh.position.z = -blockSize / 2;
      rotor.position.z = (blockPosition.z1 + 0.5) * blockSize;
      break;
    case Orientation.POS_Z:
      blockMesh.position.z = -blockSize;
      rotor.position.z = (blockPosition.z1 + 1.5) * blockSize;
      break;
    case Orientation.NEG_X:
      blockMesh.position.z = -blockSize / 2;
      rotor.position.z = (blockPosition.z1 + 0.5) * blockSize;
      break;
    case Orientation.NEG_Y:
      blockMesh.position.z = -blockSize / 2;
      rotor.position.z = (blockPosition.z1 + 0.5) * blockSize;
      break;
    case Orientation.NEG_Z:
      blockMesh.position.z = -blockSize;
      rotor.position.z = (blockPosition.z1 + 0.5) * blockSize;
      break;
  }
}

function endAnimPosZ() {
  switch (blockPosition.orientation) {
    case Orientation.POS_X:
      blockMesh.position.z = 0;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.POS_Y:
      blockMesh.position.z = blockSize / 2;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.POS_Z:
      blockMesh.position.z = 0;
      blockMesh.position.y = blockSize;
      break;
    case Orientation.NEG_X:
      blockMesh.position.z = 0;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.NEG_Y:
      blockMesh.position.z = -blockSize / 2;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.NEG_Z:
      blockMesh.position.z = 0;
      blockMesh.position.y = blockSize;
      break;
  }
  movePosZ(blockPosition);
  rotateAroundWorldAxis(blockMesh, new THREE.Vector3(1, 0, 0), -Math.PI / 2);
  rotor.position.z = blockPosition.z1 * blockSize;
  rotor.rotation.x = 0;
}

function begAnimNegZ() {
  switch (blockPosition.orientation) {
    case Orientation.POS_X:
      blockMesh.position.z = blockSize / 2;
      rotor.position.z = (blockPosition.z1 - 0.5) * blockSize;
      break;
    case Orientation.POS_Y:
      blockMesh.position.z = blockSize / 2;
      rotor.position.z = (blockPosition.z1 - 0.5) * blockSize;
      break;
    case Orientation.POS_Z:
      blockMesh.position.z = blockSize;
      rotor.position.z = (blockPosition.z1 - 0.5) * blockSize;
      break;
    case Orientation.NEG_X:
      blockMesh.position.z = blockSize / 2;
      rotor.position.z = (blockPosition.z1 - 0.5) * blockSize;
      break;
    case Orientation.NEG_Y:
      blockMesh.position.z = blockSize / 2;
      rotor.position.z = (blockPosition.z1 - 0.5) * blockSize;
      break;
    case Orientation.NEG_Z:
      blockMesh.position.z = blockSize;
      rotor.position.z = (blockPosition.z1 - 1.5) * blockSize;
      break;
  }
}

function endAnimNegZ() {
  switch (blockPosition.orientation) {
    case Orientation.POS_X:
      blockMesh.position.z = 0;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.POS_Y:
      blockMesh.position.z = -blockSize / 2;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.POS_Z:
      blockMesh.position.z = 0;
      blockMesh.position.y = blockSize;
      break;
    case Orientation.NEG_X:
      blockMesh.position.z = 0;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.NEG_Y:
      blockMesh.position.z = blockSize / 2;
      blockMesh.position.y = blockSize / 2;
      break;
    case Orientation.NEG_Z:
      blockMesh.position.z = 0;
      blockMesh.position.y = blockSize;
      break;
  }
  moveNegZ(blockPosition);
  rotateAroundWorldAxis(blockMesh, new THREE.Vector3(1, 0, 0), Math.PI / 2);
  rotor.position.z = blockPosition.z1 * blockSize;
  rotor.rotation.x = 0;
}

function gameEnded() {
  return (goal[0][0] === blockPosition.x1 &&
          goal[0][1] === blockPosition.z1 &&
          goal[1][0] === blockPosition.x2 &&
          goal[1][1] === blockPosition.z2) ||
         (goal[1][0] === blockPosition.x1 &&
          goal[1][1] === blockPosition.z1 &&
          goal[0][0] === blockPosition.x2 &&
          goal[0][1] === blockPosition.z2);
}

function restartGame() {
  document.body.removeChild(renderer.domElement);
  initScene();
}

function animate() {
  var curr;
  var move;

  requestAnimationFrame(animate);

  if (frameQueue.length > 0) {
    curr = frameQueue.shift();
    switch (curr) {
      case FrameType.ROLLING_POS_X_BEG:
        begAnimPosX();
        break;
      case FrameType.ROLLING_POS_X:
        rotor.rotation.z -= Math.PI / (2 * frameCount);
        camera.position.x += blockSize / (frameCount);
        break;
      case FrameType.ROLLING_POS_X_END:
        endAnimPosX();
        break;

      case FrameType.ROLLING_NEG_X_BEG:
        begAnimNegX();
        break;
      case FrameType.ROLLING_NEG_X:
        rotor.rotation.z += Math.PI / (2 * frameCount);
        camera.position.x -= blockSize / (frameCount);
        break;
      case FrameType.ROLLING_NEG_X_END:
        endAnimNegX();
        break;

      case FrameType.ROLLING_POS_Z_BEG:
        begAnimPosZ();
        break;
      case FrameType.ROLLING_POS_Z:
        rotor.rotation.x += Math.PI / (2 * frameCount);
        camera.position.z += blockSize / (frameCount);
        break;
      case FrameType.ROLLING_POS_Z_END:
        endAnimPosZ();
        break;

      case FrameType.ROLLING_NEG_Z_BEG:
        begAnimNegZ();
        break;
      case FrameType.ROLLING_NEG_Z:
        rotor.rotation.x -= Math.PI / (2 * frameCount);
        camera.position.z -= blockSize / (frameCount);
        break;
      case FrameType.ROLLING_NEG_Z_END:
        endAnimNegZ();
        break;
    }
  } else if (moveQueue.length > 0) {
    move = moveQueue.shift();
    if (validMove(move)) { roll(move); }
  }

  if (gameEnded()) { restartGame(); }

  renderer.render(scene, camera);
}
