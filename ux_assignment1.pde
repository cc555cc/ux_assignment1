import fisica.*;

FWorld world;
Tetrix tetrix_piece;

void setup(){
    size(1920,1050);
    Fisica.init(this);
    world = new FWorld();
    world.setGravity(0,800);
    world.setEdges(); //define walls and floor at windows edge//
}

void draw(){
    background(255);
    world.step();
    world.draw();
}

void mousePressed(){
    Tetrix t = new Tetrix(int(random(1,9)),mouseX,mouseY);
    t.addTo(world);
}