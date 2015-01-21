util = require 'util'
_ = require 'lodash'

evaluateSingleTest = (objectKey, testValues, object) ->
  if util.isArray testValues
    # test values is array like ["test1", "test2"]
    for testValue in testValues
      return true if testValueInObject objectKey, testValue, object
    return false

  else if isRange testValues
    # testValues is range like {"lt": 30, "gte": 15}
    return inRange objectKey, testValues, object

  else if isSubstringTest testValues
    # testValues is an object like {"substring": ["subs", "string"]
    return matchesSubstring objectKey, testValues, object

  else
    # testValues is a single value; a string, boolean, or number
    return testValueInObject objectKey, testValues, object

isRange = (testValues) ->
  if _.isPlainObject testValues
    if 'lt' of testValues or 'gt' of testValues or 'lte' of testValues or 'gte' of testValues
      return true
  return false

inRange = (objectKey, ranges, object) ->
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

isSubstringTest = (testValues) ->
  if (_.isPlainObject testValues) and 'substring' of testValues then true else false

matchesSubstring = (objectKey, substringTest, object) ->
  substringValues = substringTest['substring'] # array of test substrings
  objectValue = object[objectKey]
  objectValues = if util.isArray objectValue then objectValue else [ objectValue ]
  for objectValue in objectValues
    for substring in substringValues
      # if substring in object value
      return true if objectValue.indexOf(substring) isnt -1
  return false


# Tests if testValue is in object, either directly or in array
testValueInObject = (objectKey, testValue, object) ->
  objectValue = object[objectKey];
  if util.isArray objectValue
    return (objectValue.indexOf testValue) isnt -1
  else # objectValue is not an array, compare directly
    return testValue == objectValue

andTest = (object, tests) ->
  for test in tests
    return false if not Test object, test
  return true

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

  