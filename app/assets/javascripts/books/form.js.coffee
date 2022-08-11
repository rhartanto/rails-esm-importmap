changeColor = (selector, color) ->
  $(selector).each (index) ->
    $(this).css('color', color)

$ ->
  setTimeout ->
    changeColor('h1', 'red')
  , 800

  setTimeout ->
    changeColor('.field', 'blue')
  , 1200
