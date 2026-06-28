package com.shxy.seckill.service.impl;

import com.shxy.seckill.dto.Exposer;
import com.shxy.seckill.dto.SeckillExecution;
import com.shxy.seckill.entity.Seckill;
import com.shxy.seckill.exception.RepeatKillException;
import com.shxy.seckill.exception.SeckillCloseException;
import com.shxy.seckill.service.ISeckillService;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
@SpringBootTest
@RunWith(SpringRunner.class)
class SeckillServiceImplTest {

    private final Logger logger= LoggerFactory.getLogger(this.getClass());
    @Autowired
    private ISeckillService seckillService;

    @Test
    void getSeckillList() {
        List<Seckill> seckillList=seckillService.getSeckillList();
        logger.info("list:{}",seckillList);
    }

    @Test
    void getSecKillById() {
        long id=1000;
        Seckill secKillById = seckillService.getSecKillById(id);
        logger.info("seckill={}",secKillById);
    }

    @Test
    void exportSeckillUrl() {
        long id=1000;
        Exposer exposer = seckillService.exportSeckillUrl(id);
        logger.info("exposer={}",exposer);
    }

    @Test
    void executeSeckill() {
        long id = 1000;
        long userPhone = 12345678900L;
        String md5 = "8a314a42c9dce74af5a83d760e23b351";
        try {
            SeckillExecution seckillExecution = seckillService.executeSeckill(id, userPhone, md5);
            logger.info("result:{}", seckillExecution);
        } catch (RepeatKillException e) {
            logger.error(e.getMessage());
        } catch (SeckillCloseException e) {
            logger.error(e.getMessage());
        }
    }
}