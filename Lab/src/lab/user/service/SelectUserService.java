package lab.user.service;

import java.sql.Connection;
import java.sql.SQLException;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.error.ServiceException;
import lab.user.dao.UserDao;
import lab.user.model.User;

public class SelectUserService {
	private static SelectUserService instance = new SelectUserService();

	public static SelectUserService getInstance() {
		return instance;
	}

	private SelectUserService() {

	}

	public User getUserInfo(String sid) {
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			UserDao userDao = UserDao.getInstance();
			return userDao.select(conn, sid);
		} catch (SQLException e) {
			throw new ServiceException("해당 아이디가 존재하지 않습니다:" + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}

	}

}
