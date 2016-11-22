package lab.reservation.service;

import java.util.List;

import lab.reservation.model.Reservation;

public class ReservationListView {

	// 예약 정보 검색 결과 리스트
	// 현재 페이지 번호 구현 x
	
	private int ReservationTotalCount;
	private int currentPageNumber;
	private List<Reservation> ReservationList;
	private int pageTotalCount;
	private int ReservationCountPerPage;
	private int firstRow;
	private int endRow; 

	public ReservationListView(List<Reservation> ReservationList, int ReservationTotalCount, 
			int currentPageNumber, int ReservationCountPerPage, 
			int startRow, int endRow) {
		this.ReservationList = ReservationList;
		this.ReservationTotalCount = ReservationTotalCount;
		this.currentPageNumber = currentPageNumber;
		this.ReservationCountPerPage = ReservationCountPerPage;
		this.firstRow = startRow;
		this.endRow = endRow;

		calculatePageTotalCount();
	}

	private void calculatePageTotalCount() {
		if (ReservationTotalCount == 0) {
			pageTotalCount = 0;
		} else {
			pageTotalCount = ReservationTotalCount / ReservationCountPerPage;
			if (ReservationTotalCount % ReservationCountPerPage > 0) {
				pageTotalCount++;
			}
		}
	}

	public int getReservationTotalCount() {
		return ReservationTotalCount;
	}

	public int getCurrentPageNumber() {
		return currentPageNumber;
	}

	public List<Reservation> getReservationList() {
		return ReservationList;
	}

	public int getPageTotalCount() {
		return pageTotalCount;
	}

	public int getReservationCountPerPage() {
		return ReservationCountPerPage;
	}

	public int getFirstRow() {
		return firstRow;
	}

	public int getEndRow() {
		return endRow;
	}

	public boolean isEmpty() {
		return ReservationTotalCount == 0;
	}
}