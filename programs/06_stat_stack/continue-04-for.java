// Testing continue inside for loop

class main {

  void main(String[] args) {
    for(int i=0; i<10; i++) {
      if (i % 2 != 0) continue;
      System.out.print(i+" ");
    }
    System.out.println("\n"+ "Done!");
  }
}

// 0 2 4 6 8
// Done!
