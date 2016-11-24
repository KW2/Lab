package lab.pauseroom.model;

import java.sql.Date;

public class PauseRoom {
	private int pid;
	private String labroom;
	private Date pausestart;
	private Date pauseend;
	private String reason;
	public int getPid() {
		return pid;
	}
	public void setPid(int pid) {
		this.pid = pid;
	}
	public String getLabroom() {
		return labroom;
	}
	public void setLabroom(String labRoom) {
		this.labroom = labRoom;
	}
	public Date getPausestart() {
		return pausestart;
	}
	public void setPausestart(Date pausestart) {
		this.pausestart = pausestart;
	}
	public Date getPauseend() {
		return pauseend;
	}
	public void setPauseend(Date pauseend) {
		this.pauseend = pauseend;
	}
	public String getReason() {
		return reason;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	
	

	
	
	

}
