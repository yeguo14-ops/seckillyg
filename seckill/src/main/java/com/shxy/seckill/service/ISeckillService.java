package com.shxy.seckill.service;

import com.shxy.seckill.dto.Exposer;
import com.shxy.seckill.dto.SeckillExecution;
import com.shxy.seckill.entity.Seckill;
import com.shxy.seckill.exception.RepeatKillException;
import com.shxy.seckill.exception.SeckillCloseException;
import com.shxy.seckill.exception.SeckillException;
import jdk.Exported;

import java.util.List;
import java.util.concurrent.Executor;

/**
 * 业务逻辑层接口：站在使用者的角度去设计这个接口
 * 1、定义方法的粒度
 * 2、参数
 * 3、返回类型（业务信息、友好的异常）
 */
public interface ISeckillService {
    //查询所有的秒杀商品列表
    List<Seckill> getSeckillList();
    //查询单个秒杀商品
    Seckill getSecKillById(long seckillId);
    //在秒杀开启之前，输出秒杀接口的地址，否则不满住秒杀条件时输出系统时间和秒杀时间
    Exposer exportSeckillUrl(long seckillId);
    //执行秒杀操作，有可能秒杀成功，也可能秒杀失败（需要定义一些执行时的异常）
    SeckillExecution executeSeckill(long seckillId, long userPhone, String md5)
            throws SeckillException, RepeatKillException, SeckillCloseException;

}
