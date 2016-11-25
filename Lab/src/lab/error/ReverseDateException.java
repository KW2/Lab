package lab.error;

public class ReverseDateException extends RuntimeException{
	public ReverseDateException(String message, Exception cause) {
		super(message, cause);
	}

	public ReverseDateException(String message) {
		super(message);
	}
}
