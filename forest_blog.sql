/*
 Navicat Premium Data Transfer

 Source Server         : Aaron
 Source Server Type    : MySQL
 Source Server Version : 80022
 Source Host           : localhost:3306
 Source Schema         : forest_blog

 Target Server Type    : MySQL
 Target Server Version : 80022
 File Encoding         : 65001

 Date: 23/02/2022 16:09:14
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article`  (
  `article_id` int(0) NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `article_user_id` int(0) UNSIGNED NULL DEFAULT NULL COMMENT '用户ID',
  `article_title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标题',
  `article_content` mediumtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '内容',
  `article_view_count` int(0) NULL DEFAULT 0 COMMENT '访问量',
  `article_comment_count` int(0) NULL DEFAULT 0 COMMENT '评论数',
  `article_like_count` int(0) NULL DEFAULT 0 COMMENT '点赞数',
  `article_is_comment` int(0) UNSIGNED NULL DEFAULT NULL COMMENT '是否允许评论',
  `article_status` int(0) UNSIGNED NULL DEFAULT 1 COMMENT '状态',
  `article_order` int(0) UNSIGNED NULL DEFAULT NULL COMMENT '排序值',
  `article_update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `article_create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `article_summary` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '摘要',
  `article_thumbnail` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '缩略图',
  PRIMARY KEY (`article_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 50 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES (1, 1, '[转载]SpringMVC中使用Interceptor拦截器', '<p>SpringMVC 中的Interceptor 拦截器也是相当重要和相当有用的，它的主要作用是拦截用户的请求并进行相应的处理。比如通过它来进行权限验证，或者是来判断用户是否登陆，或者是像12306 那样子判断当前时间是否是购票时间。</p><p><br></p><p>一、定义Interceptor实现类</p><p>SpringMVC 中的Interceptor 拦截请求是通过HandlerInterceptor 来实现的。在SpringMVC 中定义一个Interceptor 非常简单，主要有两种方式，第一种方式是要定义的Interceptor类要实现了Spring 的HandlerInterceptor 接口，或者是这个类继承实现了HandlerInterceptor 接口的类，比如Spring 已经提供的实现了HandlerInterceptor 接口的抽象类HandlerInterceptorAdapter ；第二种方式是实现Spring的WebRequestInterceptor接口，或者是继承实现了WebRequestInterceptor的类。</p><p><br></p><p>（一）实现HandlerInterceptor接口</p><p>HandlerInterceptor 接口中定义了三个方法，我们就是通过这三个方法来对用户的请求进行拦截处理的。</p><p><br></p><p>（1 ）preHandle (HttpServletRequest request, HttpServletResponse response, Object handle) 方法，顾名思义，该方法将在请求处理之前进行调用。SpringMVC 中的Interceptor 是链式的调用的，在一个应用中或者说是在一个请求中可以同时存在多个Interceptor 。每个Interceptor 的调用会依据它的声明顺序依次执行，而且最先执行的都是Interceptor 中的preHandle 方法，所以可以在这个方法中进行一些前置初始化操作或者是对当前请求的一个预处理，也可以在这个方法中进行一些判断来决定请求是否要继续进行下去。该方法的返回值是布尔值Boolean 类型的，当它返回为false 时，表示请求结束，后续的Interceptor 和Controller 都不会再执行；当返回值为true 时就会继续调用下一个Interceptor 的preHandle 方法，如果已经是最后一个Interceptor 的时候就会是调用当前请求的Controller 方法。</p><p><br></p><p>（2 ）postHandle (HttpServletRequest request, HttpServletResponse response, Object handle, ModelAndView modelAndView) 方法，由preHandle 方法的解释我们知道这个方法包括后面要说到的afterCompletion 方法都只能是在当前所属的Interceptor 的preHandle 方法的返回值为true 时才能被调用。postHandle 方法，顾名思义就是在当前请求进行处理之后，也就是Controller 方法调用之后执行，但是它会在DispatcherServlet 进行视图返回渲染之前被调用，所以我们可以在这个方法中对Controller 处理之后的ModelAndView 对象进行操作。postHandle 方法被调用的方向跟preHandle 是相反的，也就是说先声明的Interceptor 的postHandle 方法反而会后执行，这和Struts2里面的Interceptor 的执行过程有点类型。Struts2 里面的Interceptor 的执行过程也是链式的，只是在Struts2 里面需要手动调用ActionInvocation 的invoke 方法来触发对下一个Interceptor 或者是Action 的调用，然后每一个Interceptor 中在invoke 方法调用之前的内容都是按照声明顺序执行的，而invoke 方法之后的内容就是反向的。</p><p><br></p><p>（3 ）afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handle, Exception ex) 方法，该方法也是需要当前对应的Interceptor 的preHandle 方法的返回值为true 时才会执行。顾名思义，该方法将在整个请求结束之后，也就是在DispatcherServlet 渲染了对应的视图之后执行。这个方法的主要作用是用于进行资源清理工作的。</p><p><br></p><p>下面是一个简单的代码说明：</p><p><br></p><p>import javax.servlet.http.HttpServletRequest;</p><p>import javax.servlet.http.HttpServletResponse;</p><p>import org.springframework.web.servlet.HandlerInterceptor;</p><p>import org.springframework.web.servlet.ModelAndView;</p><p>public class SpringMVCInterceptor implements HandlerInterceptor {</p><p>&nbsp; &nbsp; /**&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* preHandle方法是进行处理器拦截用的，顾名思义，该方法将在Controller处理之前进行调用，SpringMVC中的Interceptor拦截器是链式的，可以同时存在&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* 多个Interceptor，然后SpringMVC会根据声明的前后顺序一个接一个的执行，而且所有的Interceptor中的preHandle方法都会在&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* Controller方法调用之前调用。SpringMVC的这种Interceptor链式结构也是可以进行中断的，这种中断方式是令preHandle的返&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* 回值为false，当preHandle的返回值为false的时候整个请求就结束了。&nbsp;</p><p>&nbsp; &nbsp; &nbsp;*/</p><p>&nbsp; &nbsp; @Override</p><p>&nbsp; &nbsp; public boolean preHandle(HttpServletRequest request,</p><p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; HttpServletResponse response, Object handler) throws Exception {</p><p>&nbsp; &nbsp; &nbsp; &nbsp; // TODO Auto-generated method stub&nbsp;&nbsp;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; return false;</p><p>&nbsp; &nbsp; }</p><p>&nbsp; &nbsp; /**&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* 这个方法只会在当前这个Interceptor的preHandle方法返回值为true的时候才会执行。postHandle是进行处理器拦截用的，它的执行时间是在处理器进行处理之&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* 后，也就是在Controller的方法调用之后执行，但是它会在DispatcherServlet进行视图的渲染之前执行，也就是说在这个方法中你可以对ModelAndView进行操&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* 作。这个方法的链式结构跟正常访问的方向是相反的，也就是说先声明的Interceptor拦截器该方法反而会后调用，这跟Struts2里面的拦截器的执行过程有点像，&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* 只是Struts2里面的intercept方法中要手动的调用ActionInvocation的invoke方法，Struts2中调用ActionInvocation的invoke方法就是调用下一个Interceptor&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* 或者是调用action，然后要在Interceptor之前调用的内容都写在调用invoke之前，要在Interceptor之后调用的内容都写在调用invoke方法之后。&nbsp;</p><p>&nbsp; &nbsp; &nbsp;*/</p><p>&nbsp; &nbsp; @Override</p><p>&nbsp; &nbsp; public void postHandle(HttpServletRequest request,</p><p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; HttpServletResponse response, Object handler,</p><p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ModelAndView modelAndView) throws Exception {</p><p>&nbsp; &nbsp; &nbsp; &nbsp; // TODO Auto-generated method stub&nbsp;&nbsp;</p><p>&nbsp; &nbsp; }</p><p>&nbsp; &nbsp; /**&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* 该方法也是需要当前对应的Interceptor的preHandle方法的返回值为true时才会执行。该方法将在整个请求完成之后，也就是DispatcherServlet渲染了视图执行，&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* 这个方法的主要作用是用于清理资源的，当然这个方法也只能在当前这个Interceptor的preHandle方法的返回值为true时才会执行。&nbsp;</p><p>&nbsp; &nbsp; &nbsp;*/</p><p>&nbsp; &nbsp; @Override</p><p>&nbsp; &nbsp; public void afterCompletion(HttpServletRequest request,</p><p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; HttpServletResponse response, Object handler, Exception ex)</p><p>&nbsp; &nbsp; throws Exception {</p><p>&nbsp; &nbsp; &nbsp; &nbsp; // TODO Auto-generated method stub&nbsp;&nbsp;</p><p>&nbsp; &nbsp; }</p><p>}</p><p>（二）实现WebRequestInterceptor 接口</p><p>WebRequestInterceptor 中也定义了三个方法，我们也是通过这三个方法来实现拦截的。这三个方法都传递了同一个参数WebRequest ，那么这个WebRequest 是什么呢？这个WebRequest 是Spring 定义的一个接口，它里面的方法定义都基本跟HttpServletRequest 一样，在WebRequestInterceptor 中对WebRequest 进行的所有操作都将同步到HttpServletRequest 中，然后在当前请求中一直传递。</p><p><br></p><p>（1 ）preHandle(WebRequest request) 方法。该方法将在请求处理之前进行调用，也就是说会在Controller 方法调用之前被调用。这个方法跟HandlerInterceptor 中的preHandle 是不同的，主要区别在于该方法的返回值是void ，也就是没有返回值，所以我们一般主要用它来进行资源的准备工作，比如我们在使用Hibernate 的时候可以在这个方法中准备一个Hibernate 的Session 对象，然后利用WebRequest 的setAttribute(name, value, scope) 把它放到WebRequest 的属性中。这里可以说说这个setAttribute 方法的第三个参数scope ，该参数是一个Integer 类型的。在WebRequest 的父层接口RequestAttributes 中对它定义了三个常量：</p><p><br></p><p>SCOPE_REQUEST ：它的值是0 ，代表只有在request 中可以访问。</p><p><br></p><p>SCOPE_SESSION ：它的值是1 ，如果环境允许的话它代表的是一个局部的隔离的session，否则就代表普通的session，并且在该session范围内可以访问。</p><p><br></p><p>SCOPE_GLOBAL_SESSION ：它的值是2 ，如果环境允许的话，它代表的是一个全局共享的session，否则就代表普通的session，并且在该session 范围内可以访问。</p><p><br></p><p>（2 ）postHandle(WebRequest request, ModelMap model) 方法。该方法将在请求处理之后，也就是在Controller 方法调用之后被调用，但是会在视图返回被渲染之前被调用，所以可以在这个方法里面通过改变数据模型ModelMap 来改变数据的展示。该方法有两个参数，WebRequest 对象是用于传递整个请求数据的，比如在preHandle 中准备的数据都可以通过WebRequest 来传递和访问；ModelMap 就是Controller 处理之后返回的Model 对象，我们可以通过改变它的属性来改变返回的Model 模型。</p><p><br></p><p>（3 ）afterCompletion(WebRequest request, Exception ex) 方法。该方法会在整个请求处理完成，也就是在视图返回并被渲染之后执行。所以在该方法中可以进行资源的释放操作。而WebRequest 参数就可以把我们在preHandle 中准备的资源传递到这里进行释放。Exception 参数表示的是当前请求的异常对象，如果在Controller中抛出的异常已经被Spring 的异常处理器给处理了的话，那么这个异常对象就是是null 。</p><p><br></p><p>&nbsp;</p><p><br></p><p>下面是一个简单的代码说明：</p><p><br></p><p>import org.springframework.ui.ModelMap;</p><p>import org.springframework.web.context.request.WebRequest;</p><p>import org.springframework.web.context.request.WebRequestInterceptor;</p><p>public class AllInterceptor implements WebRequestInterceptor {</p><p>&nbsp; &nbsp; /**&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* 在请求处理之前执行，该方法主要是用于准备资源数据的，然后可以把它们当做请求属性放到WebRequest中&nbsp;</p><p>&nbsp; &nbsp; &nbsp;*/</p><p>&nbsp; &nbsp; @Override</p><p>&nbsp; &nbsp; public void preHandle(WebRequest request) throws Exception {</p><p>&nbsp; &nbsp; &nbsp; &nbsp; // TODO Auto-generated method stub&nbsp;&nbsp;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; System.out.println(\"AllInterceptor...............................\");</p><p>&nbsp; &nbsp; &nbsp; &nbsp; request.setAttribute(\"request\", \"request\", WebRequest.SCOPE_REQUEST);//这个是放到request范围内的，所以只能在当前请求中的request中获取到&nbsp;&nbsp;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; request.setAttribute(\"session\", \"session\", WebRequest.SCOPE_SESSION);//这个是放到session范围内的，如果环境允许的话它只能在局部的隔离的会话中访问，否则就是在普通的当前会话中可以访问&nbsp;&nbsp;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; request.setAttribute(\"globalSession\", \"globalSession\", WebRequest.SCOPE_GLOBAL_SESSION);//如果环境允许的话，它能在全局共享的会话中访问，否则就是在普通的当前会话中访问&nbsp;&nbsp;</p><p>&nbsp; &nbsp; }</p><p>&nbsp; &nbsp; /**&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* 该方法将在Controller执行之后，返回视图之前执行，ModelMap表示请求Controller处理之后返回的Model对象，所以可以在&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* 这个方法中修改ModelMap的属性，从而达到改变返回的模型的效果。&nbsp;</p><p>&nbsp; &nbsp; &nbsp;*/</p><p>&nbsp; &nbsp; @Override</p><p>&nbsp; &nbsp; public void postHandle(WebRequest request, ModelMap map) throws Exception {</p><p>&nbsp; &nbsp; &nbsp; &nbsp; // TODO Auto-generated method stub&nbsp;&nbsp;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; for (String key:map.keySet())</p><p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; System.out.println(key + \"-------------------------\");;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; map.put(\"name3\", \"value3\");</p><p>&nbsp; &nbsp; &nbsp; &nbsp; map.put(\"name1\", \"name1\");</p><p>&nbsp; &nbsp; }</p><p>&nbsp; &nbsp; /**&nbsp;</p><p>&nbsp; &nbsp; &nbsp;* 该方法将在整个请求完成之后，也就是说在视图渲染之后进行调用，主要用于进行一些资源的释放&nbsp;</p><p>&nbsp; &nbsp; &nbsp;*/</p><p>&nbsp; &nbsp; @Override</p><p>&nbsp; &nbsp; public void afterCompletion(WebRequest request, Exception exception)</p><p>&nbsp; &nbsp; throws Exception {</p><p>&nbsp; &nbsp; &nbsp; &nbsp; // TODO Auto-generated method stub&nbsp;&nbsp;</p><p>&nbsp; &nbsp; &nbsp; &nbsp; System.out.println(exception + \"-=-=--=--=-=-=-=-=-=-=-=-==-=--=-=-=-=\");</p><p>&nbsp; &nbsp; }</p><p>}</p><p><br></p><p>&nbsp;二、把定义的拦截器类加到SpringMVC的拦截体系中</p><p>1.在SpringMVC的配置文件中加上支持MVC的schema</p><p><br></p><p>xmlns:mvc=\"http://www.springframework.org/schema/mvc\"</p><p>xsi:schemaLocation=\" http://www.springframework.org/schema/mvc</p><p>&nbsp; &nbsp; http://www.springframework.org/schema/mvc/spring-mvc-3.0.xsd\"</p><p>下面是我的声明示例：</p><p><br></p><p><br></p><p><br></p><p>这样在SpringMVC的配置文件中就可以使用mvc标签了，mvc标签中有一个mvc:interceptors是用于声明SpringMVC的拦截器的。</p><p><br></p><p>&nbsp;</p><p><br></p><p>（二）使用mvc:interceptors标签来声明需要加入到SpringMVC拦截器链中的拦截器</p><p><br></p><p><br></p><p>&nbsp; &nbsp;&nbsp;</p><p>&nbsp; &nbsp;&nbsp;</p><p>&nbsp; &nbsp;&nbsp;</p><p>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</p><p>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</p><p>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</p><p>&nbsp; &nbsp;&nbsp;</p><p><br></p><p><br></p><p>由上面的示例可以看出可以利用mvc:interceptors标签声明一系列的拦截器，然后它们就可以形成一个拦截器链，拦截器的执行顺序是按声明的先后顺序执行的，先声明的拦截器中的preHandle方法会先执行，然而它的postHandle方法和afterCompletion方法却会后执行。</p><p><br></p><p>在mvc:interceptors标签下声明interceptor主要有两种方式：</p><p><br></p><p>（1）直接定义一个Interceptor实现类的bean对象。使用这种方式声明的Interceptor拦截器将会对所有的请求进行拦截。</p><p><br></p><p>（2）使用mvc:interceptor标签进行声明。使用这种方式进行声明的Interceptor可以通过mvc:mapping子标签来定义需要进行拦截的请求路径。</p><p><br></p><p>经过上述两步之后，定义的拦截器就会发生作用对特定的请求进行拦截了。</p><p><br></p><p><br></p><p><br></p>', 28, 0, 3, 1, 1, 1, '2022-01-02 20:51:52', '2022-01-02 23:54:18', NULL, '/img/thumbnail/random/img_1.jpg');
INSERT INTO `article` VALUES (2, 2, 'springmvc 表单中文乱码解决方案', '<p>基本上通过在 web.xml 了配置拦截器就可以解决。</p><p>这里需要注意的是，最好把这段代码放在web.xml中开头的位置，因为拦截有顺序，如果放在后面的话容易拦截不到。</p><p>拦截器代码如下</p><p></p><div><div class=\"dp-highlighter\"><div class=\"bar\"></div><ol start=\"1\" class=\"dp-xml\"><li class=\"alt\"><span><span class=\"comments\"><!--post乱码过滤器--></span><span>&nbsp;&nbsp;</span></span></li><li class=\"\"><span><span class=\"comments\"><!-- 配置springMVC编码过滤器 --></span><span>&nbsp;&nbsp;</span></span></li><li class=\"alt\"><span><span class=\"tag\">&lt;</span><span class=\"tag-name\">filter</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></li><li class=\"\"><span>&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"tag\">&lt;</span><span class=\"tag-name\">filter-name</span><span class=\"tag\">&gt;</span><span>CharacterEncodingFilter</span><span class=\"tag\"><!--</span--><span class=\"tag-name\">filter-name</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></span></li><li class=\"alt\"><span>&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"tag\">&lt;</span><span class=\"tag-name\">filter-class</span><span class=\"tag\">&gt;</span><span>org.springframework.web.filter.CharacterEncodingFilter</span><span class=\"tag\"><!--</span--><span class=\"tag-name\">filter-class</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></span></li><li class=\"\"><span>&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"comments\"><!-- 设置过滤器中的属性值 --></span><span>&nbsp;&nbsp;</span></span></li><li class=\"alt\"><span>&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"tag\">&lt;</span><span class=\"tag-name\">init-param</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></li><li class=\"\"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"tag\">&lt;</span><span class=\"tag-name\">param-name</span><span class=\"tag\">&gt;</span><span>encoding</span><span class=\"tag\"><!--</span--><span class=\"tag-name\">param-name</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></span></li><li class=\"alt\"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"tag\">&lt;</span><span class=\"tag-name\">param-value</span><span class=\"tag\">&gt;</span><span>UTF-8</span><span class=\"tag\"><!--</span--><span class=\"tag-name\">param-value</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></span></li><li class=\"\"><span>&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"tag\"><!--</span--><span class=\"tag-name\">init-param</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></span></li><li class=\"alt\"><span>&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"comments\"><!-- 启动过滤器 --></span><span>&nbsp;&nbsp;</span></span></li><li class=\"\"><span>&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"tag\">&lt;</span><span class=\"tag-name\">init-param</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></li><li class=\"alt\"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"tag\">&lt;</span><span class=\"tag-name\">param-name</span><span class=\"tag\">&gt;</span><span>forceEncoding</span><span class=\"tag\"><!--</span--><span class=\"tag-name\">param-name</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></span></li><li class=\"\"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"tag\">&lt;</span><span class=\"tag-name\">param-value</span><span class=\"tag\">&gt;</span><span>true</span><span class=\"tag\"><!--</span--><span class=\"tag-name\">param-value</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></span></li><li class=\"alt\"><span>&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"tag\"><!--</span--><span class=\"tag-name\">init-param</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></span></li><li class=\"\"><span><span class=\"tag\"><!--</span--><span class=\"tag-name\">filter</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></span></li><li class=\"alt\"><span><span class=\"comments\"><!-- 过滤所有请求 --></span><span>&nbsp;&nbsp;</span></span></li><li class=\"\"><span><span class=\"tag\">&lt;</span><span class=\"tag-name\">filter-mapping</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></li><li class=\"alt\"><span>&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"tag\">&lt;</span><span class=\"tag-name\">filter-name</span><span class=\"tag\">&gt;</span><span>CharacterEncodingFilter</span><span class=\"tag\"><!--</span--><span class=\"tag-name\">filter-name</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></span></li><li class=\"\"><span>&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"tag\">&lt;</span><span class=\"tag-name\">url-pattern</span><span class=\"tag\">&gt;</span><span>/*</span><span class=\"tag\"><!--</span--><span class=\"tag-name\">url-pattern</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></span></li><li class=\"alt\"><span><span class=\"tag\"><!--</span--><span class=\"tag-name\">filter-mapping</span><span class=\"tag\">&gt;</span><span>&nbsp;&nbsp;</span></span></span></li></ol></div></div><p><br></p><p>顺便再补充其他的几个可能原因。</p><p></p><p>1、数据库和数据表不是 utf-8 编码</p><p>就在前几天，我遇到的问题正是这个。当时是刚从 windows 搬到 mac。也是在提交 post 表单的时候，中文一直是乱码，后台百度发现，原来是 navicat 的原因。就是在新建 数据库连接(注意是连接)，不能选择 utf-8，应该选择默认的自动。这个地方很坑人。</p><p>数据库和数据表当然是 utf-8，一般这种情况很少出错。</p><p>&nbsp;</p><p>2、修改 Tomcat 的 server.xml 文件，添加 utf-8 编码</p><p></p><div><div class=\"dp-highlighter\"><div class=\"bar\"></div><ol start=\"1\" class=\"dp-j\"><li class=\"alt\"><span><span><connector port=< span=\"\"><span class=\"string\">\"8080\"</span><span>&nbsp;protocol=</span><span class=\"string\">\"HTTP/1.1\"</span><span>&nbsp;&nbsp;</span></connector port=<></span></span></li><li class=\"\"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;connectionTimeout=<span class=\"string\">\"20000\"</span><span>&nbsp;&nbsp;</span></span></li><li class=\"alt\"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;redirectPort=<span class=\"string\">\"8443\"</span><span>&nbsp;URIEncoding=</span><span class=\"string\">\"UTF-8\"</span><span>&nbsp;&nbsp;</span></span></li><li class=\"\"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;useBodyEncodingForURI=<span class=\"string\">\"true\"</span><span>&nbsp;/&gt;&nbsp;&nbsp;</span></span></li></ol></div></div><br><p></p><p>3、注意你的 IDE (如Eclipse,IntelliJ IDEA)的 jsp 文件编码，一般在右下角可以看出来，通常我们也要把默认的编码设置为 utf-8。</p><p>&nbsp;</p><p>4、还有一种方法就是 直接对接收到的数据编码转换，我感觉有点麻烦，所以不是很喜欢</p><p></p><div><div class=\"dp-highlighter\"><div class=\"bar\"></div><ol start=\"1\" class=\"dp-j\"><li class=\"alt\"><span><span>String&nbsp;name=</span><span class=\"keyword\">new</span><span>&nbsp;String((user.getUname()).getBytes(</span><span class=\"string\">\"ISO-8859-1\"</span><span>),</span><span class=\"string\">\"utf8\"</span><span>);&nbsp;&nbsp;</span></span></li></ol></div></div><p><span>总结：一般来说，第一种拦截器方法是可用的，要注意的是要把拦截器代码放到 web.xml 头部，防止拦截不到，还有表单一定要 post 方式提交。</span></p><p></p>', 17, 2, 1, 1, 1, 1, '2022-01-02 20:52:13', '2022-01-02 12:12:42', NULL, '/img/thumbnail/random/img_2.jpg');

-- ----------------------------
-- Table structure for article_category_ref
-- ----------------------------
DROP TABLE IF EXISTS `article_category_ref`;
CREATE TABLE `article_category_ref`  (
  `article_id` int(0) NOT NULL COMMENT '文章ID',
  `category_id` int(0) NOT NULL COMMENT '分类ID',
  PRIMARY KEY (`article_id`, `category_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_category_ref
-- ----------------------------
INSERT INTO `article_category_ref` VALUES (1, 1);
INSERT INTO `article_category_ref` VALUES (1, 2);
INSERT INTO `article_category_ref` VALUES (2, 1);
INSERT INTO `article_category_ref` VALUES (2, 9);

-- ----------------------------
-- Table structure for article_tag_ref
-- ----------------------------
DROP TABLE IF EXISTS `article_tag_ref`;
CREATE TABLE `article_tag_ref`  (
  `article_id` int(0) NOT NULL COMMENT '文章ID',
  `tag_id` int(0) NOT NULL COMMENT '标签ID',
  PRIMARY KEY (`article_id`, `tag_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_tag_ref
-- ----------------------------
INSERT INTO `article_tag_ref` VALUES (1, 1);
INSERT INTO `article_tag_ref` VALUES (1, 12);
INSERT INTO `article_tag_ref` VALUES (2, 2);

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `category_id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `category_pid` int(0) NULL DEFAULT NULL COMMENT '分类父ID',
  `category_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类名称',
  `category_description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `category_order` int(0) UNSIGNED NULL DEFAULT 1 COMMENT '排序值',
  `category_icon` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标',
  PRIMARY KEY (`category_id`) USING BTREE,
  UNIQUE INDEX `category_name`(`category_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100000009 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, 0, 'Java', 'Java语言', 1, 'fa fa-coffee');
INSERT INTO `category` VALUES (2, 1, 'Java框架', '', 1, '');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `comment_id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `comment_pid` int(0) UNSIGNED NULL DEFAULT 0 COMMENT '上级评论ID',
  `comment_pname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上级评论名称',
  `comment_article_id` int(0) UNSIGNED NOT NULL COMMENT '文章ID',
  `comment_author_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评论人名称',
  `comment_author_email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评论人邮箱',
  `comment_author_url` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评论人个人主页',
  `comment_author_avatar` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评论人头像',
  `comment_content` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '内容',
  `comment_agent` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '浏览器信息',
  `comment_ip` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'IP',
  `comment_create_time` datetime(0) NULL DEFAULT NULL COMMENT '评论时间',
  `comment_role` int(0) NULL DEFAULT NULL COMMENT '角色，是否管理员',
  `comment_user_id` int(0) NULL DEFAULT NULL COMMENT '评论ID,可能为空',
  PRIMARY KEY (`comment_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------

-- ----------------------------
-- Table structure for link
-- ----------------------------
DROP TABLE IF EXISTS `link`;
CREATE TABLE `link`  (
  `link_id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '链接ID',
  `link_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'URL',
  `link_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `link_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '头像',
  `link_description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `link_owner_nickname` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所属人名称',
  `link_owner_contact` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `link_update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `link_create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `link_order` int(0) UNSIGNED NULL DEFAULT 1 COMMENT '排序号',
  `link_status` int(0) UNSIGNED NULL DEFAULT 1 COMMENT '状态',
  PRIMARY KEY (`link_id`) USING BTREE,
  UNIQUE INDEX `link_name`(`link_name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of link
-- ----------------------------
INSERT INTO `link` VALUES (1, 'https://taigermos.github.io/', '柏青博客', NULL, '一个用来记录灵光的博客', NULL, '你好，我的WeChat是13794475011', '2017-10-07 16:51:03', '2017-10-07 16:29:35', 1, 1);
INSERT INTO `link` VALUES (4, 'https://github.com/TAIGERMOS', 'GitHub主页', NULL, NULL, NULL, NULL, '2021-03-19 18:02:31', '2021-03-19 18:02:31', 1, 1);

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu`  (
  `menu_id` int(0) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '名称',
  `menu_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'URL',
  `menu_level` int(0) NULL DEFAULT NULL COMMENT '等级',
  `menu_icon` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标',
  `menu_order` int(0) NULL DEFAULT NULL COMMENT '排序值',
  PRIMARY KEY (`menu_id`) USING BTREE,
  UNIQUE INDEX `menu_name`(`menu_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES (4, '文章归档', '/articleFile', 1, 'fa-list-alt fa', 2);

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `notice_id` int(0) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公告标题',
  `notice_content` varchar(10000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '内容',
  `notice_create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `notice_update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `notice_status` int(0) UNSIGNED NULL DEFAULT 1 COMMENT '状态',
  `notice_order` int(0) NULL DEFAULT NULL COMMENT '排序值',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notice
-- ----------------------------

-- ----------------------------
-- Table structure for options
-- ----------------------------
DROP TABLE IF EXISTS `options`;
CREATE TABLE `options`  (
  `option_id` int(0) NOT NULL,
  `option_site_title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `option_site_descrption` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `option_meta_descrption` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `option_meta_keyword` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `option_aboutsite_avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `option_aboutsite_title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `option_aboutsite_content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `option_aboutsite_wechat` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `option_aboutsite_qq` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `option_aboutsite_github` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `option_aboutsite_weibo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `option_tongji` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `option_status` int(0) NULL DEFAULT 1,
  PRIMARY KEY (`option_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of options
-- ----------------------------
INSERT INTO `options` VALUES (1, 'Aron\'s Blog', '不保证成功，不一定有用，知识只是点亮世界的灵光', '一个SSM框架搭建的博客。', 'Aaron’s Blog,Java博客,SSM博客', '/img/logo.png', 'Aaron', '不保证成功，不一定有用，知识只是点亮世界的灵光', '/uploads/2022\\2/weixin.jpg', '904373097', 'TAIGERMOS', '13794475011', NULL, 1);

-- ----------------------------
-- Table structure for page
-- ----------------------------
DROP TABLE IF EXISTS `page`;
CREATE TABLE `page`  (
  `page_id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自定义页面ID',
  `page_key` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'key',
  `page_title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标题',
  `page_content` mediumtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '内容',
  `page_create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `page_update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `page_view_count` int(0) UNSIGNED NULL DEFAULT 0 COMMENT '访问量',
  `page_comment_count` int(0) UNSIGNED NULL DEFAULT 0 COMMENT '评论数',
  `page_status` int(0) UNSIGNED NULL DEFAULT 1 COMMENT '状态',
  PRIMARY KEY (`page_id`) USING BTREE,
  UNIQUE INDEX `page_key`(`page_key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of page
-- ----------------------------
INSERT INTO `page` VALUES (1, 'map', '站点地图', NULL, NULL, NULL, 0, 0, 2);
INSERT INTO `page` VALUES (2, 'articleFile', '文章归档', NULL, NULL, NULL, 0, 0, 2);
INSERT INTO `page` VALUES (3, 'message', '留言板', NULL, NULL, NULL, 0, 0, 2);
INSERT INTO `page` VALUES (4, 'applyLink', '申请友链', NULL, NULL, NULL, 0, 0, 2);
INSERT INTO `page` VALUES (5, 'aboutSite', '关于本站', '该博客是基于SSM实现的个人博客系统,支持用户注册，包含用户和管理员两个角色。主要涉及的包括 JSP，JSTL，EL表达式，MySQL，Druid连接池，Spring，SpringMVC，MyBatis 等，通过Maven管理依赖。', '2017-10-06 23:40:35', '2017-10-10 14:58:12', NULL, NULL, 1);
INSERT INTO `page` VALUES (7, 'hello', '11', '11111111', '2018-12-21 21:46:50', '2018-12-21 21:46:50', NULL, NULL, 1);

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag`  (
  `tag_id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `tag_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签名称',
  `tag_description` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`tag_id`) USING BTREE,
  UNIQUE INDEX `tag_name`(`tag_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tag
-- ----------------------------
INSERT INTO `tag` VALUES (1, 'Java', 'Java');
INSERT INTO `tag` VALUES (12, 'SpringMVC', '');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `user_id` int(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '用户名',
  `user_pass` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '密码',
  `user_nickname` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '昵称',
  `user_email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '邮箱',
  `user_url` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '个人主页',
  `user_avatar` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '头像',
  `user_last_login_ip` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上传登录IP',
  `user_register_time` datetime(0) NULL DEFAULT NULL COMMENT '注册时间',
  `user_last_login_time` datetime(0) NULL DEFAULT NULL COMMENT '上传登录时间',
  `user_status` int(0) UNSIGNED NULL DEFAULT 1 COMMENT '状态',
  `user_role` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'user' COMMENT '角色',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `user_name`(`user_name`) USING BTREE,
  UNIQUE INDEX `user_email`(`user_email`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '123456', 'Aaron', '904373097@qq.com', '', '/img/avatar/avatar1.jpg', '0:0:0:0:0:0:0:1', '2022-01-01 21:56:33', '2022-02-23 07:59:54', 1, 'admin');
INSERT INTO `user` VALUES (5, 'wangwu', '123456', '王五', 'wangwu@qq.com', NULL, '/img/avatar/avatar.png', '0:0:0:0:0:0:0:1', '2021-02-10 09:13:57', '2022-02-02 15:19:02', 1, 'user');
INSERT INTO `user` VALUES (2, 'zhangsan', '123456', '张三', 'zhangsan@china.com', '', '/img/avatar/avatar2.jpeg', '0:0:0:0:0:0:0:1', '2018-11-25 14:45:08', '2021-02-25 10:19:30', 1, 'user');
INSERT INTO `user` VALUES (3, 'youke', '123456', '游客', 'youke@aa.com', '', '/img/avatar/avatar3.jpeg', '0:0:0:0:0:0:0:1', '2018-11-25 14:45:08', '2020-04-18 21:41:06', 1, 'user');
INSERT INTO `user` VALUES (4, 'lisi', '123456', '李四', 'lisi@qq.com', '', '/img/avatar/avatar.png', NULL, '2021-02-25 09:11:42', NULL, 1, 'user');

SET FOREIGN_KEY_CHECKS = 1;
