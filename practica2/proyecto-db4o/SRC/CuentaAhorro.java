import java.io.*;
import java.util.ArrayList;
import java.util.List;
import com.db4o.*;

public class CuentaAhorro extends Cuenta {
    private double interes;

    public CuentaAhorro(String IBAN, double saldo, String fechaCreacion, double interes) {
        super(IBAN, saldo, fechaCreacion);
        this.interes = interes;
    }

    public double getInteres() {
        return this.interes;
    }

    public void setInteres(double interes) {
        this.interes = interes;
    }

    @Override
    public String toString() {
        return super.toString() + "/" + interes;
    }
}