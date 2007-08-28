package org.d5.lib;

import java.sql.*;


/*
 * 本函数用于操作MYSQL数据库
 * 配置文件为db.proerties
 */

public class d5Mysql
{

	//构造函数，指定数据库资料
	public void d5Set(String h,String u,String p)
	{
		host = h;
		username = u;
		password = p;
	}
	
	//连接数据库。根据目前设置的数据进行数据库连接
	public static Connection getConnection()
	{
		// 设置Drivers
		try
		{
			Class.forName( "com.mysql.jdbc.Driver" ); 
			connection = DriverManager.getConnection(host, username, password );
		}catch(Exception e){
			System.err.println("装载 JDBC/ODBC 驱动程序失败。" ); 
			e.printStackTrace(); 
			System.exit(1); // terminate program 
		}
		
		return connection;
	}

	//基本数据库查询，返回查询成功或失败
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