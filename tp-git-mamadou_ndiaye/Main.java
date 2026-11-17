// Le fichier doit s'appeler Main.java, comme la classe publique Main
public class Main {
    static int addition(int a, int b) { return a + b; }
    static int soustraction(int a, int b) { return a - b; }
    static int multiplication(int a, int b) { return a * b; }
    static int division(int a, int b) { return a / b; }
    static int puissance(int base, int exposant) { int r = 1; for (int i = 0; i < exposant; i++) r *= base; return r; }
    static int modulo(int a, int b) { return a % b; }
    public static void main(String[] args) {
        System.out.println("2 + 3 = " + addition(2, 3));
        System.out.println("5 - 2 = " + soustraction(5, 2));
        System.out.println("4 * 3 = " + multiplication(4, 3));
        System.out.println("10 / 2 = " + division(10, 2));
        System.out.println("2 ^ 10 = " + puissance(2, 10));
        System.out.println("10 % 3 = " + modulo(10, 3));
    }
}
