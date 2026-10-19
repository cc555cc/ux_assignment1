class GameProgress{
    int current_level = 1;
    int score = 0;

    // Pass the elapsed gameplay time in milliseconds, not the current millis().
    // Difficulty matches GameMenu: 0 = Easy, 1 = Medium, 2 = Hard.
    int calculateScore(int completion_time_ms, int difficulty){
        if (completion_time_ms <= 0){
            score = 0;
            return score;
        }

        float seconds = max(completion_time_ms / 1000.0, 1);
        int multiplier = constrain(difficulty, 0, 2) + 1;

        score = round((60000.0 / seconds) * multiplier);
        return score;
    }
}
