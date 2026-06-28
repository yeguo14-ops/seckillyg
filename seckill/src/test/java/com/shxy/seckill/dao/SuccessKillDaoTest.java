package com.shxy.seckill.dao;

import com.shxy.seckill.entity.SuccessKilled;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@SpringBootTest
@RunWith(SpringRunner.class)
class SuccessKillDaoTest {
    @Autowired
    private SuccessKilledDao successKilledDao;
    @Test
    void insertSuccessKilled() {
    long seckillId=1000;
    long userPhone=12345678900L;
    int result= successKilledDao.insertSuccessKilled(seckillId,userPhone);
    System.out.println("SuccessKilled number is"+result);
    }

    @Test
    void queryByIdWithSeckill() {
        long seckillId=1000;
        long userPhone=12345678900L;
        SuccessKilled successKilled = successKilledDao.queryByIdWithSeckill(seckillId, userPhone);
        System.out.println(successKilled);
    }
}