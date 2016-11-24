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

public class DeleteUserService {

	private static DeleteUserService instance = new DeleteUserService();

	public static DeleteUserService getInstance() {
		return instance;
	}

	private DeleteUserService() {
	}

	public void deleteStudent(String sid, String userid) {
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			conn.setAutoCommit(false);

			UserDao userDao = UserDao.getInstance();
			User user = userDao.select(conn, sid);
			if (user == null) {
				throw new UserNotFoundException("해당 id가 없습니다.");
			}

			if (!userid.equals("admin")) {
				throw new InvalidAdminException("not admin");
			}

			userDao.delete(conn, sid);

			conn.commit();
		} catch (SQLException ex) {
			JdbcUtil.rollback(conn);
			throw new ServiceException("삭제 실패:" + ex.getMessage(), ex);
		} catch (InvalidPassowrdException | UserNotFoundException ex) {
			JdbcUtil.rollback(conn);
			throw ex;
		} finally {
			JdbcUtil.close(conn);
		}
	}
}