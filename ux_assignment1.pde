import fisica.*;

FWorld world;
ArrayList<Tetrix> registered_tetrix = new ArrayList<Tetrix>();
int[][] world_matrix = new int[26][48];

Tetrix current_tetrix = null;

Player player;

final int CELL_SIZE = 40;
final float PLAYER_MOVE_SPEED = 4.8;
final float PLAYER_GRAVITY = 0.75;
final float PLAYER_JUMP_SPEED = -13.5;
final float PLAYER_MAX_FALL_SPEED = 18;

float goalX = 0;
float goalY = 0;
float goalW = 140;
float goalH = 22;

float last_move_time = 0;

boolean show_matrix = true; //debug: draw world_matrix on screen//
boolean game_over = false;
boolean game_won = false;
boolean game_paused = false;

boolean a_pressed = false;
boolean d_pressed = false;
boolean s_pressed = false;
boolean jump_pressed = false;

color[] block_colors = {
    #FFADAD, //red//
    #FFD6A5, //orange//
    #FDFFB6, //yellow//
    #CAFFBF, //green//
    #9BF6FF, //blue//
    #A0C4FF, //indigo//
    #D7B5FF  //violet//
};

void setup(){
    size(1200, 780);
    Fisica.init(this);
    world = new FWorld();
    world.setEdges(); //define walls and floor at windows edge//

    player = new Player(width * 0.5, height - 80);
    goalX = width * 0.5 - goalW * 0.5;
    goalY = CELL_SIZE * 0.8;
}

void draw(){
    background(255);

    if (!game_paused && !game_over && !game_won){
        world.step();
        updateTetrixPieces();
        player.update();
        checkPlayerCrushedByFallingBlocks();
        checkWinCondition();
    }

    world.draw();
    if (show_matrix) drawMatrix();
    drawGoal();
    player.draw();
    drawHud();
}

void updateTetrixPieces(){
    float now = millis();

    if (now - last_move_time >= 1000){
        for (Tetrix t : registered_tetrix){
            if (t.set) continue; //landed pieces stay put//
            if (!t.fits(t.x, t.y + t.block_size)){ //something is under one of its blocks//
                t.set();
                continue;
            }
            t.moveTo(t.x, t.y + t.block_size);
        }
        last_move_time = now; //reset the timer even if nothing moved//
    } else if (current_tetrix == null || current_tetrix.set){ //if this is the first tetrix, or the last one is fixed//
        Tetrix t = new Tetrix(int(random(1, 9)), int(random(0, 45)) * CELL_SIZE, 0);
        registered_tetrix.add(t); //add t to the list of tetrix//
        t.addTo(world); //add t's body to fisica's world//
        current_tetrix = t; //set it as current tetrix being controlled//
    }
}

void checkPlayerCrushedByFallingBlocks(){
    if (game_over || game_won) return;

    boolean standing_on_falling_piece = false;

    for (Tetrix t : registered_tetrix){
        if (t.set) continue;

        for (int row = 0; row < t.space.length; row++){
            for (int col = 0; col < t.space[row].length; col++){
                if (t.space[row][col] != 1) continue;

                float block_left = t.x + col * CELL_SIZE;
                float block_top = t.y + row * CELL_SIZE;
                float block_right = block_left + CELL_SIZE;
                float block_bottom = block_top + CELL_SIZE;

                if (!rectsOverlap(player.left(), player.top(), player.right(), player.bottom(),
                                  block_left, block_top, block_right, block_bottom)){
                    continue;
                }

                float overlap_from_top = player.bottom() - block_top;
                boolean from_above =
                    player.previous_bottom <= block_top + 1 &&
                    player.vy >= 0 &&
                    overlap_from_top >= 0 &&
                    overlap_from_top <= 14;

                if (from_above){
                    player.y = block_top - player.h * 0.5;
                    player.vy = 0;
                    player.on_ground = true;
                    standing_on_falling_piece = true;
                    continue;
                }

                game_over = true;
                return;
            }
        }
    }

    if (!standing_on_falling_piece && !player.on_ground){
        // no-op: lets player continue falling naturally//
    }
}

void checkWinCondition(){
    if (rectsOverlap(player.left(), player.top(), player.right(), player.bottom(),
                     goalX, goalY, goalX + goalW, goalY + goalH)){
        game_won = true;
    }
}

