package lab.reservation.model;

import java.sql.Date;
import java.sql.Time;

public class Reservation {
	private int rid;
	private String labroom;
	private String sid;
	private Date startdate;
	private Time starttime;
	private int usingtime;
	private String purpose;
	private boolean team;
	private String groupleader;
	private String approval;

	public Reservation(){}
	public Reservation(int rid, String labroom, String sid, Date startdate, Time starttime, int usingtime, boolean team,
			String approval, String purpose, String groupleader){
		this.rid = rid;
		this.labroom = labroom;
		this.sid = sid;
		this.startdate = startdate;
		this.starttime = starttime;
		this.usingtime = usingtime;
		this.team = team;
		this.approval = approval;
		this.purpose = purpose;
		this.groupleader = groupleader;
	}
	
	public int getRid() {
		return rid;
	}

	public void setRid(int rid) {
		this.rid = rid;
	}

	public String getLabroom() {
		return labroom;
	}

	public void setLabroom(String labroom) {
		this.labroom = labroom;
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public Date getStartdate() {
		return startdate;
	}

	public void setStartdate(Date startdate) {
		this.startdate = startdate;
	}

	public Time getStarttime() {
		return starttime;
	}

	public void setStarttime(Time starttime) {
		this.starttime = starttime;
	}

	public int getUsingtime() {
		return usingtime;
	}

	public void setUsingtime(int usingtime) {
		this.usingtime = usingtime;
	}

	public String getPurpose() {
		return purpose;
	}

	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}

	public boolean isTeam() {
		return team;
	}

	public void setTeam(boolean team) {
		this.team = team;
	}

	public String getGroupleader() {
		return groupleader;
	}

	public void setGroupleader(String groupleader) {
		this.groupleader = groupleader;
	}

	public String getApproval() {
		return approval;
	}

	public void setApproval(String approval) {
		this.approval = approval;
	}

}
