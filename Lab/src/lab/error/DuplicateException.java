package lab.error;

public class DuplicateException extends RuntimeException{
	public DuplicateException(String message, Exception cause) {
		super(message, cause);
	}

	public DuplicateException(String message) {
		super(message);
	}
}