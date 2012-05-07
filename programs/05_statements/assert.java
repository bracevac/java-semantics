/*
1. Assert with true exp with one arg.
2. Assert with true exp with two args. Second arg have a side effect.
  Testing execution of second arg only if first is false.
3. Assert with false with one arg.
4. Assert with false with two args. Second arg of type String.
5. Assert with false with two args. Second arg of type int.
  Testing conversion to String.
*/

class AssertionError {
  String message;

  AssertionError(String message) {
    this.message = message;
  }

  void print() {
    System.out.println("AssertionError: "+message);
  }
}

class main {
  void main(String[] args) {
    assert 1 > 0;
    System.out.println("1 > 0 asserted");

    assert 1>0 : "abc";
    System.out.println("1 > 0 asserted with arg");

    try {
      assert false;
    } catch (AssertionError err) {
      err.print();
    }

    try {
      assert false : "abc";
    } catch (AssertionError err) {
      err.print();
    }

    try {
      assert false : -1;
    } catch (AssertionError err) {
      err.print();
    }

    System.out.println("Done!");
  }
}

// 1 > 0 asserted
// 1 > 0 asserted with arg
// AssertionError:
// AssertionError: abc
// AssertionError: -1
// Done!
