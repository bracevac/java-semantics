interface I {
 int i = 11;
}

class A {
  private static int i = 7;
}

class Exercise4_2_2 extends A implements I {
  static int j = i+1;

  public static void main(String args[]) {
    System.out.println(j);
  }

}
