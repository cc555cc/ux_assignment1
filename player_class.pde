class Player{
    float x;
    float y;
    float w = 30;
    float h = 46;
    float vx = 0;
    float vy = 0;
    float previous_bottom = 0;
    boolean on_ground = false;

    Player(float x, float y){
        this.x = x;
        this.y = y;
        previous_bottom = bottom();
    }

    void update(){
        previous_bottom = bottom();

        float target_vx = 0;
        if (a_pressed && !d_pressed) target_vx = -PLAYER_MOVE_SPEED;
        if (d_pressed && !a_pressed) target_vx = PLAYER_MOVE_SPEED;

        if (target_vx == 0){
            vx *= 0.72;
            if (abs(vx) < 0.05) vx = 0;
        } else {
            vx = target_vx;
        }

        if (jump_pressed && on_ground){
            vy = PLAYER_JUMP_SPEED;
            on_ground = false;
        }
        jump_pressed = false; //single jump event per key press//

        vy += PLAYER_GRAVITY;
        if (s_pressed) vy += 0.6;
        if (vy > PLAYER_MAX_FALL_SPEED) vy = PLAYER_MAX_FALL_SPEED;

        x += vx;
        resolveHorizontalWorldCollision();

        y += vy;
        resolveVerticalWorldCollision();

        constrainToWorld();

        if (top() > height + CELL_SIZE){
            game_over = true;
        }
    }

    void resolveHorizontalWorldCollision(){
        int min_row = floor(top() / CELL_SIZE);
        int max_row = floor((bottom() - 0.001) / CELL_SIZE);

        if (vx > 0){
            int hit_col = floor((right() - 0.001) / CELL_SIZE);
            for (int row = min_row; row <= max_row; row++){
                if (isSolidCell(row, hit_col)){
                    x = hit_col * CELL_SIZE - w * 0.5;
                    vx = 0;
                    break;
                }
            }
        } else if (vx < 0){
            int hit_col = floor(left() / CELL_SIZE);
            for (int row = min_row; row <= max_row; row++){
                if (isSolidCell(row, hit_col)){
                    x = (hit_col + 1) * CELL_SIZE + w * 0.5;
                    vx = 0;
                    break;
                }
            }
        }
    }

    void resolveVerticalWorldCollision(){
        on_ground = false;

        int min_col = floor(left() / CELL_SIZE);
        int max_col = floor((right() - 0.001) / CELL_SIZE);

        if (vy > 0){
            int hit_row = floor((bottom() - 0.001) / CELL_SIZE);
            for (int col = min_col; col <= max_col; col++){
                if (isSolidCell(hit_row, col)){
                    y = hit_row * CELL_SIZE - h * 0.5;
                    vy = 0;
                    on_ground = true;
                    return;
                }
            }
        } else if (vy < 0){
            int hit_row = floor(top() / CELL_SIZE);
            for (int col = min_col; col <= max_col; col++){
                if (isSolidCell(hit_row, col)){
                    y = (hit_row + 1) * CELL_SIZE + h * 0.5;
                    vy = 0;
                    return;
                }
            }
        }
    }

    void constrainToWorld(){
        if (left() < 0) x = w * 0.5;
        if (right() > width) x = width - w * 0.5;
        if (top() < 0){
            y = h * 0.5;
            vy = max(vy, 0);
        }
        if (bottom() > height){
            y = height - h * 0.5;
            vy = 0;
            on_ground = true;
        }
    }

    void draw(){
        pushStyle();
        fill(#355CFF);
        stroke(#0B1D7A);
        strokeWeight(3);
        rectMode(CENTER);
        rect(x, y, w, h, 8);
        stroke(#FFFFFF);
        strokeWeight(2);
        line(x - 8, y, x + 8, y);
        line(x, y - 8, x, y + 8);
        fill(20);
        textAlign(CENTER, BOTTOM);
        textSize(14);
        text("PLAYER", x, y - h * 0.5 - 6);
        popStyle();
    }

    float left(){ return x - w * 0.5; }
    float right(){ return x + w * 0.5; }
    float top(){ return y - h * 0.5; }
    float bottom(){ return y + h * 0.5; }
}
