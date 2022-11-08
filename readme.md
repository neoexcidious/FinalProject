# Skeleton Guy
#### Video Demo: <insert url>
#### Description: 2D Platformer where you have to avoid death and collect the star

I decided to learn Lua and create a small-scale 2D game. To achieve this, I had to research Love2D programming and learn some basic concepts. I found Sheepolution's guide (Read Sheepolution's "How to LOVE" at sheepolution.com) to be the easiest to understand, although Colton Ogden's CS50 Falling in Love with Lua was also helpful at times. Even so, in the 16th chapter of Sheepolution's guide, things were getting really math heavy. Making an object follow the mouse involves using vectors, radians, sine and cosine.
Object collision is also very complex, though there are some pre-made libraries I could use, now that I at least understood the fundamentals of how collision checks work. Given that I spent a whole week learning this new language, I gave myself a couple of more weeks to complete the actual project.


### Classic.lua, Entity.Lua and the beginnings of Main.lua
After spending a week going through Sheepolution's guide and others, I was ready to try and make the game. I started by generating a map and trying to make the player traverse the terrain. This took some time but it was not that ultimately that difficult and I did this in main.lua. Following Sheepolution's guide, I imported the classic open-source library and created myself an Entity base class, from which I could extend other objects to create the player and the other elements in the game. 

### walls.lua
I obtained some free tileset images from itch.io in order to make the map tiles. These overlapped each other at first, though I was able to fix that later on by resizing the wall2.jpg file. Per Sheepolution's instructions, I made sure these are put in a different table in main, so they don't constantly check if they're colliding with other wall tiles.

### Player.lua
I created this file in order to write most of the code affecting the player therein. I initially wanted the player to be a water-shaped object, but after some research and remembering having seen videos about how hard it is for professional game devs to animate water, I realized that it would be too difficult to attempt it within my timeframe of a few weeks. Unfortunately, it took me precious days of trying different things, before I came to that conclusion and decided to simplify things.

### Food.lua
I wanted the object to increase its size when it ate food (powerups) and go down size when taking damage from enemies. This is when I created the food file. Unfortunately, the size increase appeared to make the game uglier and also cause some traversal issues, so I decided to change it to an increase in health, so if a player was hit by an enemy once but had collected food, the game would not be over right away.
Adding functionality to eat food was harder to implement than expected; again, collission checks.


### fireEnemy.lua and Fire.lua
I decided to use at least one dynamic enemy that moves from left to right, like a heated vent or lava pipe that moves and pours down fire. Initially called my file Enemy.lua, before I decided to add another type of enemy later on. 
I wanted to make the enemy move back and forth, have to do something similar to Sheepolution's chapter 14, but within certain fixed coordinates, rather than the window width. 
Had to figure out a while loop to make the enemy spit out fire constantly while the player is in close proximity - since I decided I did not just want it to be active at all times. Figured this might help game performance, but also seemed like a neat trick. To do all of this, I decided to separate this enemy into 2 files: one for the vent itself and one for the fire "bullets" that it spat out.

### More on Entity.lua
In order to make the fire disappear once it hit the wall underneath, I had to check for collision. This is where the code I initially had in Entity.lua came into play, but I realized that the latter was not sufficient to properly resolve the collision in this scenario. The constant fire was being generated using a table, so I could not simply add it to the list of objects that I was checking collision on constantly. Instead, I had to manually resolve the collision for each of the fire drops and kill them on contact.
Furthermore, I had to check their collision against the player and damage the latter on contact. I postponed deciding on what that would entail. 
Making the enemy collidable threw some errors, which I had to debug; turned out to be only a typo. I realized that Lua is not always very clear in its error descriptions, unlike Python and maybe even C (though that may have been because of certain CS50 features that came with our course). I also learned that Love2D does not have safeguards against infinite loops and will crash your game without telling you what went wrong - unlike the C and Python programs we've ran in the course. Though, again, those might have been hard coded into the CS50 library.

### camera.lua
After doing some research, I decided to import Stalker-X's free-use camera library for Love2d, as this -same as classic.lua, would be akin to importing a library in C or Python and would allow me to focus on building the actual game. I considered switching back to translate for camera, but later decided to keep this for the camera fade and camera shake features. Later on, I discerned that being able to set deadzones would allow me to keep the camera from moving past the boundaries of the screen. This however cost me several hours though, which trying to figure out a way to not have the deadzone make the camera move too far behind the player. Eventually, I decided to use an if statement to switch from one type of camera to another, depending on the player's x position. The transition  is still not 100% to my liking, as it jolts, but I could not waste anymore time perfecting it.


### More on main.lua and player.lua
I added a gameOver flag and implemented some death conditions. Then, I added a health counter on screen and started implementing some key mapping at the top of the screen. 
I had to figure out how to load quads outside of main. This took me several days in total and made me question if Lua is really that popular. There is documentation for it out there, but Stack Overflow has very limited answers on this language. For example, everyone teaches how to draw quads from a spritesheet in main, but no one explains how to make the game draw quads properly while having your code in a different file (player.lua) and ensuring collision checks still work. At some point, I had to move on from the animation, to keep the project going. 
I added food collection to increase health, the actual health counter display, and the save and restart functions.

### iceEnemy
While I was moving on from the animation nightmare, I changed the texture of fire enemy and added a second enemy, this time in the form of tiles but with ice textures. The concept was the same as with the fire

Learned that delta time can cause issues when moving a window due to the way love.run() works. In my case, the player would fall through the map when the window was moved. Turns out there's a simple fix by hard-capping delta time.

Finally managed to make a decent animation with offset added for direction control.
Used BFXR to make sound effects.
Learned how to stop updates when game is paused or over. Had to move the sound to love.update from love.draw to keep it from trying to play.
Got free music track from itch.io
Made some new sounds and got new images from Pixabay.
Game is nearly complete, just have to fix a graphical artefact on certain collisions.
Fixed by making a transparent canvas and cropping the area around the animation sprites.