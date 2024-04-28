package uni;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;

@Entity(name = "Cuenta_Ahorro")
public class Cuenta_Ahorro extends Cuenta{
    @Column(name = "Interes")
    private Double interes;

        public Cuenta_Ahorro(String iban, Double interes, Date fechaCreacion, String numCuenta) {
            super(iban, numCuenta, 0.0, fechaCreacion);
            this.interes = interes;
        }
    
        public Cuenta_Ahorro(String iban, Double interes, Date fechaCreacion, String numCuenta, Double saldo) {
            super(iban, numCuenta, saldo, fechaCreacion);
            this.interes = interes;
        }
    public Double getInteres() {
        return this.interes;
    }
    public void setInteres(Double interes) {
        this.interes = interes;
    }
    @Override
    public String toString() {
        return super.toString() + "Interes: " + this.interes + "\n";
    }
    
}
