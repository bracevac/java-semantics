/*
2. Array allocation. Multidim array allocation in one piece:
  - three dims, type int.
*/

public class array_02_alloc_multidim {

  public static void main(String[] args) {
    new main();
    System.out.println("\n"+ "Done!");
  }
}

class main {
  main() {
    int[][][] threeDim = new int[2+0][3+0][4+0];

    for(int i=0; i<2; i++)
      for(int j=0; j<3; j++)
        for(int k=0; k<4; k++)
          threeDim[i][j][k] = i+j+k;
    for(int i=0; i<2; i++)
      for(int j=0; j<3; j++)
        for(int k=0; k<4; k++)
          System.out.print(threeDim[i][j][k] + " ");
    System.out.println();
  }
}
