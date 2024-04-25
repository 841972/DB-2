/**
 * Example extracted and adapted from http://community.versant.com/documentation/reference/db4o-8.0/java/tutorial/docs/FirstGlance.html
 * Date: March 15, 2014
 */
 
import java.io.*;
import com.db4o.*;
import com.db4o.query.Constraint;
import com.db4o.query.Query;

public class ClienteCuentaExample extends Util {

    final static String DB_FOLDER = "./DB-FILES";
    //final static String DB_FOLDER = System.getProperty("user.home");
    
    final static String DB_FILE = "Banco.db4o";
    
    final static String DB4OFILENAME = DB_FOLDER + "/" + DB_FILE;
	    
    public static void main(String[] args) {
        new File(DB4OFILENAME).delete();
        accessDb4o();
        new File(DB4OFILENAME).delete();
        ObjectContainer db = Db4oEmbedded.openFile(Db4oEmbedded
                .newConfiguration(), DB4OFILENAME);
        try {
            storeFirstClient(db);
            System.out.println();
            storeSecondClient(db);
            System.out.println();
            retrieveAllClientQBE(db);
            System.out.println();
            retrieveClientByName(db);
            System.out.println();
            retrieveClientByExactAge(db);
            System.out.println();
            retrieveClientByAge(db);
            System.out.println();
            storeFirstCuenta(db);
            System.out.println();
            storeSecondCuenta(db);
            System.out.println();
            addAccountClient(db);
            System.out.println();
            retrieveAccountByIBAN(db);
            System.out.println();
            retrieveAccountByBalance(db);
            System.out.println();
            deleteFirstClientByName(db);
            System.out.println();
            deleteSecondClientByName(db);
            System.out.println();
            deleteFirstAccountByIBAN(db);
            System.out.println();
            deleteSecondAccountByIBAN(db);
        } finally {
            db.close();
        }
    }
    
    public static void accessDb4o() {
        ObjectContainer db = Db4oEmbedded.openFile(Db4oEmbedded
                .newConfiguration(), DB4OFILENAME);
        try {
            // do something with db4o
        } finally {
            db.close();
        }
    }
    
    public static void storeFirstClient(ObjectContainer db) {
        Cliente cliente1 = new Cliente("Juan", "Garcia", "12345678A", "666777888", "juangarcia@gmail.com", 25);
        db.store(cliente1);
        System.out.println("Stored " + cliente1);
    }
    
    public static void storeSecondClient(ObjectContainer db) {
        Cliente cliente2 = new Cliente("Maria", "Lopez", "87654321B", "666777999", "marialopez@gmail.com", 30);
        db.store(cliente2);
        System.out.println("Stored " + cliente2);
    }

    public static void storeFirstCuenta(ObjectContainer db) {
        Cuenta cuenta1 = new CuentaAhorro("ES34123445678984232237485482401234", 0.00, "27/03/2014", 3.00);
        db.store(cuenta1);
        System.out.println("Stored " + cuenta1);
    }
    
    public static void storeSecondCuenta(ObjectContainer db) {
        Cuenta cuenta2 = new CuentaCorriente("ES34123445678984232237485482401235", 0.00, "27/10/2014", 1234);
        db.store(cuenta2);
        System.out.println("Stored " + cuenta2);
    }
    
    public static void retrieveAllClientQBE(ObjectContainer db) {
        Cliente proto = new Cliente(null, null, null, null, null, null);
        ObjectSet result = db.queryByExample(proto);
        System.out.println("All clientes:");
        listResult(result);
    }
    
    public static void retrieveAllClients(ObjectContainer db) {
        ObjectSet result = db.queryByExample(Cliente.class);
        System.out.println("All clientes:");
        listResult(result);
    }

    public static void retrieveAllAccounts(ObjectContainer db) {
        ObjectSet result = db.queryByExample(Cuenta.class);
        System.out.println("All cuentas:");
        listResult(result);
    }
    
    public static void retrieveClientByName(ObjectContainer db) {
        Cliente proto = new Cliente("Juan", "Garcia", null, null, null, null);
        ObjectSet result = db.queryByExample(proto);
        System.out.println("Consulta de clientes con nombre Juan Garcia:");
        listResult(result);
    }
    
    public static void retrieveClientByExactAge(ObjectContainer db) {
        Cliente proto = new Cliente(null, null, null, null, null, 30);
        ObjectSet result = db.queryByExample(proto);
        System.out.println("Consulta de clientes con 30 años:");
        listResult(result);
    }

    public static void retrieveClientByAge(ObjectContainer db) {
        Query query = db.query();
        query.constrain(Cliente.class);
        query.descend("edad").constrain(29).greater().and(
                query.descend("edad").constrain(40).smaller());
        ObjectSet result = query.execute();
        System.out.println("Consulta de clientes con edades entre 30 y 40 años:");
        listResult(result);
    }

    public static void retrieveAccountByIBAN(ObjectContainer db) {
        Query query = db.query();
        query.constrain(Cuenta.class);
        query.descend("IBAN").constrain("ES34123445678984232237485482401234");
        ObjectSet result = query.execute();
        System.out.println("Consulta de cuenta con iban seleccionado");
        listResult(result);
    }

    public static void retrieveAccountByBalance(ObjectContainer db) {
        Query query = db.query();
        query.constrain(Cuenta.class);
        query.descend("saldo").constrain(0.00).equal();
        ObjectSet result = query.execute();
        System.out.println("Consulta de cuentas con saldo a 0:");
        listResult(result);
    }
    
    public static void addAccountClient(ObjectContainer db) {
        ObjectSet result = db
                .queryByExample(new Cliente("Juan", "Garcia",null, null, null, null));
        Cliente found = (Cliente) result.next();
        result = db
                .queryByExample(new Cuenta("ES34123445678984232237485482401234", 0.00, null));
        Cuenta found2 = (Cuenta) result.next();

        result = db
                .queryByExample(new Cuenta("ES34123445678984232237485482401235", 0.00, null));
        Cuenta found3 = (Cuenta) result.next();
        found.addCuenta(found2);
        found.addCuenta(found3);
        found2.addCliente(found);
        found3.addCliente(found);
        db.store(found);
        System.out.println("Added count for " + found.getNombre() + " with " + found2);
        retrieveAllClients(db);
    }
    
    public static void deleteFirstClientByName(ObjectContainer db) {
        ObjectSet result = db
                .queryByExample(new Cliente("Juan", "Garcia", null, null, null, null));
        Cliente found = (Cliente) result.next();
        db.delete(found);
        System.out.println("Deleted " + found);
        retrieveAllClients(db);
    }

    public static void deleteSecondClientByName(ObjectContainer db) {
        ObjectSet result = db
        .queryByExample(new Cliente("Maria", "Lopez", null, null, null, null));
        Cliente found = (Cliente) result.next();
        db.delete(found);
        System.out.println("Deleted " + found);
        retrieveAllClients(db);
    }

    public static void deleteFirstAccountByIBAN(ObjectContainer db) {
        ObjectSet result = db
        .queryByExample(new Cuenta("ES34123445678984232237485482401234", 0.00, null));
        Cuenta found = (Cuenta) result.next();
        db.delete(found);
        System.out.println("Deleted " + found);
        retrieveAllAccounts(db);
    }

    public static void deleteSecondAccountByIBAN(ObjectContainer db) {
        ObjectSet result = db
        .queryByExample(new Cuenta("ES34123445678984232237485482401235", 0.00, null));
        Cuenta found = (Cuenta) result.next();
        db.delete(found);
        System.out.println("Deleted " + found);
        retrieveAllAccounts(db);
    }
}
