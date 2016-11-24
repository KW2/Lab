package lab.pauseroom.service;


import java.sql.Date;
import java.util.List;
import java.sql.Connection;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import CheckRoom.Dao.*;
public class MeltService {
	
	private static MeltService instance = new MeltService();
	
	public static MeltService getInstance(){
		return instance;
	}
	
	private MeltService(){
		
	}
	
	
	public void DeleteMeltRoom(int cno){
		Connection conn = null;
		
		
		try{
			conn = ConnectionProvider.getConnection();
			CheckRoomDao messageDao = CheckRoomDao.getInstance();
			messageDao.deleteMelt(conn, cno);
		}catch(Exception e){
			
		}finally{
			JdbcUtil.close(conn);
		}
	}

}
