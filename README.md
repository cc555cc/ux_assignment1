# Tetrix Platform Climb

This project is a hybrid game that combines falling Tetromino blocks with a platformer-style goal climb. The player starts near the bottom of the screen and must build safe platforms from falling bricks to reach a goal placed high above the ground. If the player is crushed by a falling block or falls out of bounds, the game ends.

## Project structure

- `ux_assignment1.pde` – main game loop, setup, controls, HUD, win/lose logic, and level state
- `tetrix_class.pde` – Tetromino brick generation and block behavior
- `player_class.pde` – player movement, gravity, jump logic, collision, and rendering

## Requirements

This project is built for the Processing IDE and uses the Fisica physics library.

Before running:

1. Install Processing from https://processing.org/
2. Open the Processing IDE
3. Install the Fisica library:
   - Sketch > Import Library > Add Library...
   - Search for `Fisica`
   - Install it
4. Open the folder containing this project as a Processing sketch folder

## How to run

1. Open the project folder in Processing.
2. Make sure all three files are in the same folder:
   - `ux_assignment1.pde`
   - `player_class.pde`
   - `tetrix_class.pde`
3. Click the Run button, or press Ctrl + R.

## Controls

### Player controls

- `A` / `D` – move left / right
- `W` or `Space` – jump
- `S` – fast fall / downward acceleration
- `M` – toggle debug grid overlay
- `P` – pause / unpause

### Tetromino / brick controls

- Left Arrow – move current brick left
- Right Arrow – move current brick right
- Up Arrow – rotate current brick
- Down Arrow – soft drop brick one step
- Enter – hard drop to the lowest valid position and lock in place

## Gameplay goal

The player’s objective is to reach the green goal marker near the top of the screen. The player must use falling block formations as temporary platforms or stepping stones. As blocks lock into place, they create the climbing path.

## What the game is doing

### Player system
The player is a separate object from the Tetromino blocks. It is controlled independently by WASD and has:

- horizontal movement
- gravity
- jumping
- boundary checks
- collision detection against solid cells and falling blocks

### Tetromino system
The Tetromino pieces spawn from the top and fall downward. The Tetris logic handles:

- random piece selection
- falling motion
- collision checks
- rotation
- locking into place on the grid

### Win / lose conditions

- Win: the player reaches the goal marker
- Lose: the player is crushed by a falling brick or falls out of bounds

## Understanding the code

### Main sketch (`ux_assignment1.pde`)
This file contains:

- setup and drawing loop
- game state flags (`game_over`, `game_won`, `game_paused`)
- player instance creation
- Tetromino update loop
- collision checks for crushed-player logic
- win detection
- key handling
- HUD and debug display

### Tetromino class (`tetrix_class.pde`)
This class defines the falling block shapes and matrix-based layout for each piece. It tracks:

- shape type
- block positions
- size and bounds
- rotation logic
- locking behavior

### Player class (`player_class.pde`)
This class defines the player avatar and contains the actual platformer logic:

- movement speed
- gravity and jump force
- screen bounds handling
- collision with solid cells
- rendering of the player object

## Troubleshooting

### The game does not run
- Make sure the Fisica library is installed
- Make sure the folder is opened as a Processing sketch
- Ensure all `.pde` files are in the same folder

### The player falls off screen
- Check that the player has screen-floor bounds in `player_class.pde`
- Use the `M` key to reveal the grid and debug placement

### The game feels too fast or too slow
- Adjust movement and gravity constants in `ux_assignment1.pde` / `player_class.pde`

## Notes

This is a prototype and the gameplay is designed to be a playable concept rather than a polished commercial game. The project is structured so each teammate can work on their own part:

- player movement and platform logic in the player class
- Tetromino physics and block logic in the Tetrix class

Good luck and enjoy the game!
