var ModuleUsingNPM = require("@fury/module_using_npm");

(function(definition) {
  "use strict";

  // Cameleon loading, blatantly copied from:
  // https://github.com/kriskowal/q/blob/master/q.js

  // Montage Require
  if (typeof bootstrap === "function") {
    bootstrap("promise", definition);

  // CommonJS
  } else if (typeof exports === "object" && typeof module === "object") {
    module.exports = definition();

    // RequireJS
  } else if (typeof define === "function" && define.amd) {
    define(definition);

    // SES (Secure EcmaScript)
  } else if (typeof ses !== "undefined") {
    if (!ses.ok()) {
      return;
    } else {
      ses.makeQ = definition;
    }
  } else {
    throw new Error("This environment is not supported");
  }
})(function () {
  "use strict";

  var app = function(name) {
    this.name = name;
    this.mun = new ModuleUsingNPM(name);
  };

  app.prototype.init = function() {
    // do nothing
  };

  app.prototype.hello = function(prefix) {
    return this.mun.greetings(prefix);
  }

  return app
});
