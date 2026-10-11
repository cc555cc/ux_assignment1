public class Tetrix{
    FCompound body;
    int shape;
    float block_size = 40;
    int[][] space;
    
    public Tetrix (int shape, float x, float y){
        this.shape = shape;
        body = new FCompound();
        setShape(shape);  
        body.setPosition(x,y);  
    }

    private void setShape(int shape){
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

        for (int row = 0; row < space.length; row++){
            for(int block = 0; block < space[row].length; block++){
                if(space[row][block] == 1){
                    FBox block_obj = new FBox(block_size,block_size);
                    block_obj.setPosition(block * block_size, row * block_size);
                    body.addBody(block_obj);
                }
            }
        }
    }

    public void addTo(FWorld world){
        world.add(body);
    }

    public void move (float dx, float dy){
        body.setPosition(body.getX() + dx, body.getY() + dy);
    }
}