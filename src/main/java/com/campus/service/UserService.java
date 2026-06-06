package com.campus.service;

import com.campus.dao.UserDAO;
import com.campus.dto.UserDTO;
import org.mindrot.jbcrypt.BCrypt;

public class UserService {
    public static final int REGISTER_SUCCESS = 1;
    public static final int REGISTER_DUPLICATE = 2;
    public static final int REGISTER_INVALID_EMAIL = 3;
    public static final int REGISTER_INVALID_PASSWORD = 4;
    public static final int REGISTER_FAIL = 0;

    private final UserDAO userDAO = new UserDAO();

    public UserDTO login(String loginId, String password) {
        if (loginId == null || loginId.isBlank() || password == null || password.isBlank()) {
            return null;
        }

        UserDTO user = userDAO.findByLoginId(loginId.trim());
        if (user == null) {
            return null;
        }

        if (!matchesPassword(password, user.getPassword())) {
            return null;
        }

        return user;
    }

    public int registerStudent(String loginId, String password, String name) {
        if (loginId == null || loginId.isBlank()
                || password == null || password.isBlank()
                || name == null || name.isBlank()) {
            return REGISTER_FAIL;
        }

        loginId = loginId.trim();
        name = name.trim();

        if (!isSchoolEmail(loginId)) {
            return REGISTER_INVALID_EMAIL;
        }

        if (!isValidPassword(password)) {
            return REGISTER_INVALID_PASSWORD;
        }

        if (userDAO.existsByLoginId(loginId)) {
            return REGISTER_DUPLICATE;
        }

        UserDTO user = new UserDTO();
        user.setLoginId(loginId);
        user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
        user.setName(name);
        user.setRole("STUDENT");
        user.setDepartmentId(null);

        return userDAO.insertUser(user) > 0 ? REGISTER_SUCCESS : REGISTER_FAIL;
    }

    private boolean matchesPassword(String rawPassword, String savedPassword) {
        if (savedPassword == null || savedPassword.isBlank()) {
            return false;
        }

        if (isBcryptHash(savedPassword)) {
            return BCrypt.checkpw(rawPassword, savedPassword);
        }

        // 발표용 기존 더미 데이터는 평문 1234 형태라서 임시 호환합니다.
        return rawPassword.equals(savedPassword);
    }

    private boolean isBcryptHash(String savedPassword) {
        return savedPassword.startsWith("$2a$")
                || savedPassword.startsWith("$2b$")
                || savedPassword.startsWith("$2y$");
    }

    private boolean isSchoolEmail(String loginId) {
        return loginId != null && loginId.toLowerCase().endsWith("@skuniv.ac.kr");
    }

    private boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }

        boolean hasLetter = password.matches(".*[A-Za-z].*");
        boolean hasDigit = password.matches(".*\\d.*");
        boolean hasSpecial = password.matches(".*[^A-Za-z0-9].*");

        return hasLetter && hasDigit && hasSpecial;
    }
}
