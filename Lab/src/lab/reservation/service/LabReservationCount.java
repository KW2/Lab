package lab.reservation.service;

public class LabReservationCount {
	private int lab1;
	private int lab2;
	private int lab3;
	private int lab4;
	private int lab5;
	
	public LabReservationCount(int lab1, int lab2, int lab3, int lab4, int lab5){
		this.lab1 = lab1;
		this.lab2 = lab2;
		this.lab3 = lab3;
		this.lab4 = lab4;
		this.lab5 = lab5;
	}

	public int getLab1() {
		return lab1;
	}

	public void setLab1(int lab1) {
		this.lab1 = lab1;
	}

	public int getLab2() {
		return lab2;
	}

	public void setLab2(int lab2) {
		this.lab2 = lab2;
	}

	public int getLab3() {
		return lab3;
	}

	public void setLab3(int lab3) {
		this.lab3 = lab3;
	}

	public int getLab4() {
		return lab4;
	}

	public void setLab4(int lab4) {
		this.lab4 = lab4;
	}

	public int getLab5() {
		return lab5;
	}

	public void setLab5(int lab5) {
		this.lab5 = lab5;
	}
}
