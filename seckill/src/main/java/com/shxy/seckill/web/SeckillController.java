package com.shxy.seckill.web;

import com.shxy.seckill.dto.Exposer;
import com.shxy.seckill.dto.SeckillExecution;
import com.shxy.seckill.dto.SeckillResult;
import com.shxy.seckill.entity.Seckill;
import com.shxy.seckill.enums.SeckillStateEnum;
import com.shxy.seckill.exception.RepeatKillException;
import com.shxy.seckill.exception.SeckillCloseException;
import com.shxy.seckill.exception.SeckillException;
import com.shxy.seckill.service.ISeckillService;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;
import java.util.Objects;


@Controller//负责接收前端浏览器/js的HTTP请求，调用service业务层，再把页面视图或者json数据返回给前端，是前后交互的入口
@RequestMapping("/seckill")
public class SeckillController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private ISeckillService seckillService;

    @GetMapping("/list")
    public String List(Model model) {
        //获取秒杀商品的详情
        List<Seckill> list = seckillService.getSeckillList();
        model.addAttribute("list", list);
        //返回list.jsp
        return "list";
    }

    @GetMapping("/{seckillId}/detail")
    public String detail(@PathVariable Long seckillId, Model model) {
        if (Objects.isNull(seckillId)) {
            return "redirect:/seckill/list";
        }
        Seckill secKillById = seckillService.getSecKillById(seckillId);
        if (Objects.isNull(secKillById)) {
            return "redirect:/seckill/list";
        }
        model.addAttribute("seckill", secKillById);
        //返回detail.jsp
        return "detail";
    }

    //不再跳转jsp,直接把返回对象序列化为JSON字符串返回给前端AJAX
    @ResponseBody
    @GetMapping(value = "/{seckillId}/exposer", produces = "application/json;charset=UTF-8")//produces解决中文乱码问题
    public SeckillResult<Exposer> exposer(@PathVariable Long seckillId) {
        SeckillResult<Exposer> result;
        try {
            Exposer exposer = seckillService.exportSeckillUrl(seckillId);
            result = new SeckillResult<Exposer>(true, exposer);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            result = new SeckillResult<Exposer>(false, e.getMessage());
        }
        return result;
    }

    @PostMapping(value = "/{seckillId}/{md5}/execution", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public SeckillResult<SeckillExecution> execute(@PathVariable Long seckillId, @PathVariable String md5, @CookieValue("killPhone") Long userPhone) {
        if (Objects.isNull(userPhone)) {
            return new SeckillResult<SeckillExecution>(false, "用户手机号缺失，请填写手机号");
        }
        SeckillResult<SeckillExecution> result;
        try {
            SeckillExecution seckillExecution = seckillService.executeSeckill(seckillId, userPhone, md5);
            return new SeckillResult<SeckillExecution>(true, seckillExecution);
        } catch (RepeatKillException e) {
            SeckillExecution seckillExecution = new SeckillExecution(seckillId, SeckillStateEnum.REPEAT_KILL, null);
            return new SeckillResult<SeckillExecution>(false, seckillExecution);

        } catch (SeckillCloseException e) {
            SeckillExecution seckillExecution = new SeckillExecution(seckillId, SeckillStateEnum.END, null);
            return new SeckillResult<SeckillExecution>(false, seckillExecution);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            SeckillExecution seckillExecution = new SeckillExecution(seckillId, SeckillStateEnum.INNER_ERROR, null);
            return new SeckillResult<SeckillExecution>(false, seckillExecution);
        }
    }
    //返回服务器时间戳，解决用户本地电脑时间不准，导致计时错乱的问题
    @GetMapping("/time/now")
    @ResponseBody
    public SeckillResult<Long> time() {
        Date now = new Date();
        return new SeckillResult<Long>(true, now.getTime());
    }
}
