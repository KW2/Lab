package lab.user.service;

import java.sql.Connection;
import java.sql.SQLException;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.error.InvalidAdminException;
import lab.error.InvalidPassowrdException;
import lab.error.ServiceException;
import lab.error.UserNotFoundException;
import lab.user.dao.UserDao;
import lab.user.model.User;

public class ModifyUserService {

	private static ModifyUserService instance = new ModifyUserService();

	public static ModifyUserService getInstance() {
		return instance;
	}

	private ModifyUserService() {
	}

	public void ModifyStudent(User user, String sid, String userid) {
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			conn.setAutoCommit(false);

			UserDao userDao = UserDao.getInstance();
			user = userDao.select(conn, sid);

			if (user == null) {
				throw new UserNotFoundException("검색 실패");
			}
			if (!userid.equals("admin")) {
				throw new InvalidAdminException("not admin");
			}

			userDao.modify(conn, user, sid);
			conn.commit();
		} catch (SQLException ex) {
			JdbcUtil.rollback(conn);
			throw new ServiceException("수정 실패:" + ex.getMessage(), ex);
		} catch (InvalidPassowrdException | UserNotFoundException ex) {
			JdbcUtil.rollback(conn);
			throw ex;
		} finally {
			JdbcUtil.close(conn);
		}
	}

}