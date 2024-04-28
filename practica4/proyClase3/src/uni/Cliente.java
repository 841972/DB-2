package uni;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity(name = "Cliente")
public class Cliente {

    @Id
    @Column(name = "DNI", nullable = false)
    private String dni;

    @Column(name = "Telefono", nullable = false)
    private String telefono;

    @Column(name = "Nombre", nullable = false)
    private String nombre;

    @Column(name = "Apellidos", nullable = false)
    private String apellidos;

    @Column(name = "Edad", nullable = false)
    private Integer edad;

    @Column(name = "Direccion", nullable = false)
    private String direccion;

    @Column(name = "Email")
    private String email;

   @ManyToMany()
   private List<Cuenta> cuentas;

    public Cliente(String dni, Integer edad, String nombre, String apellidos, String direccion, String telefono, String email) {
        this.dni = dni;
        this.telefono = telefono;
        this.nombre = nombre;
        this.apellidos = apellidos;
        this.edad = edad;
        this.direccion = direccion;
        this.email = email;
        this.cuentas = new ArrayList<>();
    }


    public String getDni() {
        return this.dni;
    }

    public Integer getEdad() {
        return this.edad;
    }

    public String getNombre() {
        return this.nombre;
    }

    public String getApellidos() {
        return this.apellidos;
    }

    public String getEmail() {
        return this.email;
    }

    public String getTelefono() {
        return this.telefono;
    }

    public String getDireccion() {
        return this.direccion;
    }
    public List<Cuenta> getCuentas() {
        return this.cuentas;
    }


    @Override
    public String toString() {
        return "{" +
                " dni='" + getDni() + "'" +
                ", nombre='" + getNombre() + "'" +
                ", apellidos='" + getApellidos() + "'" +
                ", email='" + getEmail() + "'" +
                ", telefono='" + getTelefono() + "'" +
                ", direccion='" + getDireccion() + "'" +
                ", edad='" + getEdad() + "'" +
                ", cuentas='" + getCuentas() + "'"+
                "}";
    }
}