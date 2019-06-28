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

  var mun = function(name) {
    this.name = name;
  };

  mun.prototype.init = function() {
    // do nothing
  };

  mun.prototype.greetings = function(prefix) {
    return prefix + this.name;
  }

  return mun
});
