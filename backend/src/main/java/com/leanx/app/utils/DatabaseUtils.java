package main.java.com.leanx.app.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
// import io.github.cdimascio.dotenv.Dotenv; use when db data sensitive

public class DatabaseUtils {
    // private static final Dotenv dotenv = Dotenv.configure().directory("/Users/janisgruettmueller/web-app-root/config/").filename("database.env").load();
    // private static final String JDBC_URL = "jdbc:mysql://" + dotenv.get("DB_HOST") + ":" + dotenv.get("DB_PORT") + "/" + dotenv.get("DB_NAME");
    // private static final String USER = dotenv.get("DB_USER");
    // private static final String PASSWORD = dotenv.get("DB_PASSWORD");

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    // Method to connect to database
    public static Connection getConnection(String DB_NAME) throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC Driver not found!", e);    
        }
        return DriverManager.getConnection(JDBC_URL + DB_NAME, DB_USER, DB_PASSWORD);
    }
}
