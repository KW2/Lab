package lab.pauseroom.service;




import java.sql.Connection;
import java.sql.Date;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.error.DuplicateException;
import lab.pauseroom.dao.PauseRoomDao;


public class ColdService {
	
	private static ColdService instance = new ColdService();
	
	public static ColdService getInstance(){
		return instance;
	}
	
	private ColdService(){
		
	}
	
	public void InsertColdRoom(String LabRoom, Date StartDate,Date EndDate, String reason){
		Connection conn = null;
		
		
		try{
			conn=ConnectionProvider.getConnection();
			PauseRoomDao messageDao = PauseRoomDao.getInstance();
			if((messageDao.selectLabroom(conn, LabRoom, StartDate, EndDate) == null) && 
					(messageDao.selectDuplicate(conn, LabRoom, StartDate, EndDate).isEmpty())){
				messageDao.insertCold(conn,LabRoom,StartDate,EndDate, reason);
			} else {
				throw new DuplicateException("얼린 날짜 중복");
			}
		
		}catch(Exception e){
			throw new DuplicateException("얼린 날짜 중복");
		}finally{
			JdbcUtil.close(conn);
		
		}
	}

}

