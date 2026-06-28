package com.shxy.seckill.dao;

import com.shxy.seckill.entity.Seckill;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
@SpringBootTest
@RunWith(SpringRunner.class)
class SeckillDaoTest {
    @Resource
    private SeckillDao seckillDao;
    @Test
    void reduceNumber() {
        long seckillId=1000;
        Date date =new Date();
        int reduceNumber=seckillDao.reduceNumber(seckillId,date);
        System.out.println("reduceNumber is"+ reduceNumber);
    }

    @Test
    void queryById() {
        long seckillId=1000;
        Seckill seckill=seckillDao.queryById(seckillId);
        System.out.println(seckill);
    }

    @Test
    void queryAll() {
        List<Seckill> result = seckillDao.queryAll(0, 100);
        System.out.println(result);

    }
}