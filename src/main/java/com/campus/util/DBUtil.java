package com.campus.util;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;


public class DBUtil {

    private static final String PROPERTIES_FILE = "db.properties";

    private static String url;
    private static String username;
    private static String password;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        loadProperties();
    }

    private static void loadProperties() {
        Properties properties = new Properties();

        try (InputStream inputStream = DBUtil.class
                .getClassLoader()
                .getResourceAsStream(PROPERTIES_FILE)) {

            if (inputStream == null) {
                throw new RuntimeException("db.properties 파일을 찾을 수 없습니다.");
            }

            properties.load(inputStream);

            url = properties.getProperty("db.url");
            username = properties.getProperty("db.username");
            password = properties.getProperty("db.password");

            if (url == null || username == null || password == null) {
                throw new RuntimeException("DB 설정값이 올바르지 않습니다.");
            }

        } catch (IOException e) {
            throw new RuntimeException("DB 설정 파일을 읽는 중 오류가 발생했습니다.", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }
}
