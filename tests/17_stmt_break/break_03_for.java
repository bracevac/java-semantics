// Testing break inside for loop

public class break_03_for {

  public static void main(String[] args) {
    int i;
    for(i=0; i<10; i++) {
      if (i >= 5) break;
      System.out.print(i+" ");
    }
    System.out.println();
    System.out.println("final i = "+ i);
    System.out.println("Done!");
  }
}

// 0 1 2 3 4
// final i = 5
// Done!
