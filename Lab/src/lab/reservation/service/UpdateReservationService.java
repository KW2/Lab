package lab.reservation.service;

import java.sql.Connection;
import java.sql.SQLException;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
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
}
