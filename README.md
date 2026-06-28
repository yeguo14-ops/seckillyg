# seckillyg
基于 Spring Boot + MyBatis 构建高并发秒杀业务系统，重点实践 Java 面向对象设计、分层架构、事务控制及异常处理机制。采用经典三层架构： Web 层：SeckillController 接收 HTTP 请求，返回 JSP 视图或 JSON 数据 Service 层：SeckillServiceImpl 处理核心业务逻辑，注解式事务控制 DAO 层：SeckillDao、SuccessKilledDao 通过 MyBatis XML 映射操作数据库
