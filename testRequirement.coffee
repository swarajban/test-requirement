util = require 'util'
request = require 'request'
_ = require 'lodash'

# Evaluate a single test case
evaluateSingleTest = (objectKey, testValues, object) ->
  if util.isArray testValues
    # test values is array like ["test1", "test2"]
    for testValue in testValues
      return true if valueInObjectTest objectKey, testValue, object
    return false

  else if isRangeTest testValues
    # testValues is range like {"lt": 30, "gte": 15}
    return rangeTest objectKey, testValues, object

  else if isSubstringTest testValues
    # testValues is an object like {"substring": ["subs", "string"], "ignoreCase": false}
    # ignoreCase is optional and defaults to true
    return substringTest objectKey, testValues, object

  else if isEmptyTest testValues
    # testValues is an object like {"empty": true}
    return emptyTest objectKey, testValues, object

  else if isDateTest testValues
    # testValues is an object like {"year": "now"}
    return dateTest objectKey, testValues, object

  else
    # testValues is a single value; a string, boolean, or number
    return valueInObjectTest objectKey, testValues, object

# Check if the test is a range test
isRangeTest = (testValues) ->
  if _.isPlainObject testValues
    if 'lt' of testValues or 'gt' of testValues or 'lte' of testValues or 'gte' of testValues
      return true
  return false

# Perform the range test
rangeTest = (objectKey, ranges, object) ->
  valid = true
  value = object[objectKey]
  if 'lt' of ranges
    ltValue = ranges['lt']
    valid = valid and value < ltValue

  if 'gt' of ranges
    gtValue = ranges['gt']
    valid = valid and value > gtValue

  if 'lte' of ranges
    lteValue = ranges['lte']
    valid = valid and value <= lteValue

  if 'gte' of ranges
    gteValue = ranges['gte']
    valid = valid and value >= gteValue

  return valid

# Check if the test is a substring test
isSubstringTest = (testValues) ->
  if (_.isPlainObject testValues) and 'substring' of testValues then true else false

# Perform the substring test, ignore case by default or if specified
substringTest = (objectKey, test, object) ->

  substringValues = test['substring'] # array of test substrings
  substringValues = if util.isArray substringValues then substringValues else [ substringValues ] #put substringValues in array if it isn't already

  objectValue = object[objectKey] # document field values
  objectValues = if util.isArray objectValue then objectValue else [ objectValue ] #put objectValues in array if it isn't already

  for objectValue in objectValues
    objectValueStr = JSON.stringify(objectValue) # look for substrings in stringified arrays and objects too
    match = false
    for substring in substringValues
      if 'ignoreCase' not of test or test['ignoreCase'] # ignore case of string by default and when ignoreCase is true
        re = RegExp substring, "im" # case insensitive, multiline matching
      else
        re = RegExp substring, "m" # multiline matching
      if objectValueStr
        match = re.test objectValueStr

      # if substring in object value str
      return true if match
  return false

# Check if the test is an 'empty' test
isEmptyTest = (testValues) ->
  if (_.isPlainObject testValues) and 'empty' of testValues then true else false

# Check if specific field value is empty/non-empty according to expected test boolean
emptyTest = (objectKey, test, object) ->
  if objectKey not of object
    return false

  objectValue = object[objectKey]
  shouldBeEmpty = test['empty']

  if typeof shouldBeEmpty isnt 'boolean'
    return false

  empty = isEmpty objectValue
  if shouldBeEmpty then empty else not empty

# Check if a field value is empty (if it is "", [], {}, null, 0)
isEmpty = (objectValue) ->
  return (not objectValue?) or
      (objectValue == '') or
      (objectValue == 0) or
      (_.isEmpty(objectValue))

# Check if the test is a date test
isDateTest = (testValues) ->
  if (_.isPlainObject testValues) and 'year' of testValues then true else false

# Extract specific time from a date field and compare it with test
dateTest = (objectKey, pubdateTest, object) ->
  objectValue = object[objectKey]
  year = new Date(objectValue).getFullYear()

  if 'year' of pubdateTest # compare years
    testValue = pubdateTest['year']

    if testValue is 'now' # compare pubdate year value with year now
      thisYear = new Date().getFullYear()
      return year is thisYear

  # TODO expand test to month, etc
  return false

# Tests if testValue is in object, either directly or in array
valueInObjectTest = (objectKey, testValue, object) ->
  if objectKey not of object
    return false
  objectValue = object[objectKey]
  objectValue = JSON.stringify(objectValue) # match in stringified arrays and objects too
  re = RegExp testValue, "im"
  return re.test objectValue

# "And" the results of multiple tests
andTest = (object, tests) ->
  for test in tests
    return false if not Test object, test
  return true

# "Or" the results of multiple tests
orTest = (object, tests) ->
  for test in tests
    return true if Test object, test
  return false

# Returns true when an object satisfies test spec
Test = (object, test) ->
  for fieldName, testValues of test # iterate through test spec
    testPass = true
    if fieldName is 'and'
      testPass = andTest object, testValues

    else if fieldName is 'or'
      testPass = orTest object, testValues

    else
      testPass = evaluateSingleTest fieldName, testValues, object

    if not testPass
      return false

  return true

module.exports = exports = Test
  