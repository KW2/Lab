package lab.pauseroom.service;


import java.sql.Connection;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.pauseroom.dao.PauseRoomDao;

public class ResumeService {
	
	private static ResumeService instance = new ResumeService();
	
	public static ResumeService getInstance(){
		return instance;
	}
	
	private ResumeService(){
		
	}
	
	
	public void DeleteMeltRoom(int cno){
		Connection conn = null;
		try{
			conn = ConnectionProvider.getConnection();
			PauseRoomDao messageDao = PauseRoomDao.getInstance();
			messageDao.deleteMelt(conn, cno);
		}catch(Exception e){
			
		}finally{
			JdbcUtil.close(conn);
		}
	}
	//학번을 이용한 데이터 삭제
}
