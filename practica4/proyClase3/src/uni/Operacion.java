
package uni;


import java.sql.Timestamp;

import javax.persistence.*;

@Entity(name = "Operacion")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
public class Operacion {
    @Id
    @GeneratedValue
    @Column(name = "Numero_Operacion")
    private Long numeroOperacion;

    @Column(name = "Momento", nullable = false)
    private Timestamp momento;

    @Column(name = "Cantidad", nullable = false, precision = 20, scale = 2)
    private Double cantidad;

    @Column(name = "Descripcion", nullable = false)
    private String descripcion;

    @ManyToOne
    @JoinColumn(name = "Cuenta_Origen")
    protected Cuenta cuenta;

    public Operacion(Double cantidad, Timestamp fecha, Cuenta cuenta) {
        this.cantidad = cantidad;
        this.momento = fecha;
        this.cuenta = cuenta;
    }

    public Long getNumeroOperacion() {
        return this.numeroOperacion;
    }

    public Timestamp getMomento() {
        return this.momento;
    }

    public Double getCantidad() {
        return this.cantidad;
    }

    public String getDescripcion() {
        return this.descripcion;
    }

    public Cuenta getCuenta() {
        return this.cuenta;
    }

    public void setNumeroOperacion(Long numeroOperacion) {
        this.numeroOperacion = numeroOperacion;
    }

    public void setMomento(Timestamp momento) {
        this.momento = momento;
    }

    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public void setCuenta(Cuenta cuenta) {
        this.cuenta = cuenta;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((getNumeroOperacion() == null) ? 0 : getNumeroOperacion().hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Operacion other = (Operacion) obj;
        if (getNumeroOperacion() == null) {
            if (other.getNumeroOperacion() != null)
                return false;
        } else if (!getNumeroOperacion().equals(other.getNumeroOperacion()))
            return false;
        return true;
    }

    public String toString() {
        return "Operacion [numeroOperacion=" + getNumeroOperacion() + ", momento=" + getMomento() + ", cantidad=" + getCantidad()
                + ", descripcion=" + getDescripcion() + ", cuenta=" + getCuenta() + "]";
    }

    
}
