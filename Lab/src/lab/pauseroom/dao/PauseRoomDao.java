package lab.pauseroom.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import jdbc.JdbcUtil;
import lab.pauseroom.model.PauseRoom;

public class PauseRoomDao {
	private static PauseRoomDao messageDao = new PauseRoomDao();
	public static PauseRoomDao getInstance() {
		return messageDao;
	}
	
	private PauseRoomDao() {}


	private PauseRoom makeRoomMessageFromResultSet(ResultSet rs) throws SQLException {
		PauseRoom checkroom = new PauseRoom();
		checkroom.setPid(rs.getInt("pid"));
		checkroom.setLabroom(rs.getString("labroom"));
		checkroom.setPausestart(rs.getDate("pausestart"));
		checkroom.setPauseend(rs.getDate("pauseend"));
		checkroom.setReason(rs.getString("reason"));
	
		return checkroom;
	}
	//ResultSet 객체를 CheckRoom 객체로 변환 후 리턴

	
	public List<PauseRoom> checkList(Connection conn, Date StartDate, Date EndDate) 
			throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if(EndDate == null){	//실습실 사용일이 다음 날을 넘어가지 않을 때
				pstmt = conn.prepareStatement("select * from pauseroom where pausestart <= ? and  pauseend >= ? ");
				pstmt.setDate(1, StartDate);			
				pstmt.setDate(2, StartDate);
			} else{		//실습실 사용일이 다음날을 넘어 갈때 
				pstmt = conn.prepareStatement("select * from pauseroom where pausestart <= ? and pauseend >= ?");
		
				pstmt.setDate(1, EndDate);				
				pstmt.setDate(2, StartDate);
			}
			
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				List<PauseRoom> checkList = new ArrayList<PauseRoom>();
				do {
					checkList.add(makeRoomMessageFromResultSet(rs));	
				} while (rs.next());
				//리스트 객체에 CheckRoom객체를 추가
				
				return checkList;
				
			} else {
				return null;
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	public List<PauseRoom> checkList(Connection conn, String labRoom, Date StartDate, Date EndDate) 
			throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if(EndDate == null){	//실습실 사용일이 다음 날을 넘어가지 않을 때
				pstmt = conn.prepareStatement("select * from pauseroom where labroom = ? and pausestart <= ? and  pauseend >= ? ");
				pstmt.setString(1, labRoom);
				pstmt.setDate(2, StartDate);			
				pstmt.setDate(3, StartDate);
				
			} else{		//실습실 사용일이 다음날을 넘어 갈때 
				pstmt = conn.prepareStatement("select * from pauseroom where labroom = ? and pausestart <= ? and pauseend >= ?");
				pstmt.setString(1, labRoom);
				pstmt.setDate(2, StartDate);			
				pstmt.setDate(3, StartDate);
			}
			
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				List<PauseRoom> checkList = new ArrayList<PauseRoom>();
				do {
					checkList.add(makeRoomMessageFromResultSet(rs));	
				} while (rs.next());
				//리스트 객체에 CheckRoom객체를 추가
				
				return checkList;
				
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
			pstmt = conn.prepareStatement(
					"select * from pauseroom where labroom = ? and pausestart = ? and pauseend = ? " 
					);
			//파라미터로 넘어온 실습실 값, 시작 날짜, 끝 날짜를 이용하여 쿼리 수행
			pstmt.setString(1, Labroom);
			pstmt.setDate(2, StartDate);		
			pstmt.setDate(3, EndDate);
		
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				return makeRoomMessageFromResultSet(rs);
				
			} else {
				return null;
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
	}
	
	//실습실과 시작날짜 끝날짜를 이용해 쿼리를 수행한 후 조건에 맞는 CheckRoom 객체 리턴
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
	//매개변수로 넘어온 데이터를 DB에 저장
	

	public int deleteMelt(Connection conn, int cno) throws SQLException {
	PreparedStatement pstmt = null;
	try {
		pstmt = conn.prepareStatement(
				"delete from pauseroom where pid=?");
		pstmt.setInt(1, cno);
		
		return pstmt.executeUpdate();
	} finally {
		JdbcUtil.close(pstmt);
		}
	}
	//매개변수로 넘어온 id값을 이용하여 데이터 삭제
	
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
	//입력 날짜에 해당하는 데이터의 수를 리턴

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
	//입력 날짜에 해당하는 데이터 리스트 중 에서 현재 페이지에 대응하는 리스트 리턴
	
	public List<PauseRoom> selectDuplicate(Connection conn, String LabRoom, Date StartDate, Date EndDate) 
			throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = conn.prepareStatement(
					"select * from pauseroom where (pausestart between ? and ? or pauseend between ? and ? or (pausestart < ? and pauseend > ?)) and labroom = ?");
													//pausestart가 시작날짜와 끝날짜 사이에 있는지
																				//pauseend가 시작날짜와 끝날짜 사이에 있는지
													//두개의 쿼리 이용	dao 메소드 추가생성
							
																											//pauseStart가 시작날짜보다 작고 pauseend가  끝날짜보다 큰지
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
	//매개값으로 전달되는 날짜 데이터가 매개값으로 전달되는 실습실이 얼려진 날짜들 중에서 날짜가 중복되면 해당 투플들의 리스트 리턴
	
	public void delete(Connection conn, int pid) throws SQLException{
		PreparedStatement stmt = null;

		try {
			stmt = conn.prepareStatement("delete from pauseroom where pid = ?");
			stmt.setInt(1, pid);				
			stmt.executeUpdate();
			
		} finally {
			JdbcUtil.close(stmt);
		}
	}
	
}