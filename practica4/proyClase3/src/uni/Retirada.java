package uni;

import java.sql.Timestamp;
import javax.persistence.*;

@Entity(name = "Retirada")
public class Retirada extends Operacion {
    @ManyToOne
    @JoinColumn(name = "Codigo_Oficina")
    private Oficina oficina;

    public Retirada(double cantidad, Timestamp fecha, Cuenta cuenta, Oficina codigoOficina) {
        super(cantidad, fecha, cuenta);
        this.oficina = codigoOficina;
    }

    public Oficina getCodigoOficina() {
        return oficina;
    }

    public void setCodigoOficina(Oficina codigoOficina) {
        this.oficina = codigoOficina;
    }

    @Override
    public String toString() {
        return super.toString() + "Codigo de Oficina: " + this.oficina + "\n";
    }
}