package uni;

import java.util.ArrayList;
import java.util.List;
import java.util.Date;

import javax.persistence.*;

@Entity(name = "Cuenta")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
public class Cuenta {

    @Id
    @Column(name = "IBAN", nullable = false)
    private String iban;

    @Column(name = "Num_cuenta", nullable = false)
    private String numCuenta;

    @Column(name = "Saldo", precision = 20, scale = 2, nullable = false, columnDefinition = "numeric default 0.0")
    private Double saldo;

    @Column(name = "Fecha_creacion", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date fechaCreacion;

    @ManyToMany(mappedBy = "cuentas", cascade = CascadeType.PERSIST)
    protected List<Cliente> clientes;

     @OneToMany(mappedBy="cuenta", cascade = CascadeType.ALL)
    protected List<Ingreso> ingresos;
    @OneToMany(mappedBy="cuenta", cascade = CascadeType.ALL)
    protected List<Retirada> retiradas;

    @OneToMany(mappedBy="CuentaDestino", cascade = CascadeType.ALL)
    protected List<Transferencia> transferencias;

    public Cuenta(String iban, String numCuenta, Double saldo, Date fechaCreacion) {
        this.iban = iban;
        this.numCuenta = numCuenta;
        this.saldo = saldo;
        this.fechaCreacion = fechaCreacion;
        this.clientes = new ArrayList<>();
        this.ingresos = new ArrayList<>();
        this.retiradas = new ArrayList<>();
        this.transferencias = new ArrayList<>();
        
    }
    public Cuenta(String iban, String numCuenta, Date fechaCreacion) {
        this(iban, numCuenta, 0.0, fechaCreacion);
        this.clientes = new ArrayList<>();
        this.ingresos = new ArrayList<>();
        this.retiradas = new ArrayList<>();
        this.transferencias = new ArrayList<>();
    }


    public String getIban() {
        return this.iban;
    }

    public String getNumCuenta() {
        return this.numCuenta;
    }

    public Double getSaldo() {
        return this.saldo;
    }
    public Date getFechaCreacion() {
        return this.fechaCreacion;
    }

    public List<Cliente> getClientes() {
        return this.clientes;
    }

    public List<Ingreso> getIngresos() {
        return this.ingresos;
    }
    public List<Retirada> getRetiradas() {
        return this.retiradas;
    }

    public List<Transferencia> getTransferencias() {
        return this.transferencias;
    }
    public void setIban(String iban) {
        this.iban = iban;
    }

    public void setNumCuenta(String numCuenta) {
        this.numCuenta = numCuenta;
    }

    public void setSaldo(Double saldo) {
        this.saldo = saldo;
    }

    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public void setClientes(List<Cliente> clientes) {
        this.clientes = clientes;
    }

    public void setIngresos(List<Ingreso> ingresos) {
        this.ingresos = ingresos;
    }
    public void setRetiradas(List<Retirada> retiradas) {
        this.retiradas = retiradas;
    }

    public void setTransferencias(List<Transferencia> transferencias) {
        this.transferencias = transferencias;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((iban == null) ? 0 : iban.hashCode());
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
        Cuenta other = (Cuenta) obj;
        if (iban == null) {
            if (other.iban != null)
                return false;
        } else if (!iban.equals(other.iban))
            return false;
        return true;
    }

        @Override
        public String toString() {
            return "Cuenta [IBAN=" + getIban() + ", Num_cuenta=" + getNumCuenta() + ", Saldo=" + getSaldo() + ", Fecha_creacion=" + getFechaCreacion() + "]";
        }
} 
