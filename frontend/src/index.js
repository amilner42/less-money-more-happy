'use strict';

// Must require all scss.
require("./Styles/global.scss");
require("./Styles/mixins.scss");
require("./Styles/variables.scss");

require("./Components/Styles.scss");
require("./Components/Home/Styles.scss");
require("./Components/Welcome/Styles.scss");
require("./Components/New/Styles.scss");

require("./Templates/ErrorBox.scss");

// Require index.html so it gets copied to dist
require('./index.html');


var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

// The key for the model in localStorage.
var modelKey = "model";

// Load app with localStorage cachedModel as initial flag.
var app = Elm.Main.embed(mountNode, JSON.parse(localStorage.getItem(modelKey)) || null);

// Saves the model to local storage.
app.ports.saveModelToLocalStorage.subscribe(function(model) {
  localStorage.setItem(modelKey, JSON.stringify(model));
});

// Load the model from localStorage and send message to subscription over
// port.
app.ports.loadModelFromLocalStorage.subscribe(function() {
  // Send the item or a blank string if nothing there...elm doesn't like when
  // you send null through the port because we say it expects a string.
  app.ports.onLoadModelFromLocalStorage.send(localStorage.getItem(modelKey) || "")
});
