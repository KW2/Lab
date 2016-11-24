package lab.error;

public class UserNotFoundException extends ServiceException {

	public UserNotFoundException(String message) {
		super(message);
	}

}
