package lab.user.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import lab.user.model.User;
import jdbc.JdbcUtil;

public class UserDao {
	private static UserDao studentDao = new UserDao();

	public static UserDao getInstance() {
		return studentDao;
	}

	private UserDao() {
	}

	public int insert(Connection conn, User student) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement("insert into user "
					+ "(sid, name, password, phone, major, cname, status) values (?, ?, ?, ?, ?, ?, ?)");
			pstmt.setString(1, student.getSid());
			pstmt.setString(2, student.getName());
			pstmt.setString(3, student.getPassword());
			pstmt.setString(4, student.getPhone());
			pstmt.setString(5, student.getMajor());
			pstmt.setString(6, student.getCname());
			pstmt.setString(7, student.getStatus());
			return pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	public User select(Connection conn, String sid) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement("select * from user where sid = ?");
			pstmt.setString(1, sid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return makeUserFromResultSet(rs);
			} else {
				return null;
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}

	private User makeUserFromResultSet(ResultSet rs) throws SQLException {
		User student = new User();
		student.setSid(rs.getString("sid"));
		student.setName(rs.getString("name"));
		student.setPassword(rs.getString("password"));
		student.setPhone(rs.getString("phone"));
		student.setMajor(rs.getString("major"));
		student.setCname(rs.getString("cname"));
		student.setStatus(rs.getString("status"));
		return student;
	}

	public int selectCount(Connection conn) throws SQLException {
		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery("select count(*) from user");
			rs.next();
			return rs.getInt(1);
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(stmt);
		}
	}

	public int delete(Connection conn, String sid) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement("delete from user where sid = ?");
			pstmt.setString(1, sid);
			return pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	public int modify(Connection conn, User student, String sid) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(
					"update user set sid=?, name=?, password=?, phone=?, major=?, cname=?, status=?, where sid=?");
			pstmt.setString(1, student.getSid());
			pstmt.setString(2, student.getName());
			pstmt.setString(3, student.getPassword());
			pstmt.setString(4, student.getPhone());
			pstmt.setString(5, student.getMajor());
			pstmt.setString(6, student.getCname());
			pstmt.setString(7, student.getStatus());
			return pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}
	
	public String selectPhone(Connection conn, String sid) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			System.out.println("1");
			pstmt = conn.prepareStatement(
					"select phone from user where id = ?");
			System.out.println("2");
			pstmt.setString(1, sid);
			System.out.println("3");
			rs = pstmt.executeQuery();
			System.out.println("4");
			if (rs.next()) {
				System.out.println("5");
				return rs.getString("phone");
			} else {
				return null;
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}	//매개값으로 들어온 학번에 대응하는 전화번호 값 리턴 (변)

}
