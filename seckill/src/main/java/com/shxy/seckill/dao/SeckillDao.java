package com.shxy.seckill.dao;

import com.shxy.seckill.entity.Seckill;

import java.util.Date;
import java.util.List;

//秒杀产品信息的数据访问层接口
public interface SeckillDao {
    //秒杀成功后，减少商品库存
    int reduceNumber(long seckillId, Date killTime);

    //通过Id查询秒杀商品信息
    Seckill queryById(long seckillId);

    //查询所有秒杀商品信息
    List<Seckill> queryAll(int offset, int limit);

}
