# test-requirement
Node module to test if an object satisfies certain requirements

## Installation

`npm install test-requirement`
```javascript
var Test = require('test-requirement');
```

## Examples

Sample object:
```javascript
var SAMPLE_OBJECT = {
    "a": "hello",
    "b": 12,
    "list": [
        "one",
        "two",
        "three"
    ]
};
```

### Test key value

```javascript
var spec = {
    "a": "hello"
};

Test(SAMPLE_OBJECT, spec); // returns true
```

### Test key value where object value is array
```javascript
var spec = {
    "list": "one"
}
Test(SAMPLE_OBJECT, spec); // returns true bc 'one' is a value in SAMPLE_OBJECT.list
```

### Test key value where test specifies an array
```javascript
var spec = {
    "a": ["hello", "goodbye"]
}
Test(SAMPLE_OBJECT, spec); return true // returns true bc one of the test spec values for "a" matches SAMPLE_OBJECT.a
```

### Test key value within numerical range
```javascript
var spec = {
    "b": {
        "gt": 5, // SAMPLE_OBJECT.b (12) is greater than 5
        "lt": 17, // 12 is less than 17
        "gte": 12, // 12 is greater than or equal to 12
        "lte": 17 // 12 is less than or equal to 17
    }
};
Test(SAMPLE_OBJECT, spec); // return true bc SAMPLE_OBJECT.b (12) satisfies range requirements
```

### Test key value matches substrings
```javascript
var spec = {
    "a": {
        "substring": ["ell", "no match"] // "ell" is substring of SAMPLE_OBJECT.a ("hello"), so test will pass
    }
};
Test(Sample_OBJECT, spec); // returns true
```



