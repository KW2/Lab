package lab.reservation.service;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.function.Predicate;

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
	
	// 일반예약시 해당 예약정보와 중복되는 예약이 있는지 검색
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
	
	// 수정예약시 해당 예약정보와 중복되는 예약이 있는지 검색
	public Boolean isUpdateDuplicationReservation(Reservation reservation, int rid){
		List<Reservation> dayResevationInfo = new ArrayList<Reservation>();		
		Connection conn = null;
		boolean duplicationFlag = false;
		
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();
			dayResevationInfo = reservationDao.select(conn, reservation.getSid(), reservation.getStartdate());
			
			dayResevationInfo.removeIf(new Predicate<Reservation>() {
				@Override
				public boolean test(Reservation t) {
					// TODO Auto-generated method stub
					if(t.getRid() == rid){
						return false;
					}
					return true;
				}				
			});
			
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
	
	public List<Reservation> getList(int pageNumber, Date StartDate, Date EndDate) {
		Connection conn = null;
		List<Reservation> dataList = new ArrayList<Reservation>();
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao messageDao = ReservationDao.getInstance();
			int messageTotalCount = messageDao.selectCount(conn, StartDate, EndDate);	//헤당 날짜 사이의 위치하는 예약 내역 갯수 저장
			int firstRow = 0;
			int endRow = 0;  
			if (messageTotalCount > 0) {
				firstRow =
						(pageNumber - 1) * COUNT_PER_PAGE + 1;	//1 -> 1, 2 -> 11, ...
				endRow = firstRow + COUNT_PER_PAGE - 1;	//1 -> 10, 2 -> 20, ...
				dataList = messageDao.selectDataList(conn, firstRow, endRow, StartDate, EndDate);	//firstRow와 endRow사이에 위치한 예약 내역 저장
			} else {
				dataList = Collections.emptyList();
			}
		} catch (SQLException e) {
			
		} finally {
			JdbcUtil.close(conn);
		}
		return dataList;
	}	//입력한 날짜와 현재 페이지에 대응하는 예약 내역 리턴
	
	public int getPageSize(Date StartDate, Date EndDate){
		Connection conn = null;
		int pageSize = 0;
		try {
			int dataSize = 0;
			conn = ConnectionProvider.getConnection();
			ReservationDao messageDao = ReservationDao.getInstance();
			dataSize = messageDao.selectCount(conn, StartDate, EndDate);	//입력한 날짜들에 사이에 위치하는 날짜값을 가진 투플 수 저장
			if (dataSize == 0) {
				pageSize = 0;	//해당하는 데이터가 없으면 0 리턴
			} else {
				pageSize = dataSize / COUNT_PER_PAGE;
				if (dataSize % COUNT_PER_PAGE > 0) {
					pageSize++;
				}
			}
		} catch(Exception e){
		} finally{
			JdbcUtil.close(conn);
		}
		return pageSize;
	}	//입력한 날짜 사이의 포함되는 데이터의 전체 페이지의 수를 리턴
	
	public String getLabroom(int rid) {						// rid를 통한 특정 예약 정보 리턴
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();
			return reservationDao.selectLabRoom(conn, rid);
		} catch (SQLException e) {
			throw new ServiceException("해당 아이디가 존재하지 않습니다:" + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}

	}
	
	public String getGroupLeader(int rid) {						// rid를 통한 특정 예약 정보 리턴
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();
			return reservationDao.selectGroupLeader(conn, rid);
		} catch (SQLException e) {
			throw new ServiceException("해당 아이디가 존재하지 않습니다:" + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}

	}
	
	public List<Integer> getRid(String sid, Date date, Time time) {						// rid를 통한 특정 예약 정보 리턴
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();
			return reservationDao.selectRid(conn, sid, date, time);
		} catch (SQLException e) {
			throw new ServiceException("해당 아이디가 존재하지 않습니다:" + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}

	}
	
	public List<String> getSid(String sid, Date date, Time time) {						// rid를 통한 특정 예약 정보 리턴
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();
			return reservationDao.selectSid(conn, sid, date, time);
		} catch (SQLException e) {
			throw new ServiceException("해당 아이디가 존재하지 않습니다:" + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}

	}
	
	public List<String> getGroupStudentId(String groupleader, Date startdate) {			// 단체원 리스트 출력에 사용
		Connection conn = null;														// groupleader, startdate 로 단체예약에 대한 sid들 리턴
		try {
			conn = ConnectionProvider.getConnection();
			ReservationDao reservationDao = ReservationDao.getInstance();
			return reservationDao.selectGroupSid(conn, startdate, groupleader);
		} catch (SQLException e) {
			throw new ServiceException("해당 아이디가 존재하지 않습니다:" + e.getMessage(), e);
		} finally {
			JdbcUtil.close(conn);
		}

	}
	
}
