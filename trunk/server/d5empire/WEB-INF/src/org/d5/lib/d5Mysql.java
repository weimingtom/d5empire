package org.d5.lib;

import java.sql.*;


/*
 * ���������ڲ���MYSQL���ݿ�
 * �����ļ�Ϊdb.proerties
 */

public class d5Mysql
{

	//���캯����ָ�����ݿ�����
	public void d5Set(String h,String u,String p)
	{
		host = h;
		username = u;
		password = p;
	}
	
	//�������ݿ⡣����Ŀǰ���õ����ݽ������ݿ�����
	public static Connection getConnection()
	{
		// ����Drivers
		try
		{
			Class.forName( "com.mysql.jdbc.Driver" ); 
			connection = DriverManager.getConnection(host, username, password );
		}catch(Exception e){
			System.err.println("װ�� JDBC/ODBC ��������ʧ�ܡ�" ); 
			e.printStackTrace(); 
			System.exit(1); // terminate program 
		}
		
		return connection;
	}

	//�������ݿ��ѯ�����ز�ѯ�ɹ���ʧ��
	public boolean db_query(String sql)
	{
		Statement stmt = null;
		try
		{
			Connection conn=getConnection();
			stmt=conn.createStatement();
			return (stmt.execute(sql));
		}catch(Throwable ex){
			System.out.println(ex.toString());
			return false;
		}
	}
	
	
	private static Connection connection;
	private static String host = "jdbc:mysql://localhost:3306/mouse";
	private static String username = "root";
	private static String password = "mysql";
}