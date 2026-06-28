package com.shxy.seckill.entity;

import java.util.Date;

public class SuccessKilled {
    //秒杀商品ID
    private Long seckillId;
    //用户手机号
    private  Long userPhone;
    //秒杀信息状态
    private short state;
    //秒杀订单创建时间
    private Date createTime;
    //一对多关系，一件商品在库存中会有很多数量，秒杀同一件商品的订单也会有多个
    private Seckill seckill;

    public Long getSeckillId() {
        return seckillId;
    }

    public void setSeckillId(Long seckillId) {
        this.seckillId = seckillId;
    }

    @Override
    public String toString() {
        return "SuccessKilled{" +
                "seckillId=" + seckillId +
                ", userPhone=" + userPhone +
                ", state=" + state +
                ", createTime=" + createTime +
                ", seckill=" + seckill +
                '}';
    }
}
