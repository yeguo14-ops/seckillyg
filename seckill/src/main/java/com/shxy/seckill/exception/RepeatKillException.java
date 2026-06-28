package com.shxy.seckill.exception;

public class RepeatKillException extends SeckillException {

    public RepeatKillException(String message) {
        super(message);
    }

    public RepeatKillException(String message, Throwable throwable) {
        super(message, throwable);
    }
}
