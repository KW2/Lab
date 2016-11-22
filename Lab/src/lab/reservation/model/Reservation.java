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
     private boolean team;
     private String status;
     private String purpose;
     private String groupleader;
	
    public String getGroupleader() {
		return groupleader;
	}
	public void setGroupleader(String groupleader) {
		this.groupleader = groupleader;
	}
	public String getPurpose() {
		return purpose;
	}
	public void setPurpose(String purpose) {
		this.purpose = purpose;
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
	public boolean isTeam() {
		return team;
	}
	public void setTeam(boolean team) {
		this.team = team;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	@Override
	public String toString() {
		return "Reservation [rid=" + rid + ", labroom=" + labroom + ", sid=" + sid + ", startdate=" + startdate
				+ ", starttime=" + starttime + ", usingtime=" + usingtime + ", team=" + team + ", status=" + status
				+ ", purpose=" + purpose + ", groupleader=" + groupleader + "]";
	}
     
     
	
    
     
    
     
     
    
}
