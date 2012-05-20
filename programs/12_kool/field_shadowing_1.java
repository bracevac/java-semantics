// Testing shadowing of a field by another field and
// whether the object stack environment works.

class C1 {
  int x, y;

  C1() {}
  void setx1(int v) { x = v; }
  void sety1(int v) { y = v; }
  int getx1() { return x; }
  int gety1() { return y; }
}

class C2 extends C1 {
  int y;

  C2() {}
  void sety2(int v) { y = v; }
  int getx2() { return x; }
  int gety2() { return y; }
}

class main {

  main(String[] args) {
    C2 o2 = new C2();
    o2.setx1(11);
    o2.sety1(12);
    o2.sety2(99);
    System.out.print(o2.getx1()+ " ");
    System.out.print(o2.gety1()+ " ");
    System.out.print(o2.getx2()+ " ");
    System.out.println(o2.gety2());
    System.out.println("Done!");
  }
}

public class field_shadowing_1 {
  public static void main(String[] args) {
    new main(args);
  }
}

// 11 12 11 99
// Done!
