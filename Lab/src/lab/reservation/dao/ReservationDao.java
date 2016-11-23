package lab.reservation.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jdbc.JdbcUtil;
import lab.reservation.model.Reservation;

public class ReservationDao {
	private static ReservationDao messageDao = new ReservationDao();
	public static ReservationDao getInstance() {
		return messageDao;
	}
	
	private ReservationDao() {}
	
	/*public int insert(Connection conn, Reservation message) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(
					"insert into guestbook_message " + 
					"(guest_name, password, message) values (?, ?, ?)");
			pstmt.setString(1, message.getGuestName());
			pstmt.setString(2, message.getPassword());
			pstmt.setString(3, message.getMessage());
			return pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}*/
	
	public int update(Connection conn, Reservation message) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement(
					"update reservation " + 
					"set Labroom = ? where rid = ?");
			pstmt.setString(1, message.getLabroom());
			pstmt.setInt(2, message.getRid());
			
			return pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}
	
	
	public void updateGroupleader(Connection conn, Reservation reservation , String sid) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			if(sid.equals(" ")){
				pstmt = conn.prepareStatement(
						"update reservation " + 
						"set groupleader = ?, team = ? where rid = ?");
				pstmt.setString(1, sid);
				pstmt.setBoolean(2, false);
				pstmt.setInt(3, reservation.getRid());
				pstmt.executeUpdate();
			}else{
				pstmt = conn.prepareStatement(
						"update reservation " + 
						"set groupleader = ? where rid = ?");
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
			pstmt = conn.prepareStatement(
					"select * from reservation where rid = ?");
			pstmt.setInt(1, rId);
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


	public List<String> selectGroupSid(Connection conn,Date startdate,String groupleader) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement(
					"select * from reservation where groupleader = ? and startdate = ?" );
			pstmt.setString(1, groupleader);
			pstmt.setDate(2, startdate);
			rs = pstmt.executeQuery();
		    if(rs.next()){
		    	List<String> groupInfo = new ArrayList<String>();
		    	do{
				groupInfo.add(makeMessageFromResultSet(rs).getSid());
		     }while (rs.next());
		    	return groupInfo;
		    } else {
				return null;
			} 
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	public List<String> selectGroupRid(Connection conn,Date startdate,String groupleader) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement(
					"select * from reservation where groupleader = ? and startdate = ?" );
			pstmt.setString(1, groupleader);
			pstmt.setDate(2, startdate);
			rs = pstmt.executeQuery();
		    if(rs.next()){
		    	List<String> groupInfo = new ArrayList<String>();
		    	do{
				groupInfo.add(String.valueOf(makeMessageFromResultSet(rs).getRid()));
		     }while (rs.next());
		    	return groupInfo;
		    } else {
				return null;
			} 
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	private Reservation makeMessageFromResultSet(ResultSet rs) throws SQLException {
		Reservation reservation = new Reservation();
		reservation.setRid(rs.getInt("rid"));
		reservation.setLabroom(rs.getString("Labroom"));
		reservation.setSid(rs.getString("sid"));
		reservation.setStartdate(rs.getDate("startdate"));
		reservation.setStarttime(rs.getTime("starttime"));
		reservation.setUsingtime(rs.getInt("usingtime"));
		reservation.setTeam(rs.getBoolean("team"));
		reservation.setStatus(rs.getString("Status"));
		reservation.setPurpose(rs.getString("purpose"));
		reservation.setGroupleader(rs.getString("groupleader"));
		
		return reservation;
	}

	public int selectCount(Connection conn,String startDate, String endDate, String id) throws SQLException {
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.prepareStatement("select count(*) from reservation where startdate>=? and startdate <= ? and sid=? ");
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

	public List<Reservation> selectList(Connection conn, int firstRow, int endRow, String id, String startDate, String endDate) 
			throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement(
					"select * from reservation " + 
					"where sid = ? and startdate>=? and startdate <= ? order by startdate desc limit ?,?");
			pstmt.setString(1, id);
			pstmt.setString(2, startDate);
			pstmt.setString(3, endDate);
			pstmt.setInt(4, firstRow);
			pstmt.setInt(5, endRow);
			
			rs = pstmt.executeQuery();
			if (rs.next()) {
				List<Reservation> reservationList = new ArrayList<Reservation>();
				do {
					reservationList.add(makeMessageFromResultSet(rs));
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
			pstmt = conn.prepareStatement(
					"delete from reservation where rid = ?");
			pstmt.setInt(1, rid);
			return pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}
	
	
}

