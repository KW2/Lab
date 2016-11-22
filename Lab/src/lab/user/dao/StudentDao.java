package lab.user.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import lab.user.model.Student;
import jdbc.JdbcUtil;

public class StudentDao {
	private static StudentDao studentDao = new StudentDao();
	public static StudentDao getInstance() {
		return studentDao;
	}
	
	private StudentDao() {}

	public int insert(Connection conn, Student student) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(
					"insert into student " + 
					"(sid, name, password, phone, cname, status) values (?,?,?,?,?,?)");
			pstmt.setString(1, student.getSid());
			pstmt.setString(2, student.getName());
			pstmt.setString(3, student.getPassword());
			pstmt.setString(4, student.getPhone());
			pstmt.setString(5, student.getCname());
			pstmt.setString(6, student.getStatus());
			return pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	public Student select(Connection conn, String sid) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement(
					"select * from student where sid = ?");
			pstmt.setString(1, sid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return makeMessageFromResultSet(rs);
			} else {
				return null;
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}

	
	private Student makeMessageFromResultSet(ResultSet rs) throws SQLException {
		Student student = new Student();
		student.setSid(rs.getString("sid"));
		student.setName(rs.getString("name"));
		student.setPassword(rs.getString("password"));
		student.setPhone(rs.getString("phone"));
		student.setCname(rs.getString("cname"));
		student.setStatus(rs.getString("status"));
		return student;
	}

	public int selectCount(Connection conn) throws SQLException {
		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery("select count(*) from student");
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
			pstmt = conn.prepareStatement(
					"delete from student where sid = ?");
			pstmt.setString(1, sid);
			return pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}
	
	
	public int modify(Connection conn, Student student, String sid) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(
					"update student set sid=?, name=?, password=?, phone=?, cname=?, status=?, where sid=?");	
			pstmt.setString(1, student.getSid());
			pstmt.setString(2, student.getName());
			pstmt.setString(3, student.getPassword());
			pstmt.setString(4, student.getPhone());
			pstmt.setString(5, student.getCname());
			pstmt.setString(6, student.getStatus());
			return pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	

}
