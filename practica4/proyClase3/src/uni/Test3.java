package uni;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.PersistenceException;

public class Test3 {
	EntityManagerFactory entityManagerFactory = 
			Persistence.createEntityManagerFactory("UnidadPersistenciaBanquito");
	EntityManager em = entityManagerFactory.createEntityManager();
	
	public void prueba() {

		Cliente cliente1 = new Cliente("12345678A", 30, "Juan", "Perez", "Calle Falsa 123", "600123456", "juan.perez@example.com");
		Cliente cliente2 = new Cliente("23456789B", 40, "Maria", "Gomez", "Avenida Siempre Viva 456", "600234567", "maria.gomez@example.com");
		Cliente cliente3 = new Cliente("34567890C", 50, "Pedro", "Martinez", "Plaza Mayor 789", "600345678", "pedro.martinez@example.com");
		Cliente cliente4 = new Cliente("45678901D", 60, "Ana", "Lopez", "Calle Ancha 012", "600456789", "ana@gmail.com");

		EntityTransaction trans = em.getTransaction();
		trans.begin();
		try {
			em.persist(cliente1);
			em.persist(cliente2);
			em.persist(cliente3);
			em.persist(cliente4);
			trans.commit();
		} catch (PersistenceException e) {
			if (trans.isActive()) {
				trans.rollback();
			}
		}
		
		Oficina oficina1 = new Oficina(1111, "Calle Nueva 123", "600123456");
		Oficina oficina2 = new Oficina(2222, "Avenida Renovada 456", "600234567");
		Oficina oficina3 = new Oficina(3333, "Plaza Principal 789", "600345678");
		Oficina oficina4 = new Oficina(4444, "Calle Ancha 012", "600456789");

		
		trans.begin();
		try {
			em.persist(oficina1);
			em.persist(oficina2);
			em.persist(oficina3);
			em.persist(oficina4);
			trans.commit();
		} catch (PersistenceException e) {
			if (trans.isActive()) {
				trans.rollback();
			}
		}
		Calendar calendar = Calendar.getInstance();
		 Date fecha = calendar.getTime();
		Cuenta_Corriente cc1 = new Cuenta_Corriente("ES1234567890123456789012", oficina1, fecha, "1234567890L", 1000.0);
		Cuenta_Corriente cc2 = new Cuenta_Corriente("ES2345678901234567890123", oficina2, fecha, "2345678901L");
		Cuenta_Corriente cc3 = new Cuenta_Corriente("ES3456789012345678901234", oficina3, fecha, "3456789012L", 2000.0);
		Cuenta_Corriente cc4 = new Cuenta_Corriente("ES4567890123456789012345", oficina4, fecha, "456789");
		
		trans.begin();
		try {
			em.persist(cc1);
			em.persist(cc2);
			em.persist(cc3);
			em.persist(cc4);
			trans.commit();
		} catch (PersistenceException e) {
			if (trans.isActive()) {
				trans.rollback();
			}
		}
		
		Cuenta_Ahorro ca1 = new Cuenta_Ahorro("ES1234567890123416789012", 0.01, fecha, "1234567890A", 1000.0);
		Cuenta_Ahorro ca2 = new Cuenta_Ahorro("ES2345678901234544890123", 0.02, fecha, "2345678901A");
		
		EntityTransaction trans1 = em.getTransaction();
		trans1.begin();
		try{
			em.persist(ca1);
			em.persist(ca2);
			trans1.commit();
		} catch (PersistenceException e) {
			if (trans.isActive()) {
				trans1.rollback();
			}
			System.out.println("ERROR persistiendo estudiantes");
		}
		long time = System.currentTimeMillis();
		 Timestamp timestamp = new Timestamp(time);
		Retirada r1 = new Retirada(100.0, timestamp, cc1, oficina1);
		Ingreso i1 = new Ingreso(50.0, timestamp, cc1, oficina1);
		Retirada r2 = new Retirada(200.0, timestamp, cc2, oficina2);
		Ingreso i2 = new Ingreso(100.0, timestamp, cc2, oficina2);
		Transferencia t1 = new Transferencia(50.0, timestamp, cc1, cc2);
		Transferencia t2 = new Transferencia(100.0, timestamp, cc3, cc4);
		
		trans.begin();
		try{
			em.persist(r1);
			em.persist(i1);
			em.persist(r2);
			em.persist(i2);
			em.persist(t1);
			em.persist(t2);
			trans.commit();
		} catch (PersistenceException e) {
			if (trans.isActive()) {
				trans.rollback();
			}
			System.out.println("ERROR persistiendo profesores");
		}
		//Listas de cuentas de los clientes
		cliente1.getCuentas().add(cc1);
		cliente1.getCuentas().add(ca1);
		cliente2.getCuentas().add(cc2);
		cliente3.getCuentas().add(ca2);
		cliente4.getCuentas().add(cc4);

		//Listas de clientes de las cuentas
		cc1.getClientes().add(cliente1);
		ca1.getClientes().add(cliente1);
		cc2.getClientes().add(cliente2);
		ca2.getClientes().add(cliente3);
		cc4.getClientes().add(cliente4);

		//Listas de operaciones de las cuentas
		cc1.getRetiradas().add(r1);
		cc1.getIngresos().add(i1);
		cc1.getTransferencias().add(t2);
		cc2.getIngresos().add(i2);
		ca1.getTransferencias().add(t1);

		//Listas de cuentas de las oficinas
		oficina1.getCuentasCorrientes().add(cc1);
		oficina2.getCuentasCorrientes().add(cc2);
		oficina3.getCuentasCorrientes().add(cc3);

		//Listas de operaciones de las oficinas
		oficina1.getIngresos().add(i1);
		oficina1.getRetiradas().add(r1);
		oficina2.getIngresos().add(i2);
		oficina2.getRetiradas().add(r2);

		trans.begin();
		try{
			em.merge(cliente1);
			em.merge(cliente2);
			em.merge(cliente3);
			em.merge(cliente4);
			em.merge(cc1);
			em.merge(cc2);
			em.merge(cc3);
			em.merge(cc4);
			em.merge(ca1);
			em.merge(ca2);
			em.merge(r1);
			em.merge(i1);
			em.merge(r2);
			em.merge(i2);
			em.merge(t1);
			em.merge(t2);
			em.merge(oficina1);
			em.merge(oficina2);
			em.merge(oficina3);
			trans.commit();
		}catch (PersistenceException e) {
			if (trans.isActive()){
				trans.rollback();
			}
			System.out.println("ERROR actualizando relaciones");
		}



//		trans.begin();
//		try{
//			em.remove(e1);
//			trans.commit();
//		} catch (PersistenceException e) {
//			if (trans.isActive()) {
//				trans.rollback();
//			}
//			System.out.println("Excepcion borrado");
//		}

	}
	
	public static void main(String[] args) {
		Test3 t = new Test3();
		t.prueba();
	}
	

}
