local composer = require('composer')

-- hide status bar
display.setStatusBar(display.HiddenStatusBar)

-- seed the random number generator
math.randomseed(os.time())

composer.gotoScene('menu')
