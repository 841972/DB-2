import java.io.*;
import java.util.ArrayList;
import java.util.List;
import com.db4o.*;

public class Cuenta {
    private List<Cliente> clientes;
    private String IBAN;
    private double saldo;
    private String fechaCreacion;  
    
    public Cuenta(String IBAN, double saldo, String fechaCreacion) {
        this.IBAN = IBAN;
        this.saldo = saldo;
        this.fechaCreacion = fechaCreacion;
        this.clientes = new ArrayList<Cliente>();
    }

    public void addCliente(Cliente cliente) {
        this.clientes.add(cliente);
    }

    public void removeCliente(Cliente cliente) {
        this.clientes.remove(cliente);
    }

    public double getSaldo() {
        return this.saldo;
    }

    public void setSaldo(double saldo) {
        this.saldo = saldo;
    }

    public String getFechaCreacion() {
        return this.fechaCreacion;
    }

    public String getIBAN() {
        return this.IBAN;
    }

    public void setIBAN(String IBAN) {
        this.IBAN = IBAN;
    }

    public String toString() {
        if (clientes.size() > 0) {
            String clientesS = "Clientes:";
            for (Cliente cliente : clientes) {
                clientesS += "  " + cliente.getNombre();
            }
            return IBAN + "/" + saldo + "/" + fechaCreacion + "/" +clientesS;
        }
        return IBAN + "/" + saldo + "/" + fechaCreacion;
    }
}
