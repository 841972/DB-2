import java.io.*;
import java.util.ArrayList;
import java.util.List;
import com.db4o.*;

public class Cliente {
    private List<Cuenta> cuentas;
    private String nombre;
    private String apellidos;
    private String dni;
    private String telefono;
    private String email;
    private Integer edad;

    public Cliente(String nombre, String apellidos, String dni, String telefono, String email, Integer edad) {
        this.nombre = nombre;
        this.apellidos = apellidos;
        this.dni = dni;
        this.telefono = telefono;
        this.email = email;
        this.edad = edad;
        this.cuentas = new ArrayList<Cuenta>();
    }

    public void addCuenta(Cuenta cuenta) {
        this.cuentas.add(cuenta);
    }

    public void removeCuenta(Cuenta cuenta) {
        this.cuentas.remove(cuenta);
    }

    public String getNombre() {
        return this.nombre;
    }

    public String getApellidos() {
        return this.apellidos;
    }

    public String getDni() {
        return this.dni;
    }

    public String getTelefono() {
        return this.telefono;
    }

    public String getEmail() {
        return this.email;
    }

    public Integer getEdad() {
        return this.edad;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setEdad(Integer edad) {
        this.edad = edad;
    }

    public List<Cuenta> getCuentas() {
        return this.cuentas;
    }

    public void setCuentas(List<Cuenta> cuentas) {
        this.cuentas = cuentas;
    }
    public String toString() {
        if (cuentas.size() > 0) {
            String cuentasS = "Cuentas:";
            for (Cuenta cuenta : cuentas) {
                cuentasS += "  " + cuenta.getIBAN();
            }
            return nombre+"/"+apellidos+"/"+dni+"/"+telefono+"/"+email+"/"+edad+"/"+cuentasS;
        }
        return nombre+"/"+apellidos+"/"+dni+"/"+telefono+"/"+email+"/"+edad;
    }
}
