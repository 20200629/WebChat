package websocket;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

/**
 * WebScoket配置处理器 2018/6/4
 */
@Component
@EnableWebSocket
public class WebSocketConfig extends WebMvcConfigurerAdapter implements WebSocketConfigurer {

	@Resource
	MyWebSocketHandler handler;

	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		//addHandler注册和路由的功能，当客户端发起websocket连接，把/path交给对应的handler处理，而不实现具体的业务逻辑可以理解为收集任务和任务分发中心。
		//addInterceptors，顾名思义就是为handler添加拦截器，可以在调用handler前后加入自定义的逻辑代码。
		registry.addHandler(handler, "/ws").addInterceptors(new HandShake());

		//允许客户端使用SockJs
		//SockJS 是一个浏览器上运行的 JavaScript 库，如果浏览器不支持 WebSocket，该库可以模拟对 WebSocket 的支持。
		registry.addHandler(handler, "/ws/sockjs").addInterceptors(new HandShake()).withSockJS();
	}

}
