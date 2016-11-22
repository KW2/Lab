package lab.user.service;

import java.sql.Connection;
import java.sql.SQLException;

import jdbc.JdbcUtil;
import jdbc.connection.ConnectionProvider;
import lab.reservation.service.ServiceException;
import lab.user.dao.StudentDao;
import lab.user.model.Student;

public class SelectStudentService {
        private static SelectStudentService instance = new SelectStudentService();
        
        public static SelectStudentService getInstance(){
        	return instance;
        }

      private SelectStudentService(){
    	       
      }
    
      public Student getStudentInfo(String sid){
    	  Connection conn = null;
    	  try{
    			conn = ConnectionProvider.getConnection();
    		    StudentDao studentDao = StudentDao.getInstance();
    	        return studentDao.select(conn,sid);
    	  }catch(SQLException e){
    		   throw new ServiceException("해당 아이디가 존재하지 않습니다:"+ e.getMessage(), e);
    	  }finally{
    		  JdbcUtil.close(conn);
    	  }
    	  
      }
   

}
