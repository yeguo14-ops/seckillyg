package com.shxy.seckill.service.impl;

import com.shxy.seckill.dao.SeckillDao;
import com.shxy.seckill.dao.SuccessKilledDao;
import com.shxy.seckill.dto.Exposer;
import com.shxy.seckill.dto.SeckillExecution;
import com.shxy.seckill.entity.Seckill;
import com.shxy.seckill.entity.SuccessKilled;
import com.shxy.seckill.enums.SeckillStateEnum;
import com.shxy.seckill.exception.RepeatKillException;
import com.shxy.seckill.exception.SeckillCloseException;
import com.shxy.seckill.exception.SeckillException;
import com.shxy.seckill.service.ISeckillService;
import org.apache.logging.log4j.util.Strings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.DigestUtils;

import java.util.Date;
import java.util.List;
import java.util.Objects;

@Service
public class SeckillServiceImpl implements ISeckillService {
    private Logger logger = LoggerFactory.getLogger(this.getClass());
    @Autowired
    private SeckillDao seckillDao;
    @Autowired
    private SuccessKilledDao successKilledDao;

    private final String slat = "aasdfghjkl952175";

    private String getMD5(long seckillId) {
        String base = seckillId + "/" + slat;
        String md5 = DigestUtils.md5DigestAsHex(base.getBytes());
        return md5;
    }

    @Override
    public List<Seckill> getSeckillList() {
        return seckillDao.queryAll(0, 4);
    }

    @Override
    public Seckill getSecKillById(long seckillId) {
        return seckillDao.queryById(seckillId);
    }

    @Override
    public Exposer exportSeckillUrl(long seckillId) {
        Seckill seckill = seckillDao.queryById(seckillId);
        if (Objects.isNull(seckill)) {
            return new Exposer(false, seckillId);
        }
        Date startTime = seckill.getStartTime();
        Date endTime = seckill.getEndTime();
        //系统时间按，用来与秒杀开启时间与结束时间做比较
        Date nowDate = new Date();
        if (nowDate.getTime() < startTime.getTime() || nowDate.getTime() > endTime.getTime()) {
            return new Exposer(false, seckillId, nowDate.getTime(), startTime.getTime(), endTime.getTime());
        }
        //使用MD5工具类，对seckillId加密
        String md5 = getMD5(seckillId);//加密TODO
        return new Exposer(true, md5, seckillId);
    }

    @Override
    @Transactional//标记为事务方法，要么失败，要么成功，保证数据一至
    public SeckillExecution executeSeckill(long seckillId, long userPhone, String md5)
            throws SeckillException, RepeatKillException, SeckillCloseException {
        if (Strings.isBlank(md5) || !md5.equals(getMD5(seckillId))) {
            throw new SeckillException("md5 is black or seckillId is false");
        }
        //执行秒杀，秒杀逻辑：减库存+更新用户购买明细
        Date nowDate = new Date();
        try {
            //减少秒杀商品库存
            int updateCount = seckillDao.reduceNumber(seckillId, nowDate);
            if (updateCount <= 0) {
                throw new SeckillCloseException("seckill is closed!");
            } else {
                //秒杀成功后，记录用户的购买明细
                int insertResult = successKilledDao.insertSuccessKilled(seckillId, userPhone);
                //防止用户重复秒杀
                if (insertResult <= 0) {
                    throw new RepeatKillException("seckill is repeated!");
                } else {
                    //秒杀成功
                    SuccessKilled successKilled = successKilledDao.queryByIdWithSeckill(seckillId, userPhone);
                    return new SeckillExecution(seckillId, SeckillStateEnum.SUCCESS, successKilled);
                }
            }
        } catch (SeckillCloseException seckillCloseException) {
            throw seckillCloseException;
        } catch (RepeatKillException repeatKillException) {
            throw repeatKillException;
        } catch (SeckillException seckillException) {
            throw seckillException;
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            throw new SeckillException("seckill inner error：" + e.getMessage());
        }
    }
}
