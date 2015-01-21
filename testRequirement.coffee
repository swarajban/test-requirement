util = require 'util'


evaluateSingleTest = (objectKey, testValues, object) ->
#  TODO: values is:
# lt/gt
# substring
  if util.isArray testValues
    for testValue in testValues
      return true if testValueInObject objectKey, testValue, object
    return false

  else
    # testValues is a single value
    return testValueInObject objectKey, testValues, object

# Tests if testValue is in object, either directly or in array
testValueInObject = (objectKey, testValue, object) ->
  objectValue = object[objectKey];
  if util.isArray objectValue
    console.log "object value", objectValue
    console.log "test value", testValue
    index = objectValue.indexOf testValue
    console.log "index: ", index
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

  