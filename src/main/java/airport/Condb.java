package airport;

import java.sql.Connection;
import java.sql.DriverManager;

public class Condb {
	public static Connection getConnection() throws Exception {
		Class.forName("oracle.jdbc.OracleDriver");
		String url = "jdbc:oracle:thin:@//localhost:1521/xe";
		String user = "system";
		String password = "1234";
		return DriverManager.getConnection(url, user, password);
	}
}
