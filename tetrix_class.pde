public class Tetrix{
    FCompound body;
    int shape;
    float block_size = 40;
    int[][] space;

    float x;
    float y;

    float lowest_y = 0;
    float highest_y = 0;
    float leftest_x = 0;
    float rightest_x = 0;

    boolean set = false;
    
    public Tetrix (int shape, float x, float y){
        this.shape = shape;
        this.x = x;
        this.y = y;

        body = new FCompound();
        setShape(shape,x,y);  
        body.setPosition(x,y);
        body.setStatic(true);
    }

    private void setShape(int shape,float init_x, float init_y){
        switch (shape){
            case 1:
                space = new int[][] {{1,1},{1,1}}; break;
            case 2: 
                space = new int[][] {{1,1,1,1},{0,0,0,0},{0,0,0,0},{0,0,0,0}}; break;
            case 3: 
                space = new int[][] {{1,0,0},{1,0,0},{1,1,0}}; break;
            case 4:
                space = new int[][] {{1,0,0},{1,0,0},{1,1,0}}; break;
            case 5:
                space = new int[][] {{1,1,1},{0,1,0},{0,0,0}}; break;
            case 6: 
                space = new int[][] {{0,1,1},{1,1,0},{0,0,0}}; break;
            case 7:
                space = new int[][] {{1,1,0}, {0,1,1},{0,0,0}}; break;
            default:
                space = new int[][] {{1,1},{1,1}}; break;
        }

        leftest_x = init_x;
        rightest_x = init_x + space[0].length * block_size;
        highest_y = init_y;
        lowest_y = init_y + space.length * block_size;

        for (int row = 0; row < space.length; row++){
            for(int block = 0; block < space[row].length; block++){
                if(space[row][block] == 1){
                    FBox block_obj = new FBox(block_size,block_size);
                    block_obj.setPosition(block * block_size + block_size/2, row * block_size + block_size/2);  // so (x,y) is the top-left corner
                    body.addBody(block_obj);
                }
            }
        }
    }

    public void addTo(FWorld world){
        world.add(body);
    }

    public void move(float dy){
        body.setPosition(this.x, body.getY() + dy);
        highest_y += dy;
        lowest_y += dy;
    }

    public void set(){
        this.set = true;
    }
}