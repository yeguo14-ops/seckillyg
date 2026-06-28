package com.shxy.seckill;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * SpringBoot项目的启动类
 */
@SpringBootApplication
@MapperScan(basePackages = "com.shxy.seckill.dao")
@EnableTransactionManagement//用于启用注解式的事务管理功能
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

}
