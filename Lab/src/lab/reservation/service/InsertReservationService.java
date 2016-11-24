package lab.reservation.service;

import java.sql.Connection;
import java.sql.SQLException;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.error.ServiceException;
import lab.reservation.dao.ReservationDao;
import lab.reservation.model.Reservation;

public class InsertReservationService {
	private static InsertReservationService instance = new InsertReservationService();

	public static InsertReservationService getInstance() {
		return instance;
	}

	private InsertReservationService() {
	}
	
	public void insert(Reservation reservation) {
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();
			reservationDao.insert(conn, reservation);
		} catch (SQLException e) {
			throw new ServiceException(
					"예약 실패: " + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}
	}

}