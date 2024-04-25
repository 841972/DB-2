import java.io.*;
import java.util.ArrayList;
import java.util.List;
import com.db4o.*;

public class CuentaCorriente extends Cuenta {
    private Integer oficina;

    public CuentaCorriente(String IBAN, double saldo, String fechaCreacion, Integer oficina) {
        super(IBAN, saldo, fechaCreacion);
        this.oficina = oficina;
    }

    public Integer getOficina() {
        return this.oficina;
    }

    public void setOficina(Integer oficina) {
        this.oficina = oficina;
    }

    @Override
    public String toString() {
        return super.toString() + "/" + oficina;
    }
}