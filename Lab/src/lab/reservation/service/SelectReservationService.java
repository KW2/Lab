package lab.reservation.service;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.error.ServiceException;
import lab.reservation.dao.ReservationDao;
import lab.reservation.model.Reservation;

public class SelectReservationService {
	private static SelectReservationService instance = new SelectReservationService();

	public static SelectReservationService getInstance() {
		return instance;
	}

	private SelectReservationService() {}

	private static final int COUNT_PER_PAGE = 10;

	public Reservation getReservation(int rid) {						// rid를 통한 특정 예약 정보 리턴
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();
			return reservationDao.select(conn, rid);
		} catch (SQLException e) {
			throw new ServiceException("해당 아이디가 존재하지 않습니다:" + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}

	}

	public List<String> getGroupSid(String groupleader, Date startdate, Time starttime) {			// 단체 삭제 및 단체 수정에 사용
		Connection conn = null;														// groupleader, startdate 로 단체예약에 대한 sid들 리턴
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();
			return reservationDao.selectGroupSid(conn, startdate, groupleader, starttime);
		} catch (SQLException e) {
			throw new ServiceException("해당 아이디가 존재하지 않습니다:" + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}

	}

	public List<String> getGroupRid(String groupleader, Date startdate, Time starttime) {			// 단체 삭제에 사용
		Connection conn = null;														// groupleader, startdate 로 단체예약에 대한 rid들 리턴
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();
			return reservationDao.selectGroupRid(conn, startdate, groupleader, starttime);
		} catch (SQLException e) {
			throw new ServiceException("해당 아이디가 존재하지 않습니다:" + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}

	}

	public ReservationListView getReservationList(int pageNumber, String startDate, String endDate, String id) {
																					// 페이지 번호, 검색조건(~부터 ~까지), id를 통한 예약 현황 리스트 리턴
		Connection conn = null;
		int currentPageNumber = pageNumber;
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();

			int reservationTotalCount = reservationDao.selectCount(conn, startDate, endDate, id);

			List<Reservation> reservationList = null;
			int firstRow = 0;
			int endRow = 0;
			if (reservationTotalCount > 0) {
				firstRow = (pageNumber - 1) * COUNT_PER_PAGE;
				endRow = firstRow + COUNT_PER_PAGE;
				reservationList = reservationDao.selectList(conn, firstRow, endRow, id, startDate, endDate);
			} else {
				currentPageNumber = 0;
				reservationList = Collections.emptyList();
			}
			return new ReservationListView(reservationList, reservationTotalCount, currentPageNumber, COUNT_PER_PAGE,
					firstRow, endRow);
		} catch (SQLException e) {
			throw new ServiceException("목록 구하기 실패: " + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}

	}
	
	// 해당 예약정보와 중복되는 예약이 있는지 검색
	public Boolean isDuplicationReservation(Reservation reservation){
		List<Reservation> dayResevationInfo = new ArrayList<Reservation>();		
		Connection conn = null;
		boolean duplicationFlag = false;
		
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();
			dayResevationInfo = reservationDao.select(conn, reservation.getSid(), reservation.getStartdate());
			
			if(dayResevationInfo != null){
				for(int i = 0; i < dayResevationInfo.size(); i++){
					int lStartTime = Integer.parseInt(reservation.getStarttime().toString().split(":")[0]);
					int lEndTime = lStartTime + reservation.getUsingtime();
					int rStartTime = Integer.parseInt(dayResevationInfo.get(i).getStarttime().toString().split(":")[0]);
					int rEndTime = rStartTime + dayResevationInfo.get(i).getUsingtime();
					
					if(lStartTime < rEndTime && lEndTime > rStartTime){
						duplicationFlag = true;
					}
				}
			}
			
		} catch (SQLException e) {
			throw new ServiceException("해당 아이디가 존재하지 않습니다:" + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}
		
		return duplicationFlag;
	}
}
