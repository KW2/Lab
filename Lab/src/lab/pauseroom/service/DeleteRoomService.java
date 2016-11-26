package lab.pauseroom.service;

import java.sql.Connection;
import java.sql.Date;
import java.util.List;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.pauseroom.dao.PauseRoomDao;
import lab.pauseroom.model.PauseRoom;

public class DeleteRoomService {
	private static DeleteRoomService instance = new DeleteRoomService();
	
	public static DeleteRoomService getInstance() {
		return instance;
	}

	private DeleteRoomService() {
	}
	
	public void deleteRoom(int pid){
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			PauseRoomDao messageDao = PauseRoomDao.getInstance();
			messageDao.delete(conn, pid);
		
		} catch(Exception e){ 

		} finally{
			JdbcUtil.close(conn);
		}
				
	}
	
	
}
