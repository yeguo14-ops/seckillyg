package com.shxy.seckill.dao;

import com.shxy.seckill.entity.SuccessKilled;

//商品秒杀成功相关的数据访问层结构
public interface SuccessKilledDao {
    //通过秒杀商品的Id和用户的手机号生成秒杀成功订单
    int insertSuccessKilled(long seckillId, long userPhone);
    //查询秒杀成功的信息
    SuccessKilled queryByIdWithSeckill(long seckillId, long userPhone);

}
