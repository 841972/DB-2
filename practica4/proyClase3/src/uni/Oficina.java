package uni;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.*;

@Entity(name = "Oficina")
public class Oficina {
    @Id
    @Column(name = "Codigo")
    private int codigo;

    @Column(name = "Direccion", nullable = false)
    private String direccion;

    @Column(name = "Telefono", nullable = false)
    private String telefono;

    @OneToMany(mappedBy = "oficina",cascade = CascadeType.ALL)
    private List<Cuenta_Corriente> cuentasCorrientes;

    @OneToMany(mappedBy = "oficina",cascade = CascadeType.ALL)
    private List<Ingreso> ingresos;

    @OneToMany(mappedBy = "oficina",cascade = CascadeType.ALL)
    private List<Retirada> retiradas;




    public Oficina(int codigo, String direccion, String telefono) {
        this.codigo = codigo;
        this.direccion = direccion;
        this.telefono = telefono;
        this.cuentasCorrientes = new ArrayList<>();
        this.ingresos = new ArrayList<>();
        this.retiradas = new ArrayList<>();
    }

    public int getCodigo() {
        return codigo;
    }

    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public List<Cuenta_Corriente> getCuentasCorrientes() {
        return cuentasCorrientes;
    }

    public void setCuentasCorrientes(List<Cuenta_Corriente> cuentasCorrientes) {
        this.cuentasCorrientes = cuentasCorrientes;
    }

    public List<Ingreso> getIngresos() {
        return ingresos;
    }

    public void setIngresos(List<Ingreso> ingresos) {
        this.ingresos = ingresos;
    }

    public List<Retirada> getRetiradas() {
        return retiradas;
    }

    public void setRetiradas(List<Retirada> retiradas) {
        this.retiradas = retiradas;
    }
    @Override
    public String toString() {
        return "Oficina{" +
                "codigo=" + codigo +
                ", direccion='" + direccion + '\'' +
                ", telefono=" + telefono +
                '}';
    }
}
