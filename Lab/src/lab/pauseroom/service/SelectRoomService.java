package lab.pauseroom.service;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.pauseroom.dao.PauseRoomDao;
import lab.pauseroom.model.PauseRoom;

public class SelectRoomService {
	private static SelectRoomService instance = new SelectRoomService();
	
	public static SelectRoomService getInstance() {
		return instance;
	}

	private SelectRoomService() {
	}
	
	private static final int MESSAGE_COUNT_PER_PAGE = 10;	//한 페이지당 데이터의 개수

	public List<PauseRoom> getList(int pageNumber, Date StartDate, Date EndDate) {
		Connection conn = null;
		List<PauseRoom> dataList = new ArrayList<PauseRoom>();
		try {
			conn = ConnectionProvider.getConnection();
			PauseRoomDao messageDao = PauseRoomDao.getInstance();
			int messageTotalCount = messageDao.selectCount(conn, StartDate, EndDate);	//입력 날짜에 해당하는 데이터의 수
			int firstRow = 0;
			int endRow = 0;
			if (messageTotalCount > 0) {
				firstRow =
						(pageNumber - 1) * MESSAGE_COUNT_PER_PAGE + 1;
				endRow = firstRow + MESSAGE_COUNT_PER_PAGE - 1;
				dataList = messageDao.selectDataList(conn, firstRow, endRow, StartDate, EndDate);	//현재 페이지의 데이터 리스트 리턴
			} else {
				dataList = Collections.emptyList();
			}
		} catch (SQLException e) {
			
		} finally {
			JdbcUtil.close(conn);
		}
		return dataList;
	}
	
	public int getPageSize(Date StartDate, Date EndDate){
		Connection conn = null;
		int pageSize = 0;
		try {
			int dataSize = 0;
			conn = ConnectionProvider.getConnection();
			PauseRoomDao messageDao = PauseRoomDao.getInstance();
			dataSize = messageDao.selectCount(conn, StartDate, EndDate);	//입력 날짜의 해당되는 데이터의 수 리턴
			if (dataSize == 0) {
				pageSize = 0;
			} else {
				pageSize = dataSize / MESSAGE_COUNT_PER_PAGE;
				if (dataSize % MESSAGE_COUNT_PER_PAGE > 0) {
					pageSize++;
				}
			}
		} catch(Exception e){
		} finally{
			JdbcUtil.close(conn);
		}
		return pageSize;
	}
	
	public List<PauseRoom> SelectDate(Date StartDate, Date EndDate){
		Connection conn = null;
		List<PauseRoom> reserRoomList = null;
	
		try {
		
			conn = ConnectionProvider.getConnection();
			PauseRoomDao messageDao = PauseRoomDao.getInstance();
			reserRoomList = messageDao.checkList(conn, StartDate, EndDate);
			
			
			return reserRoomList;
		} catch(Exception e){
			return null;
		} finally{
			JdbcUtil.close(conn);
		}
				
	}
	//입력 날짜에 포함되어 있는 데이터 리스트를 리턴
}
