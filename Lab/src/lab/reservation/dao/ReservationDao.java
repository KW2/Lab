package lab.reservation.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import jdbc.JdbcUtil;
import lab.reservation.model.Reservation;

public class ReservationDao {
	private static ReservationDao messageDao = new ReservationDao();

	public static ReservationDao getInstance() {
		return messageDao;
	}

	private ReservationDao() {
	}

	public int insert(Connection conn, Reservation message) throws SQLException {
		PreparedStatement pstmt = null;
	
		try {
			pstmt = conn.prepareStatement(
					"insert into reservation " + 
					"(Labroom, sid, startdate, starttime, usingtime, team, purpose, approval, groupleader) values (?, ?, ?, ?, ?, ?, ?, ?, ?)");
			pstmt.setString(1, message.getLabroom());
			pstmt.setString(2, message.getSid());
			pstmt.setDate(3, message.getStartdate());
			pstmt.setTime(4, message.getStarttime());
			pstmt.setInt(5, message.getUsingtime());
			pstmt.setBoolean(6, message.isTeam());
			pstmt.setString(7, message.getPurpose());
			pstmt.setString(8, message.getApproval());
			pstmt.setString(9, message.getGroupleader());
			return pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}
	
	public int update(Connection conn, Reservation reservation) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement("update reservation " + "set labroom = ?, startdate = ?, starttime = ?"
					+ ", usingtime = ?, purpose = ?, team = ?, groupleader = ? where rid = ?");
			pstmt.setString(1, reservation.getLabroom());
			pstmt.setDate(2, reservation.getStartdate());
			pstmt.setTime(3, reservation.getStarttime());
			pstmt.setInt(4, reservation.getUsingtime());
			pstmt.setString(5, reservation.getPurpose());
			pstmt.setBoolean(6, reservation.isTeam());
			pstmt.setString(7, reservation.getGroupleader());
			pstmt.setInt(8, reservation.getRid());

			return pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	public void updateGroupleader(Connection conn, Reservation reservation, String sid) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			if (sid.equals(" ")) {
				pstmt = conn.prepareStatement("update reservation " + "set groupleader = ?, team = ? where rid = ?");
				pstmt.setString(1, sid);
				pstmt.setBoolean(2, false);
				pstmt.setInt(3, reservation.getRid());
				pstmt.executeUpdate();
			} else {
				pstmt = conn.prepareStatement("update reservation " + "set groupleader = ? where rid = ?");
				pstmt.setString(1, sid);
				pstmt.setInt(2, reservation.getRid());
				pstmt.executeUpdate();
			}
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	public Reservation select(Connection conn, int rId) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement("select * from reservation where rid = ?");
			pstmt.setInt(1, rId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return makeReservationFromResultSet(rs);
			} else {
				return null;
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}

	public List<Reservation> select(Connection conn, String sid, Date startdate) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement("select * from reservation where sid = ? and startdate = ?");
			pstmt.setString(1, sid);
			pstmt.setDate(2, startdate);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				List<Reservation> dayResevationInfo = new ArrayList<Reservation>();
				do {
					dayResevationInfo.add(makeReservationFromResultSet(rs));
				} while (rs.next());
				return dayResevationInfo;
			} else {
				return null;
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	public List<String> selectGroupSid(Connection conn, Date startdate, String groupleader, Time starttime) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement("select * from reservation where groupleader = ? and startdate = ? and starttime= ?");
			pstmt.setString(1, groupleader);
			pstmt.setDate(2, startdate);
			pstmt.setTime(3, starttime);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				List<String> groupInfo = new ArrayList<String>();
				do {
					groupInfo.add(makeReservationFromResultSet(rs).getSid());
				} while (rs.next());
				return groupInfo;
			} else {
				return null;
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}

	public List<String> selectGroupRid(Connection conn, Date startdate, String groupleader, Time starttime) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement("select * from reservation where groupleader = ? and startdate = ? and starttime=?");
			pstmt.setString(1, groupleader);
			pstmt.setDate(2, startdate);
			pstmt.setTime(3, starttime);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				List<String> groupInfo = new ArrayList<String>();
				do {
					groupInfo.add(String.valueOf(makeReservationFromResultSet(rs).getRid()));
				} while (rs.next());
				return groupInfo;
			} else {
				return null;  
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}

	private Reservation makeReservationFromResultSet(ResultSet rs) throws SQLException {
		Reservation reservation = new Reservation();
		reservation.setRid(rs.getInt("rid"));
		reservation.setLabroom(rs.getString("Labroom"));
		reservation.setSid(rs.getString("sid"));
		reservation.setStartdate(rs.getDate("startdate"));
		reservation.setStarttime(rs.getTime("starttime"));
		reservation.setUsingtime(rs.getInt("usingtime"));
		reservation.setPurpose(rs.getString("purpose"));
		reservation.setTeam(rs.getBoolean("team"));
		reservation.setGroupleader(rs.getString("groupleader"));
		reservation.setApproval(rs.getString("approval"));

		return reservation;
	}

	public int selectCount(Connection conn, String startDate, String endDate, String id) throws SQLException {
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.prepareStatement(
					"select count(*) from reservation where startdate>=? and startdate <= ? and sid=? ");
			stmt.setString(1, startDate);
			stmt.setString(2, endDate);
			stmt.setString(3, id);
			rs = stmt.executeQuery();
			rs.next();
			return rs.getInt(1);
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(stmt);
		}
	}

	public int selectCount(Connection conn, Date startDate, String labroom) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement(
					"select count(*) from reservation " + 
					"where startDate = ? and labroom = ?"		
					);
			pstmt.setDate(1, startDate);
			pstmt.setString(2, labroom);
			rs = pstmt.executeQuery();
			rs.next();
			return rs.getInt(1);
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	public List<Reservation> selectList(Connection conn, int firstRow, int endRow, String id, String startDate,
			String endDate) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement("select * from reservation "
					+ "where sid = ? and startdate>=? and startdate <= ? order by startdate desc limit ?,?");
			pstmt.setString(1, id);
			pstmt.setString(2, startDate);
			pstmt.setString(3, endDate);
			pstmt.setInt(4, firstRow);
			pstmt.setInt(5, endRow);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				List<Reservation> reservationList = new ArrayList<Reservation>();
				do {
					reservationList.add(makeReservationFromResultSet(rs));
				} while (rs.next());
				return reservationList;
			} else {
				return null;
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}

	public int delete(Connection conn, int rid) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement("delete from reservation where rid = ?");
			pstmt.setInt(1, rid);
			return pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

}
