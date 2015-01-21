var assert = require('assert');
var tr = require('../');

describe('Test Requirement', function () {

  // Sample objects
  var TEST_OBJECT = {
    "id": "123",
    "x": "hello",
    "actors": [
      "tom hanks",
      "george clooney"
    ],
    "num": 10
  };


  // And tests

  var TEST_AND_TRUE = {
    "and": [
      {
        "id": ["123"]
      },
      {
        "x": ["hello"]
      }
    ]
  };

  var TEST_AND_FALSE = {
    "and": [
      {
        "id": ["NOPE"]
      },
      {
        "x": ["hello"]
      }
    ]
  };

  describe('and tests', function () {
    it('should return true when all AND tests pass', function () {
      assert.equal(tr(TEST_OBJECT, TEST_AND_TRUE), true);
    });

    it('should return false when one AND test fails', function () {
      assert.equal(tr(TEST_OBJECT, TEST_AND_FALSE), false);
    });
  });

  // Or tests

  var TEST_OR_TRUE = {
    "or": [
      {
        "id": ["123"]
      },
      {
        "x": ["helloa"]
      }
    ]
  };

  var TEST_OR_FALSE = {
    "or": [
      {
        "id": ["NOPE"]
      },
      {
        "x": ["NOPE"]
      }
    ]
  };

  describe('or tests', function () {
    it('should return true when all OR tests pass', function () {
      assert.equal(tr(TEST_OBJECT, TEST_OR_TRUE), true);
    });

    it('should return false when all OR tests fail', function () {
      assert.equal(tr(TEST_OBJECT, TEST_OR_FALSE), false);
    });
  });


  // KV tests
  var TEST_KV_TRUE = {
    "id": ["123"]
  };

  var TEST_KV_FALSE = {
    "id": ["NOPE"]
  };

  var TEST_KV_NO_KEY = {
    "otherKey": ["NOPE"]
  };

  var TEST_KV_IN_OBJECT_ARRAY = {
    "actors": ["tom hanks"]
  };

  var TEST_KV_NOT_IN_OBJECT_ARRAY = {
    "actors": ["tom NOPE"]
  };

  var TEST_KV_NOT_ARRAY = {
    "id": "123",
    "x": "hello"
  };

  var TEST_KV_NOT_ARRAY_NOT_EQUAL = {
    "id": "NOPE"
  };

  var TEST_KV_LT_TRUE = {
    "num": {
      "lt": 12
    }
  };

  var TEST_KV_LT_FALSE = {
    "num": {
      "lt": 5
    }
  };

  var TEST_KV_GT_TRUE = {
    "num": {
      "gte": 5
    }
  };

  var TEST_KV_GT_FALSE = {
    "num": {
      "gt": 15
    }
  };

  var TEST_KV_LTE_TRUE = {
    "num": {
      "lte": 10
    }
  };

  var TEST_KV_LTE_FALSE = {
    "num": {
      "lte": 5
    }
  };

  var TEST_KV_GTE_TRUE = {
    "num": {
      "gte": 10
    }
  };

  var TEST_KV_GTE_FALSE = {
    "num": {
      "gte": 12
    }
  };

  var TEST_KV_COMBO_RANGE_TRUE_ONE = {
    "num": {
      "lt": 30,
      "gt": 5
    }
  };

  var TEST_KV_COMBO_RANGE_TRUE_TWO = {
    "num": {
      "lte": 30,
      "gte": 10
    }
  };

  var TEST_KV_COMBO_RANGE_FALSE_ONE = {
    "num": {
      "lt": 8,
      "gt": 5
    }
  };

  var TEST_KV_COMBO_RANGE_FALSE_TWO = {
    "num": {
      "lte": 8,
      "gte": 5
    }
  };

  describe('key value tests', function () {
    it('should return true when a test contains an array of values and document does too', function () {
      assert.equal(tr(TEST_OBJECT, TEST_KV_TRUE), true);
    });

    it('should return false when a test contains an array of values and document does not', function () {
      assert.equal(tr(TEST_OBJECT, TEST_KV_FALSE), false);
    });

    it('should return false when a document does not contain key specified in test', function () {
      assert.equal(tr(TEST_OBJECT, TEST_KV_NO_KEY), false);
    });

    it('should return true when a test specifies a field that exists in array of object', function () {
      assert.equal(tr(TEST_OBJECT, TEST_KV_IN_OBJECT_ARRAY), true);
    });

    it('should return false when a test specifies a field that doesn\'t exist in array of object', function () {
      assert.equal(tr(TEST_OBJECT, TEST_KV_NOT_IN_OBJECT_ARRAY), false);
    });

    it('should return true/false when a test specifies a key value, where value is not an array', function () {
      assert.equal(tr(TEST_OBJECT, TEST_KV_NOT_ARRAY), true);
      assert.equal(tr(TEST_OBJECT, TEST_KV_NOT_ARRAY_NOT_EQUAL), false);
    });

    it('should return true/false when test specifies a lt', function () {
      assert.equal(tr(TEST_OBJECT, TEST_KV_LT_TRUE), true);
      assert.equal(tr(TEST_OBJECT, TEST_KV_LT_FALSE), false);
    });

    it('should return true/false when test specifies a gt', function () {
      assert.equal(tr(TEST_OBJECT, TEST_KV_GT_TRUE), true);
      assert.equal(tr(TEST_OBJECT, TEST_KV_GT_FALSE), false);
    });

    it('should return true/false when test specifies a lte', function () {
      assert.equal(tr(TEST_OBJECT, TEST_KV_LTE_TRUE), true);
      assert.equal(tr(TEST_OBJECT, TEST_KV_LTE_FALSE), false);
    });

    it('should return true/false when test specifies a gte', function () {
      assert.equal(tr(TEST_OBJECT, TEST_KV_GTE_TRUE), true);
      assert.equal(tr(TEST_OBJECT, TEST_KV_GTE_FALSE), false);
    });

    it('should return true/false when test specifies combo of ranges', function () {
      assert.equal(tr(TEST_OBJECT, TEST_KV_COMBO_RANGE_TRUE_ONE), true);
      assert.equal(tr(TEST_OBJECT, TEST_KV_COMBO_RANGE_TRUE_TWO), true);

      assert.equal(tr(TEST_OBJECT, TEST_KV_COMBO_RANGE_FALSE_ONE), false);
      assert.equal(tr(TEST_OBJECT, TEST_KV_COMBO_RANGE_FALSE_TWO), false);
    });

  });
});