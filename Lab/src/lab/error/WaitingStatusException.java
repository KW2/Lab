package lab.error;

public class WaitingStatusException extends RuntimeException {

	public WaitingStatusException(String message, Exception cause) {
		super(message, cause);
	}

	public WaitingStatusException(String message) {
		super(message);
	}

}//변
