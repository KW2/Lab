package lab.reservation.service;

import lab.reservation.service.ServiceException;

public class ReservationNotFoundException extends ServiceException {

	public ReservationNotFoundException(String message) {
		super(message);
	}	
}