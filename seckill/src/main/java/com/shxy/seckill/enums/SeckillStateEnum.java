package com.shxy.seckill.enums;

import com.shxy.seckill.entity.Seckill;
import org.omg.PortableInterceptor.SUCCESSFUL;

public enum  SeckillStateEnum {
    SUCCESS(1,"秒杀成功"),
    END(0,"秒杀结束"),
    REPEAT_KILL(-1,"重复秒杀"),
    INNER_ERROR(-2,"系统异常"),
    DATA_REWRITE(-3,"秒杀数据被篡改");

    //状态码
    private int state;
    //说明符
    private String stateInfo;
    //枚举的构造强制私有化
    SeckillStateEnum(int state, String stateInfo) {
        this.state = state;
        this.stateInfo = stateInfo;
    }
    public int getState(){
        return state;
    }
    public String getStateInfo(){
        return stateInfo;
    }
    //自定义静态方法
    public static SeckillStateEnum valueOf(int index){
        for(SeckillStateEnum seckillStateEnum: values()){
            if(seckillStateEnum.getState()==index){
                return seckillStateEnum;
            }
        }
        return null;
    }
}
