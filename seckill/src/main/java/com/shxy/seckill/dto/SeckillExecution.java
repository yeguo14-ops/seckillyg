package com.shxy.seckill.dto;

import com.shxy.seckill.entity.SuccessKilled;
import com.shxy.seckill.enums.SeckillStateEnum;

//执行秒杀返回的结果
public class SeckillExecution {
    //秒杀商品Id
    private long seckillId;
    //执行秒杀的状态
    private int state;
    //秒杀成功后，需要把秒杀的信息（successKilled）传给web层
    private SuccessKilled successKilled;
    //状态标识
    private String stateInfo;

    //执行成功，则返回所有信息，失败，只返回秒杀商品的id和执行的状态
    public SeckillExecution(long seckillId, SeckillStateEnum seckillStateEnum, SuccessKilled successKilled) {
        this.seckillId = seckillId;
        this.state = seckillStateEnum.getState();
        this.successKilled = successKilled;
        this.stateInfo = seckillStateEnum.getStateInfo();
    }

    public SeckillExecution(long seckillId, int state) {
        this.seckillId = seckillId;
        this.state = state;
    }

    public long getSeckillId() {
        return seckillId;
    }

    public void setSeckillId(long seckillId) {
        this.seckillId = seckillId;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public SuccessKilled getSuccessKilled() {
        return successKilled;
    }

    public void setSuccessKilled(SuccessKilled successKilled) {
        this.successKilled = successKilled;
    }

    public String getStateInfo() {
        return stateInfo;
    }

    public void setStateInfo(String stateInfo) {
        this.stateInfo = stateInfo;
    }

    @Override
    public String toString() {
        return "SeckillExecution{" +
                "seckillId=" + seckillId +
                ", state=" + state +
                ", successKilled=" + successKilled +
                ", stateInfo='" + stateInfo + '\'' +
                '}';
    }
}
