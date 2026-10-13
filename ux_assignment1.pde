import fisica.*;

FWorld world;
Tetrix tetrix_piece;
//ArrayList<FBody> toFreeze = new ArrayList<FBody>();
ArrayList<Tetrix> registered_tetrix = new ArrayList<Tetrix>();
int[][] world_matrix = new int[26][48];

float last_move_time = 0;
float global_clock = 0;
float last_spawn_time = 0;

Tetrix current_tetrix = null;

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
//    for (FBody b : toFreeze) b.setStatic(true);
//    toFreeze.clear();
    if(global_clock - last_move_time >= 1000){
        for (Tetrix t : registered_tetrix){
            if(t.set) continue;                  // landed pieces stay put
            if(t.lowest_y + t.block_size > height){
                t.set();                         // next step would go past the floor
            }else{
                t.move(t.block_size);
            }
        }
        last_move_time = millis();
    }else if(current_tetrix == null || current_tetrix.set){ //if this is the first tetrix, or the last one is fixed//
        //create new tetrix object//
        Tetrix t = new Tetrix(1,int(random(0,47))*40,0);
        registered_tetrix.add(t); //add t to the list of tetrix//
        t.addTo(world); //add t's body to fisica's world//
        current_tetrix = t; //set it as current tetrix being controlled//
        last_spawn_time = millis(); //mark current time as the last time a tetrix is spawned//
    }
    world.draw();

    global_clock = millis(); //advance global clock//
}

void keyPressed(){
    if(key == ENTER || key == RETURN){
        //drop to lowest point possible)//
    }else if(key == LEFT){
        //move current tetrix left by 40//
    }else if(key == RIGHT){
        //move current tetrix right by 40//
    }
}
