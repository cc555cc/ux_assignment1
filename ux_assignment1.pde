import fisica.*;

FWorld world;
Tetrix tetrix_piece;
ArrayList<Tetrix> registered_tetrix = new ArrayList<Tetrix>();
int[][] world_matrix = new int[26][48];

float last_move_time = 0;
float global_clock = 0;
float last_spawn_time = 0;

Tetrix current_tetrix = null;
boolean show_matrix = true; //debug: draw world_matrix on screen//

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
    size(1920,1050);
    Fisica.init(this);
    world = new FWorld();
    world.setEdges(); //define walls and floor at windows edge//
    global_clock = millis();
}

void draw(){
    background(255);
    world.step();

    if(global_clock - last_move_time >= 1000){
        for (Tetrix t : registered_tetrix){
            if(t.set) continue; //landed pieces stay put//
            if(!t.fits(t.x, t.y + t.block_size)){ //something is under one of its blocks//
                t.set();
                continue;
            }  
            t.moveTo(t.x, t.y + t.block_size);      
        }
        last_move_time = millis(); //reset the timer even if nothing moved//
    }else if(current_tetrix == null || current_tetrix.set){ //if this is the first tetrix, or the last one is fixed//
        //create new tetrix object//
        Tetrix t = new Tetrix(int(random(1,9)),int(random(0,45))*40,0);
        registered_tetrix.add(t); //add t to the list of tetrix//
        t.addTo(world); //add t's body to fisica's world//
        current_tetrix = t; //set it as current tetrix being controlled//
        last_spawn_time = millis(); //mark current time as the last time a tetrix is spawned//
    }
    world.draw();
    if(show_matrix) drawMatrix();

    global_clock = millis(); //advance global clock//
}

void keyPressed(){
    if(key == ENTER || key == RETURN){
        //drop to lowest point possible)//
        float target_y = current_tetrix.y;
        while(current_tetrix.fits(current_tetrix.x, target_y + 40)){
            target_y += 40;
        }
        current_tetrix.moveTo(current_tetrix.x, target_y);
        current_tetrix.set();
    }else if(keyCode == LEFT){
        //move current tetrix left by 40//
        current_tetrix.left();
    }else if(keyCode == RIGHT){
        //move current tetrix right by 40//
        current_tetrix.right();
    }else if(keyCode == ' '){
        current_tetrix.rotate();
    }
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
            rect(col * 40, row * 40, 40, 40);
            fill(0, 120);
            text(world_matrix[row][col], col * 40 + 20, row * 40 + 20);
        }
    }
    popStyle();
}
