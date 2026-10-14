public class Tetrix{
    FCompound body;
    int shape;
    float block_size = 40;
    int[][] space;

    float x;
    float y;

    float height;
    float width;

    float lowest_y = 0;
    float highest_y = 0;
    float leftest_x = 0;
    float rightest_x = 0;

    boolean set = false;

    color block_color;
    
    public Tetrix (int shape, float x, float y){
        this.shape = shape;
        this.x = x;
        this.y = y;
        
        //set a random color before the blocks are built, so buildBody can use it//
        int random = int(random(0, block_colors.length));
        this.block_color = block_colors[random];

        body = new FCompound();
        setShape(shape,x,y);  
        body.setPosition(x,y);
        body.setStatic(true);

    }

    private void setShape(int shape,float init_x, float init_y){
        switch (shape){
            case 1:
                space = new int[][] {{1,1},{1,1}};
                break;
            case 2: 
                space = new int[][] {{1,1,1,1},{0,0,0,0},{0,0,0,0},{0,0,0,0}};
                break;
            case 3: 
                space = new int[][] {{1,0,0},{1,0,0},{1,1,0}};
                break;
            case 4:
                space = new int[][] {{1,0,0},{1,0,0},{1,1,0}};
                break;
            case 5:
                space = new int[][] {{1,1,1},{0,1,0},{0,0,0}};
                break;
            case 6: 
                space = new int[][] {{0,1,1},{1,1,0},{0,0,0}};
                break;
            case 7:
                space = new int[][] {{1,1,0}, {0,1,1},{0,0,0}};
                break;
            default:
                space = new int[][] {{1,1},{1,1}};
                break;
        }

        buildBody(init_x, init_y);
    }

    private void buildBody(float init_x, float init_y){
        int max_row = 0; //furthest row that has a block//
        int max_col = 0; //furthest column that has a block//

        for (int row = 0; row < space.length; row++){
            for(int block = 0; block < space[row].length; block++){
                if(space[row][block] == 1){
                    FBox block_obj = new FBox(block_size,block_size);
                    block_obj.setFillColor(this.block_color);    // inside color
                    block_obj.setStrokeColor(#000000);           // outline color
                    block_obj.setStrokeWeight(2);           
                    block_obj.setNoStroke();                
                    block_obj.setPosition(block * block_size + block_size/2, row * block_size + block_size/2);  // so (x,y) is the top-left corner
                    body.addBody(block_obj);

                    max_row = max(max_row, row);
                    max_col = max(max_col, block);
                }
            }
        }

        //size of the actual blocks, padding zeros are ignored//
        width = (max_col + 1) * block_size;
        height = (max_row + 1) * block_size;

        leftest_x = init_x;
        rightest_x = init_x + width;
        highest_y = init_y;
        lowest_y = init_y + height;
    }

    public void addTo(FWorld world){
        world.add(body);
    }

    //move the piece to (nx, ny) and keep the bounds in sync//
    public void moveTo(float nx, float ny){
        leftest_x += nx - x;
        rightest_x += nx - x;
        highest_y += ny - y;
        lowest_y += ny - y;
        x = nx;
        y = ny;
        body.setPosition(x, y);
    }

    //true if every block of the piece would be inside the grid and on an empty cell at (nx, ny)//
    public boolean fits(float nx, float ny){
        for (int x_index = 0; x_index < space[0].length; x_index++){
            for(int y_index = 0; y_index < space.length; y_index++){
                if (space[y_index][x_index] == 1){
                    int row = int(ny/40) + y_index;
                    int col = int(nx/40) + x_index;
                    if (row >= world_matrix.length || col < 0 || col >= world_matrix[0].length) return false; //outside the grid//
                    if (world_matrix[row][col] != 0) return false; //cell already taken//
                }
            }
        }
        return true;
    }

    public void set(){
        this.set = true;
        for (int x_index = 0; x_index < space[0].length; x_index++){
            for(int y_index = 0; y_index < space.length; y_index++){
                if (space[y_index][x_index] == 1){
                    world_matrix[int(y/40) + y_index][int(x/40) + x_index] = 1;
                }
            }
        }
    }

    public void left(){
        if (fits(x - block_size, y)) moveTo(x - block_size, y); 
    }

    public void right(){
        if (fits(x + block_size, y)) moveTo(x + block_size, y); 
    }


    //method for rotating the 1's in the matrix, set a new space matrix and build a new body for the block//
    public void rotate(){
        int[][] new_space = new int[space.length][space.length];
        int len = space.length;
        for (int i = 0; i < space.length; i++){
            for(int j = 0; j < space.length; j++){
                new_space[len - 1 - i][j] = space[j][i];
            }
        }

        if(fits(x,y)){
            space = new_space;
            world.remove(this.body);
            body = new FCompound();
            buildBody(x,y); //add a new FBox to the body using new space matrix//
            body.setPosition(x,y);
            body.setStatic(true);
            world.add(body);
        }
    }
}