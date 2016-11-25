package lab.error;

public class EqualStatusException extends RuntimeException{
	public EqualStatusException(String message, Exception cause) {
		super(message, cause);
	}

	public EqualStatusException(String message) {
		super(message);
	}
}