boolean rectsOverlap(float a_left, float a_top, float a_right, float a_bottom,
                     float b_left, float b_top, float b_right, float b_bottom){
    return a_right > b_left && a_left < b_right && a_bottom > b_top && a_top < b_bottom;
}

void keyPressed(){
    if (key == 'p' || key == 'P'){
        game_paused = !game_paused;
        return;
    }
    if (key == 'm' || key == 'M'){
        show_matrix = !show_matrix;
        return;
    }

    if (game_over || game_won || game_paused) return;

    if (key == 'a' || key == 'A') a_pressed = true;
    if (key == 'd' || key == 'D') d_pressed = true;
    if (key == 's' || key == 'S') s_pressed = true;
    if (key == ' ' || key == 'w' || key == 'W') jump_pressed = true;

    if (current_tetrix == null || current_tetrix.set) return;

    if (key == ENTER || key == RETURN){
        //drop to lowest point possible//
        float target_y = current_tetrix.y;
        while (current_tetrix.fits(current_tetrix.x, target_y + CELL_SIZE)){
            target_y += CELL_SIZE;
        }
        current_tetrix.moveTo(current_tetrix.x, target_y);
        current_tetrix.set();
    } else if (keyCode == LEFT){
        current_tetrix.left();
    } else if (keyCode == RIGHT){
        current_tetrix.right();
    } else if (keyCode == UP){
        current_tetrix.rotate();
    } else if (keyCode == DOWN){
        if (current_tetrix.fits(current_tetrix.x, current_tetrix.y + CELL_SIZE)){
            current_tetrix.moveTo(current_tetrix.x, current_tetrix.y + CELL_SIZE);
        } else {
            current_tetrix.set();
        }
    }
}

void keyReleased(){
    if (key == 'a' || key == 'A') a_pressed = false;
    if (key == 'd' || key == 'D') d_pressed = false;
    if (key == 's' || key == 'S') s_pressed = false;
}

void drawGoal(){
    pushStyle();
    fill(#84E1BC);
    stroke(#1F9D6F);
    strokeWeight(2);
    rect(goalX, goalY, goalW, goalH, 8);
    fill(30);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("GOAL", goalX + goalW * 0.5, goalY + goalH * 0.5);
    popStyle();
}

void drawHud(){
    pushStyle();
    fill(20);
    textAlign(LEFT, TOP);
    textSize(16);
    text("Avatar: A/D move, W or SPACE jump, S fast-fall", 16, 12);
    text("Bricks: Arrow keys move/rotate, ENTER hard drop, P pause, M grid", 16, 34);
    text("Player position: (" + int(player.x) + ", " + int(player.y) + ")", 16, 56);

    if (game_paused){
        textSize(36);
        fill(30, 120, 220);
        textAlign(CENTER, CENTER);
        text("PAUSED", width * 0.5, height * 0.5);
    } else if (game_over){
        textSize(36);
        fill(210, 30, 30);
        textAlign(CENTER, CENTER);
        text("GAME OVER - You were crushed", width * 0.5, height * 0.5);
    } else if (game_won){
        textSize(36);
        fill(20, 140, 40);
        textAlign(CENTER, CENTER);
        text("YOU WIN!", width * 0.5, height * 0.5);
    }
    popStyle();
}

//debug overlay: grid lines and cell values//
void drawMatrix(){
    pushStyle();
    textAlign(CENTER, CENTER);
    textSize(12);
    stroke(0, 40);
    for (int row = 0; row < world_matrix.length; row++){
        for (int col = 0; col < world_matrix[row].length; col++){
            noFill(); //outline only, so piece colors are not tinted//
            rect(col * CELL_SIZE, row * CELL_SIZE, CELL_SIZE, CELL_SIZE);
            fill(0, 120);
            text(world_matrix[row][col], col * CELL_SIZE + CELL_SIZE * 0.5, row * CELL_SIZE + CELL_SIZE * 0.5);
        }
    }
    popStyle();
}

boolean isSolidCell(int row, int col){
    if (row < 0) return false;
    if (col < 0 || col >= world_matrix[0].length) return false;
    if (row >= world_matrix.length) return true; //treat below-grid area as solid floor//
    return world_matrix[row][col] != 0;
}
