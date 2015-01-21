util = require 'util'
_ = require 'lodash'

evaluateSingleTest = (objectKey, testValues, object) ->
#  TODO: values is:
# substring
  if util.isArray testValues
    for testValue in testValues
      return true if testValueInObject objectKey, testValue, object
    return false

  else if isRange testValues
    # testValues is range like {"lt": 30, "gte": 15}
    return inRange objectKey, testValues, object

  else
    # testValues is a single value
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

Test = (object, test) ->
  for fieldName, values of test
    filterPass = true
    if fieldName is 'and'
      filterPass = andTest object, values

    else if fieldName is 'or'
      filterPass = orTest object, values

    else
      filterPass = evaluateSingleTest fieldName, values, object

    if not filterPass
      return false

  return true

module.exports = exports = Test

  