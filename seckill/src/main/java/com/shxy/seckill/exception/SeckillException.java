package com.shxy.seckill.exception;

import com.shxy.seckill.enums.SeckillStateEnum;

import javax.management.RuntimeErrorException;

//秒杀业务出现异常时使用的异常类
public class SeckillException extends RuntimeException {
    public SeckillException(String message){
        super(message);
    }
    public SeckillException(String message,Throwable throwable){
        super(message,throwable);
    }


}
