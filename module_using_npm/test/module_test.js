var assert = require('assert');

describe('ModuleUsingNPM', function() {
  describe('greetings', function() {
    before(function() {
      this.muni = new ModuleUsingNPM('Legolas');
    });

    it('should return a greeting with name', function() {
      assert.equal(this.muni.greetings("Hi, "), "Hi, Legolas");
    });
  });
});
