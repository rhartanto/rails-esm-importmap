turboly = window.turboly = window.turboly || {}

# -----------------------------------------------------------
# isNumber
# -----------------------------------------------------------
turboly.isNumber = (n) ->
  !isNaN(parseFloat(n)) && isFinite(n) && !isNaN(+n)
