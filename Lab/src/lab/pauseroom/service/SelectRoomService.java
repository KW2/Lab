package lab.pauseroom.service;

import CheckRoom.Dao.*;
import CheckRoom.Model.*;
import CheckRoom.Service.*;
import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class SelectRoomService {
	private static SelectRoomService instance = new SelectRoomService();
	
	public static SelectRoomService getInstance() {
		return instance;
	}

	private SelectRoomService() {
	}
	
	private static final int MESSAGE_COUNT_PER_PAGE = 10;

	public List<CheckRoom> getList(int pageNumber, Date StartDate, Date EndDate) {
		Connection conn = null;
		List<CheckRoom> dataList = new ArrayList<CheckRoom>();
		try {
			conn = ConnectionProvider.getConnection();
			CheckRoomDao messageDao = CheckRoomDao.getInstance();
			int messageTotalCount = messageDao.selectCount(conn, StartDate, EndDate);
			int firstRow = 0;
			int endRow = 0;
			if (messageTotalCount > 0) {
				firstRow =
						(pageNumber - 1) * MESSAGE_COUNT_PER_PAGE + 1;
				endRow = firstRow + MESSAGE_COUNT_PER_PAGE - 1;
				dataList = messageDao.selectDataList(conn, firstRow, endRow, StartDate, EndDate);
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
			CheckRoomDao messageDao = CheckRoomDao.getInstance();
			dataSize = messageDao.selectCount(conn, StartDate, EndDate);
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
	
	public List<CheckRoom> SelectDate(Date StartDate, Date EndDate){
		Connection conn = null;
		List<CheckRoom> reserRoomList = null;
	
		try {
		
			conn = ConnectionProvider.getConnection();
			CheckRoomDao messageDao = CheckRoomDao.getInstance();
			reserRoomList = messageDao.checkList(conn, StartDate, EndDate);
			
			
			return reserRoomList;
		} catch(Exception e){
			return null;
		} finally{
			JdbcUtil.close(conn);
		}
				
	}
}
