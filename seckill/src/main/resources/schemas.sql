create database seckill;
show databases;
use seckill;

SET SESSION sql_mode = '';

create table seckill
(
    `seckill_id`  bigint       not null auto_increment comment '商品库存ID',
    `name`        varchar(128) not null comment '商品名称',
    `number`      int          not null comment '商品库存数量',
    `create_time` timestamp    not null default CURRENT_TIMESTAMP comment '创建时间',
    `start_time`  timestamp    not null comment '秒杀开始时间',
    `end_time`    timestamp    not null comment '秒杀结束时间',
    primary key (seckill_id),
    key idx_start_time (start_time),
    key idx_end_time (end_time),
    key idx_create_time (create_time)
) engine = INNODB
  auto_increment = 1000
  default charset = utf8 comment '秒杀商品库存表';

insert into seckill(name, number, start_time, end_time)
values ('5000元秒杀Iphone手机', 100, '2025-05-01 00:00:00', '2025-05-31 00:00:00'),
       ('3000元秒杀Iphone手机', 200, '2025-05-01 00:00:00', '2025-05-31 00:00:00'),
       ('10000元秒杀MacBook电脑', 50, '2025-05-01 00:00:00', '2025-05-31 00:00:00'),
       ('15000元秒杀IMac电脑', 10, '2025-05-01 00:00:00', '2025-05-31 00:00:00')

create table success_killed(
                               `seckill_id`  bigint       not null  comment '秒杀商品ID',
                               `user_phone`  bigint       not null  comment '用户手机号码',
                               `state`      tinyint       not null default -1 comment '秒杀的状态表示 -1 无效 0 秒杀成功， 1 已付款， 2 已发货',
                               `create_time` timestamp    not null default CURRENT_TIMESTAMP comment '订单创建时间',
                               primary key (seckill_id,user_phone),/*联合索引，提高查询速度*/
                               key idx_create_time (create_time)
)engine = INNODB
 default charset = utf8 comment '秒杀成功明细表';
