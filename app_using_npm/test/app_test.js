var assert = require('assert');

describe('AppUsingNPM', function() {
  describe('hello', function() {
    before(function() {
      this.appi = new AppUsingNPM("Obi Wan");
    });

    it('should return a greeting with name', function() {
      assert.equal(this.appi.hello("Hi, "), "Hi, Obi Wan");
    });
  });
});
