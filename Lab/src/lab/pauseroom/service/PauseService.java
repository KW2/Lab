package lab.pauseroom.service;




import java.sql.Connection;
import java.sql.Date;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.error.DuplicateException;
import lab.pauseroom.dao.PauseRoomDao;


public class PauseService {
	
	private static PauseService instance = new PauseService();
	
	public static PauseService getInstance(){
		return instance;
	}
	
	private PauseService(){
		
	}
	
	public void InsertColdRoom(String[] LabRoom, Date StartDate,Date EndDate, String reason){
		Connection conn = null;
		
		try{
			conn=ConnectionProvider.getConnection();
			PauseRoomDao messageDao = PauseRoomDao.getInstance();
			conn.setAutoCommit(false);
			for(String lab : LabRoom){
				if((messageDao.selectLabroom(conn, lab, StartDate, EndDate) == null) && 
					(messageDao.selectDuplicate(conn, lab, StartDate, EndDate).isEmpty())){
					messageDao.insertCold(conn,lab,StartDate,EndDate, reason);
					//날짜가 중복 되는지 확인 후 중복 되는 날짜가 없으면 데이터 삽입
				} else {
					throw new DuplicateException("얼린 날짜 중복");
				}
			}
			conn.commit();
		}catch(Exception e){
			JdbcUtil.rollback(conn);
			throw new DuplicateException("얼린 날짜 중복");
		}finally{
			JdbcUtil.close(conn);
		
		}
	}

}

