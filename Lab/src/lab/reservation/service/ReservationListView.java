package lab.reservation.service;

import java.util.List;

import lab.reservation.model.Reservation;

public class ReservationListView {

	// 예약 정보 검색 결과 리스트

	private int reservationTotalCount;
	private int currentPageNumber;
	private List<Reservation> reservationList;
	private int pageTotalCount;
	private int reservationCountPerPage;
	private int firstRow;
	private int endRow;

	public ReservationListView(List<Reservation> ReservationList, int ReservationTotalCount, int currentPageNumber,
			int ReservationCountPerPage, int startRow, int endRow) {
		this.reservationList = ReservationList;
		this.reservationTotalCount = ReservationTotalCount;
		this.currentPageNumber = currentPageNumber;
		this.reservationCountPerPage = ReservationCountPerPage;
		this.firstRow = startRow;
		this.endRow = endRow;

		calculatePageTotalCount();
	}

	private void calculatePageTotalCount() {
		if (reservationTotalCount == 0) {
			pageTotalCount = 0;
		} else {
			pageTotalCount = reservationTotalCount / reservationCountPerPage;
			if (reservationTotalCount % reservationCountPerPage > 0) {
				pageTotalCount++;
			}
		}
	}

	public int getReservationTotalCount() {
		return reservationTotalCount;
	}

	public int getCurrentPageNumber() {
		return currentPageNumber;
	}

	public List<Reservation> getReservationList() {
		return reservationList;
	}

	public int getPageTotalCount() {
		return pageTotalCount;
	}

	public int getReservationCountPerPage() {
		return reservationCountPerPage;
	}

	public int getFirstRow() {
		return firstRow;
	}

	public int getEndRow() {
		return endRow;
	}

	public boolean isEmpty() {
		return reservationTotalCount == 0;
	}
}