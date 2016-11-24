package lab.reservation.service;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.error.ServiceException;
import lab.reservation.dao.ReservationDao;

public class ReservationCountService {
	 private static ReservationCountService instance = new ReservationCountService();
     
     public static ReservationCountService getInstance(){
   	  return instance;
     }
	
	private ReservationCountService(){}

	public LabReservationCount getRsCount(Date startDate){
		Connection conn = null;
		ReservationDao reservationDao = ReservationDao.getInstance();
		
		String labroom;
		List<Integer> lab_list = new ArrayList<Integer>();
		lab_list.add(0, 0);
		
		try {
			conn = ConnectionProvider.getConnection();
			
			for(int i = 1; i < 6; i++){
				labroom = "실습" + i + "실";
				lab_list.add(i, reservationDao.selectCount(conn, startDate, labroom));
			}
			
			return new LabReservationCount(lab_list.get(1), lab_list.get(2), lab_list.get(3), lab_list.get(4), lab_list.get(5));
		} catch (SQLException e) {
			throw new ServiceException("계산 에러: " + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}
	
	}
}