package uni;
import java.util.Date;

import javax.persistence.*;

@Entity
@Table(name = "Cuenta_Corriente")
public class Cuenta_Corriente extends Cuenta{
    
    @ManyToOne()
    @JoinColumn(name = "oficina")
    private Oficina oficina;


    public Cuenta_Corriente(String iban, Oficina oficina, Date fechaCreacion, String numCuenta) {
        super(iban, numCuenta, 0.0, fechaCreacion);
        this.oficina = oficina;
    }

    public Cuenta_Corriente(String iban, Oficina oficina, Date fechaCreacion, String numCuenta, Double saldo) {
        super(iban, numCuenta, saldo, fechaCreacion);
        this.oficina = oficina;
    }

    public Oficina getOficina() {
        return this.oficina;
    }
    public void setOficina(Oficina oficina) {
        this.oficina = oficina;
    }
    @Override
    public String toString() {
        return super.toString() + "Oficina: " + this.oficina + "\n";
    }
}