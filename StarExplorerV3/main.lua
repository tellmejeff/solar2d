local composer = require('composer')

-- hide status bar
display.setStatusBar(display.HiddenStatusBar)

-- seed the random number generator
math.randomseed(os.time())

-- reserve channel for background music
audio.reserveChannels(1)
audio.setVolume(0.5, { channel = 1})
composer.gotoScene('menu')
