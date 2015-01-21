
evaluateFilter = (fieldName, values, object) ->
#  assume values is an array of options
#  TODO: values is:
# single value
# lt/gt
# substring

#  assume object field-value is single value
#  TODO: field-value can be array

  for value in values
    return true if object[fieldName] == value
  return false

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
      filterPass = evaluateFilter fieldName, values, object

    if not filterPass
      return false

  return true

module.exports = exports = Test

  