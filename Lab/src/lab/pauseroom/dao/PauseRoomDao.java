package lab.pauseroom.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import jdbc.JdbcUtil;
import lab.pauseroom.model.PauseRoom;

public class PauseRoomDao {
	private static PauseRoomDao pauseDao = new PauseRoomDao();
	public static PauseRoomDao getInstance() {
		return pauseDao;
	}
	
	private PauseRoomDao() {}


	private PauseRoom makeRoomMessageFromResultSet(ResultSet rs) throws SQLException {
		PauseRoom pauseroom = new PauseRoom();
		pauseroom.setPid(rs.getInt("pid"));
		pauseroom.setLabroom(rs.getString("labroom"));
		pauseroom.setPausestart(rs.getDate("pausestart"));
		pauseroom.setPauseend(rs.getDate("pauseend"));
		pauseroom.setReason(rs.getString("reason"));
	
		return pauseroom;
	}


	
	public List<PauseRoom> checkList(Connection conn, Date StartDate, Date EndDate) 
			throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if(EndDate == null){
				pstmt = conn.prepareStatement("select * from pauseroom where pausestart <= ? and  pauseend >= ? ");
				pstmt.setDate(1, StartDate);			
				pstmt.setDate(2, StartDate);
			} else{
				pstmt = conn.prepareStatement("select * from pauseroom where pausestart <= ? and pauseend >= ?");
		
				pstmt.setDate(1, EndDate);				
				pstmt.setDate(2, StartDate);
			}
			
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				List<PauseRoom> pauseList = new ArrayList<PauseRoom>();
				do {
					pauseList.add(makeRoomMessageFromResultSet(rs));	
				} while (rs.next());
				return pauseList;
				
			} else {
				return null;
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	public PauseRoom selectLabroom(Connection conn, String Labroom, Date StartDate, Date EndDate) 
			throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement("select * from pauseroom where labroom = ? and pausestart = ? and pauseend = ? ");
			pstmt.setString(1, Labroom);
			pstmt.setDate(2, StartDate);		
			pstmt.setDate(3, EndDate);
		
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				/*List<CheckRoom> checkList = new ArrayList<CheckRoom>();
				do {
					checkList.add(makeRoomMessageFromResultSet(rs));	
				} while (rs.next());
				return checkList;*/
				return makeRoomMessageFromResultSet(rs);
				
			} else {
				return null;
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	public int insertCold(Connection conn, String LabRoom, Date StartDate, Date EndDate, String reason) throws SQLException {
	PreparedStatement pstmt = null;
	try {
		pstmt = conn.prepareStatement(
				"insert into pauseroom " + 
				"(labroom, pausestart, pauseend, reason) values (?, ?, ?, ?)");

		pstmt.setString(1, LabRoom);
		pstmt.setDate(2, StartDate);
		pstmt.setDate(3, EndDate);
		pstmt.setString(4, reason);
		return pstmt.executeUpdate();
		
	} finally {
		JdbcUtil.close(pstmt);
	}
}
	

	public int deleteMelt(Connection conn, int pid) throws SQLException {
	PreparedStatement pstmt = null;
	try {
		pstmt = conn.prepareStatement(
				"delete from pauseroom where pid = ?");
		pstmt.setInt(1, pid);
		
		return pstmt.executeUpdate();
	} finally {
		JdbcUtil.close(pstmt);
		}
	}
	
	public int selectCount(Connection conn, Date StartDate, Date EndDate) throws SQLException {
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.prepareStatement("select count(*) from pauseroom where pausestart <= ? and pauseend >= ?");
			stmt.setDate(1, EndDate);				
			stmt.setDate(2, StartDate);
			rs = stmt.executeQuery();
			rs.next();
			
			return rs.getInt(1);
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(stmt);
		}
	}

	public List<PauseRoom> selectDataList(Connection conn, int firstRow, int endRow, Date StartDate, Date EndDate) 
			throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement(
					"select * from pauseroom where pausestart <= ? and pauseend >= ? order by labroom,pausestart,pauseend limit ?, ?");
			pstmt.setDate(1, EndDate);				
			pstmt.setDate(2, StartDate);
			pstmt.setInt(3, firstRow - 1);
			pstmt.setInt(4, endRow - firstRow);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				List<PauseRoom> messageList = new ArrayList<PauseRoom>();
				do {
					messageList.add(makeRoomMessageFromResultSet(rs));
				} while (rs.next());
				return messageList;
			} else {
				return Collections.emptyList();
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	public List<PauseRoom> selectDuplicate(Connection conn, String LabRoom, Date StartDate, Date EndDate) 
			throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement(
					"select * from pauseroom where (pausestart between ? and ? or pauseend between ? and ? or (pausestart < ? and pauseend > ?)) and labroom = ?");
			pstmt.setDate(1, StartDate);				
			pstmt.setDate(2, EndDate);
			pstmt.setDate(3, StartDate);				
			pstmt.setDate(4, EndDate);
			pstmt.setDate(5, StartDate);				
			pstmt.setDate(6, EndDate);
			pstmt.setString(7, LabRoom);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				List<PauseRoom> messageList = new ArrayList<PauseRoom>();
				do {
					messageList.add(makeRoomMessageFromResultSet(rs));
				} while (rs.next());
				return messageList;
			} else {
				return Collections.emptyList();
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
}