# GAME TITLE HERE
#### Video Demo: <insert url>
#### Description: Does things
TODO Several hundred words across multiple paragraphs
This is going to be a small-scale 2D game
Had to research Love2D programming and learn concepts
Trying to make a 2d game where a player traverses terrain. Have to learn how to do that. 
Read Sheepolution's "How to LOVE" at sheepolution.com
Initially wanted to make a water-like object, but that is too difficult to animate within this timeframe. Still, object should increase in size when it eats some powerups but loses size when taking damage from monsters
Use dynamic enemies that move from left to right of window, like a heated vent or lava pipe that moves
16th chapter into Sheepolution's guide and things are getting really math heavy. Making an object follow the mouse involves using vectors, radians, sine and cosine.
Object collision is very complex, though there are some pre-made libraries I can use, now that at least I understand the fundamentals of how it works.
Watched Colton Ogden's CS50 Falling in Love with Lua to gain some more understanding into Lua and Love2d
Obtained some free tileset images from itch.io
After doing some research, I decided to import Stalker-X's free-use camera library for Love2d, as this would be akin to importing a library in C or Python and will allow me to focus on building the actual game.
May switch back to translate for camera
Making collidable enemy which is throwing errors, have to debug.
Found error, typo
Have to make enemy move back and forth, have to do something similar to Sheepolution's chapter 14 but with fixed coordinates rather than window width.
First enemy done, will likely have to adjust code when I want to add more though.
Had to figure out a while loop to make the enemy spit out fire constantly while the player is nearby. Learned that Love2D does not have safeguards against infinite loops and will crash your game without telling you what went wrong - unlike the C and Python programs we've ran in the course. Though those might have been hard coded into the CS50 library.
Need to make the fire disappear once it hits the wall underneath, which involves checking collision. The constant fire is being generated using a table, so I could not add it to the list of objects that we have constantly checking collision on. Have to manually resolve the collision for the fire drops in order to kill them on contact.
Then, I have to check collision with the player and damage the latter on contact. TBD what that will entail.
Decided to keep the camera library for the fade-to-black function it has.
Completed player collision with fire, applied fade
Working on adding functionality to eat food. Harder to fix than expected.
Fixed fire collision in the meantime, so it stops when it hits walls and only triggers gameOver when it hits the player.
Making progress on player death conditions, working on animations now.
Will need to print the health counter on screen and build a menu
Have to figure out how to load quads outside of main.

Learning that Lua is not that popular. There is documentation out there, but Stack Overflow has very limited answers on this language. For example, everyone teaches how to draw quads from a spritesheet in main, but no one explains how to make the game draw that quad properly while ensuring collision checks still work and having your code in a different file.
Had to move on from the animation for now, to keep the project going. Changed texture of fire enemy and added ice textures.
Added food collection to increase health, health counter, and save and restart functions.
Learned that delta time can cause issues when moving a window due to the way love.run() works. In my case, the player would fall through the map when the window was moved. Turns out there's a simple fix by hard-capping delta time.

Finally managed to make a decent animation with offset added for direction control.
Used BFXR to make sound effects.
Learned how to stop updates when game is paused or over. Had to move the sound to love.update from love.draw to keep it from trying to play.
Got free music track from itch.io
Made some new sounds and got new images from Pixabay.
Game is nearly complete, just have to fix a graphical artefact on certain collisions.
Fixed by making a transparent canvas and cropping the area around the animation sprites.