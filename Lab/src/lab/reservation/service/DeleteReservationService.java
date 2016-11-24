package lab.reservation.service;

import java.sql.Connection;
import java.sql.SQLException;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.error.InvalidPassowrdException;
import lab.error.ReservationNotFoundException;
import lab.error.ServiceException;
import lab.reservation.dao.ReservationDao;
import lab.reservation.model.Reservation;

public class DeleteReservationService {

	private static DeleteReservationService instance = new DeleteReservationService();

	public static DeleteReservationService getInstance() {
		return instance;
	}

	private DeleteReservationService() {
	}

	public void deleteReservation(int rid) {
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			conn.setAutoCommit(false);

			ReservationDao reservationDao = ReservationDao.getInstance();
			Reservation reservation = reservationDao.select(conn, rid);

			if (reservation == null) {
				throw new ReservationNotFoundException("예약 정보 없음");
			}

			reservationDao.delete(conn, rid);
			conn.commit();
		} catch (SQLException ex) {
			JdbcUtil.rollback(conn);
			throw new ServiceException("삭제 실패:" + ex.getMessage(), ex);
		} catch (InvalidPassowrdException | ReservationNotFoundException ex) {
			JdbcUtil.rollback(conn);
			throw ex;
		} finally {
			JdbcUtil.close(conn);
		}
	}
}