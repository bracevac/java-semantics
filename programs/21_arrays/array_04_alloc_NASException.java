/*
4. Array allocation, NegativeArraySizeException:
  - [negative]
  - [positive][negative]
  - [zero][negative]
*/

public class array_04_alloc_NASException {

  public static void main(String[] args) {
    new main();
    System.out.println("\n"+ "Done!");
  }
}

class main {
  main() {
    int[] v;
    int[][] m;
    try {
     v = new int[-2];
    } catch (RuntimeException re) {
      System.out.println(re);
    }
    try {
     m = new int[2][-3];
    } catch (RuntimeException re) {
      System.out.println(re);
    }
    try {
     m = new int[0][-4];
    } catch (RuntimeException re) {
      System.out.println(re);
    }
  }
}
