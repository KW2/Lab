package lab.reservation.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.error.EqualStatusException;
import lab.error.ServiceException;
import lab.reservation.dao.ReservationDao;
import lab.reservation.model.Reservation;

public class UpdateReservationService {
	private static UpdateReservationService instance = new UpdateReservationService();

	public static UpdateReservationService getInstance() {
		return instance;
	}

	private UpdateReservationService() {}

	public void updateGroupleader(Reservation reservation, String sid) {       // 단체장 개인 삭제시 groupleader 변경시 사용
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();
			reservationDao.updateGroupleader(conn, reservation, sid);
		} catch (SQLException e) {
			throw new ServiceException("해당 아이디가 존재하지 않습니다:" + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}

	}

	public void update(Reservation reservation){
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();
			reservationDao.update(conn, reservation);
		} catch (SQLException e) {
			throw new ServiceException("해당 아이디가 존재하지 않습니다:" + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}
	}
	
	public int UpdateStatus(List<Integer> status, List<String> labRoom, boolean flag){
		Connection conn = null;
		int i = 0;
		try {
			conn = ConnectionProvider.getConnection();
			conn.setAutoCommit(false);
			ReservationDao messageDao = ReservationDao.getInstance();
			i = messageDao.updatepermisson(conn, status, labRoom, flag);
			conn.commit();
			return i;
		} catch(EqualStatusException e) {
			throw new EqualStatusException("상태 중복 삽입");
			//예약 승인 상태에서 예약승인으로 상태 값을 변경 시키려고 할때 에러를 발생시킴
		} catch(Exception e){
			JdbcUtil.rollback(conn);			
			return 0;
		} finally{
			
			JdbcUtil.close(conn);
		}
	}	//예약 번호를 이용하여 예약내역의 상태 값과 실습실 값을 변경 시켜줌
}
