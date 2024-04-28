package uni;
import javax.persistence.*;

import java.sql.Timestamp;
@Entity(name = "Transferencia")
public class Transferencia extends Operacion{
    @ManyToMany()
    @JoinColumn(name = "CuentaDestino")
    private Cuenta cuentaDestino;
    public Transferencia(Double cantidad, Timestamp fecha, Cuenta cuenta, Cuenta cuentaDestino) {
        super(cantidad, fecha, cuenta);
        this.cuentaDestino = cuentaDestino;
    }
}
