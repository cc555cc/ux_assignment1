class GameMenu {
    boolean playing = false;
    int difficulty = 1; // Medium by default.
    String[] difficulty_names = {"Easy", "Medium", "Hard"};
    int[] fall_intervals = {1000, 500, 200};

    boolean mouse_was_pressed = false;
    boolean clicked = false;

    // Returns true once the player clicks Play.
    boolean startScreen(){
        if (playing) return true;

        clicked = mousePressed && mouseButton == LEFT && !mouse_was_pressed;
        mouse_was_pressed = mousePressed;

        pushStyle();
        background(240);
        rectMode(CORNER);
        textAlign(CENTER, CENTER);

        float x = width * 0.5 - 230;
        float y = height * 0.5 - 170;

        fill(0);
        textSize(32);
        text("Tetrix Climb", width * 0.5, y);
        textSize(20);
        text("Falling speed", width * 0.5, y + 70);

        for (int i = 0; i < difficulty_names.length; i++){
            if (button(difficulty_names[i], x + i * 160, y + 110,
                       140, 55, difficulty == i)){
                difficulty = i;
            }
        }

        if (button("Play", width * 0.5 - 110, y + 215, 220, 60, false)){
            playing = true;
        }

        popStyle();
        return playing;
    }

    boolean gameOverScreen(){
        return endScreen("Game Over");
    }

    // 0 = waiting, 1 = Play Again, 2 = Play Next Level.
    int youWinScreen(int total_score){
        boolean play_again = endScreen("You Win!");
        pushStyle();
        fill(0);
        textAlign(CENTER, CENTER);
        textSize(24);
        text("Total score: " + total_score, width * 0.5, height * 0.5 - 25);
        rectMode(CORNER);
        boolean play_next_level = button("Play Next Level", width * 0.5 - 110,
                                         height * 0.5 + 100, 220, 60, false);
        popStyle();
        if (play_again) return 1;
        if (play_next_level) return 2;
        return 0;
    }

    // Returns true when Play Again is clicked.
    boolean endScreen(String title){
        clicked = mousePressed && mouseButton == LEFT && !mouse_was_pressed;
        mouse_was_pressed = mousePressed;

        pushStyle();
        background(240);
        rectMode(CORNER);
        textAlign(CENTER, CENTER);
        fill(0);
        textSize(32);
        text(title, width * 0.5, height * 0.5 - 80);

        boolean play_again = button("Play Again", width * 0.5 - 110,
                                    height * 0.5 + 20, 220, 60, false);
        popStyle();
        return play_again;
    }

    int getFallInterval(){
        return fall_intervals[difficulty];
    }

    boolean button(String label, float x, float y, float w, float h, boolean selected){
        boolean hovered = mouseX >= x && mouseX <= x + w &&
                          mouseY >= y && mouseY <= y + h;

        stroke(0);
        strokeWeight(selected ? 3 : 1);
        if (selected) fill(150, 190, 230);
        else if (hovered) fill(220);
        else fill(255);
        rect(x, y, w, h);

        fill(0);
        textSize(20);
        text(label, x + w * 0.5, y + h * 0.5);
        return hovered && clicked;
    }
}
