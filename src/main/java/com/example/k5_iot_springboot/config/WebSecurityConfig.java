package com.example.k5_iot_springboot.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;

/*
    === WebSecurityConfig ===
    " Spring Security를 통해 웹 애플리케이션의 보안을 구성 (보안 환경설정)
    - JWT 필터를 적용하여 인증 처리, CORS 및 CSRF 설정을 비활성화
    >> 서버 간의 통신을 원활하게 처리

 */
@Configuration // 해당 클래스가 Spring의 설정 클래스로 사용됨을 명시
@EnableWebSecurity // Spring Security의 웹 보안 활성화
public class WebSecurityConfig {















}
