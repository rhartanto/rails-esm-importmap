changeColor = (selector, color) ->
  $(selector).each (index) ->
    $(this).css('color', color)

$ ->
  console.log("uuid from coffeescript #{uuid.v4()}")
  console.log("turboly.isNumber(100): #{turboly.isNumber(100)}")
  setTimeout ->
    changeColor('h1', 'red')
  , 800

  setTimeout ->
    changeColor('.field', 'blue')
  , 1200
