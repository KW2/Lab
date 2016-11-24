package lab.user.service;

import java.sql.Connection;
import java.sql.SQLException;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.error.InvalidAdminException;
import lab.error.ServiceException;
import lab.user.dao.UserDao;
import lab.user.model.User;

public class InsertUserService {
	private static InsertUserService instance = new InsertUserService();

	public static InsertUserService getInstance() {
		return instance;
	}

	private InsertUserService() {
	}

	public void insert(User user, String userid) {
		Connection conn = null;
		try {
			if (!userid.equals("admin")) {
				throw new InvalidAdminException("not admin");
			}
			conn = ConnectionProvider.getConnection();
			UserDao userDao = UserDao.getInstance();
			userDao.insert(conn, user);
		} catch (SQLException e) {
			throw new ServiceException("등록 실패: " + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}
	}

}