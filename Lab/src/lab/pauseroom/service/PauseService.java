package lab.pauseroom.service;

import java.sql.Connection;
import java.sql.Date;
import java.util.Calendar;
import java.util.List;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.error.DuplicateException;
import lab.pauseroom.dao.PauseRoomDao;
import lab.reservation.dao.ReservationDao;
import lab.reservation.model.Reservation;


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
			PauseRoomDao messageDao = PauseRoomDao.getInstance();
			ReservationDao reservationDao = ReservationDao.getInstance();
			Calendar startCalendar = Calendar.getInstance();
			Calendar endCalendar = Calendar.getInstance();
			List<Reservation> resList = null; 
			
			startCalendar.setTime(StartDate);
			endCalendar.setTime(EndDate);
			
			conn=ConnectionProvider.getConnection();
			conn.setAutoCommit(false);
			for(String lab : LabRoom){
				messageDao.insertCold(conn, lab, StartDate, EndDate, reason);
			}

			do{
				String start = String.valueOf(startCalendar.get(Calendar.YEAR)) + "-" 
						+ String.valueOf(startCalendar.get(Calendar.MONTH) + 1) + "-" + String.valueOf(startCalendar.get(Calendar.DATE)); 
				resList = reservationDao.select(conn, Date.valueOf(start), LabRoom[0]);
				if(resList != null){
					for(Reservation res : resList){
						reservationDao.updatepermisson(conn, res.getRid(), res.getLabroom(), false);
					}
				}
				
				startCalendar.set(Calendar.DATE, startCalendar.get(Calendar.DATE) + 1);
			}while(startCalendar.before(endCalendar) || startCalendar.equals(endCalendar));
			
			conn.commit();
		}catch(Exception e){
			JdbcUtil.rollback(conn);
			throw new DuplicateException("얼린 날짜 중복");
		}finally{
			JdbcUtil.close(conn);
		
		}
	}

}

