// Testing try with multiple catch clauses

class Exception {
  void Exception() {
  }
}

class Exception2 extends Exception {
  void Exception2() {
  }
}

class Exception3 extends Exception2 {
  void Exception3() {
  }
}

class main {
  void main(String[] args) {
    try {
      try {
        throw new Exception2();

        System.out.println("No exception");
      } catch (Exception3 e3) {
        System.out.println("caught exception3");
      } finally {
        System.out.println("finally after uncaught exception");
      }
    } finally {
      System.out.println("finally 2 after uncaught exception");
    }
  }
}

// finally after uncaught exception
// finally 2 after uncaught exception
// Thread terminated with exception: Exception2

