### k5_iot_springboot >>> query ###

# 1. 스키마 생상 (이미 존재하면 삭제)
DROP DATABASE IF EXISTS k5_iot_springboot;

# 2. 스키마 생성 + 문자셋/정렬 설정
CREATE DATABASE IF NOT EXISTS k5_iot_springboot
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_general_ci;
    
# 3. 스키마 선택
USE k5_iot_springboot;

# 0811 (A_Test)
CREATE TABLE IF NOT EXISTS test(
	test_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
    
);
SELECT * FROM test;

# 0812 (B_Student)
CREATE TABLE IF NOT EXISTS students (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
	UNIQUE KEY uq_name_email (name, email)
    # : name + email 조합이 유일하도록 설정
);
SELECT * FROM students;

# 0813 (C_Book)
CREATE TABLE IF NOT EXISTS books(
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    writer VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    content VARCHAR(500) NOT NULL,
    category VARCHAR(20) NOT NULL,
    # 자바 enum 데이터 처리
    # : DB에서는 VARCHAR(문자열)로 관리 + CHECK 제약 조건으로 문자 제한
    CONSTRAINT chk_book_category CHECK (category IN ('NOVEL', 'ESSAY', 'POEM', 'MAGAZINE')),
    # 같은 저자 + 동일 제목 중복 저장 방지
    CONSTRAINT uk_book_writer_title UNIQUE (writer, title)
);
SELECT * FROM  books;

# 0819 (D_Post, D_Comment)
-- 게시글 테이블
CREATE TABLE IF NOT EXISTS `posts` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(200) NOT NULL COMMENT '게시글 제목',
    `content` LONGTEXT NOT NULL COMMENT '게시글 내용', -- @Lob 매핑 대응
    `author` VARCHAR(100) NOT NULL COMMENT '작성자 표시명 또는 ID',
    PRIMARY KEY (`id`),
    KEY `idx_post_author` (`author`)
) ENGINE=InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = '게시글';

-- 댓글 테이블
CREATE TABLE IF NOT EXISTS `comments` (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
    `post_id` BIGINT NOT NULL COMMENT 'post.id FK',
    `content` VARCHAR(1000) NOT NULL COMMENT '댓글 내용',
    `commenter` VARCHAR(100) NOT NULL COMMENT '댓글 작성자 표시명 또는 ID',
    PRIMARY KEY (`id`),
    KEY `idx_comment_post_id` (`post_id`),
    KEY `idx_comment_commenter` (`commenter`),
	CONSTRAINT `fk_comment_post`
		FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) 
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = '댓글';

SELECT * FROM `posts`;
SELECT * FROM `comments`;

# 0821 (F_Board)
-- 게시판 테이블(생성/수정 시간 포함)
CREATE TABLE IF NOT EXISTS `boards` (
	id BIGINT AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    content LONGTEXT NOT NULL,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (`id`)

)ENGINE=InnoDB
 DEFAULT CHARSET = utf8mb4
 COLLATE = utf8mb4_unicode_ci
 COMMENT = '게시글';
 
 SELECT * FROM `boards`;
 
 USE k5_iot_springboot;

CREATE TABLE IF NOT EXISTS `users` (
	id BIGINT NOT NULL AUTO_INCREMENT,
    login_id VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT `uk_users_login_id` UNIQUE (login_id),
    CONSTRAINT `uk_users_email` UNIQUE (email),
    CONSTRAINT `uk_users_nickname` UNIQUE (nickname),
    CONSTRAINT `uk_users_gender` CHECK (gender IN ('MALE', 'FEMALE'))

) ENGINE=InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '사용자';

CREATE TABLE IF NOT EXISTS (
id BIGINT NOT NULL AUTO_INCREMENT,
    login_id VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT `uk_users_login_id` UNIQUE (login_id),
    CONSTRAINT `uk_users_email` UNIQUE (email),
    CONSTRAINT `uk_users_nickname` UNIQUE (nickname),
    CONSTRAINT `uk_users_gender` CHECK (gender IN ('MALE', 'FEMALE'))

) ENGINE=InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '사용자';

SELECT * FROM users;
drop table `users`;


CREATE TABLE IF NOT EXISTS `users` (
	id BIGINT NOT NULL AUTO_INCREMENT,
    login_id VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT `uk_users_login_id` UNIQUE (login_id),
    CONSTRAINT `uk_users_email` UNIQUE (email),
    CONSTRAINT `uk_users_nickname` UNIQUE (nickname),
    CONSTRAINT `uk_users_gender` CHECK (gender IN ('MALE', 'FEMALE'))

) ENGINE=InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '사용자';


# 0827 (G_User_role)
-- 사용자 권한 테이블
CREATE TABLE IF NOT EXISTS `user_roles` (
	user_id BIGINT NOT NULL,
    role VARCHAR(30) NOT NULL,

    CONSTRAINT fk_user_roles_user
		FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
	CONSTRAINT uk_user_roles UNIQUE (user_id, role),
    
    CONSTRAINT chk_user_roles_role CHECK (role IN ('USER', 'MANAGER', 'ADMIN'))
) ENGINE=InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '사용자 권한';

SELECT * FROM `user_roles`;

# 샘플데이터 #
INSERT INTO user_roles (user_id, role)
VALUES (1, "ADMIN");



# 0828 (H_Article)
-- 기사 테이블
CREATE TABLE IF NOT EXISTS `articles` (
id BIGINT NOT NULL AUTO_INCREMENT,
title VARCHAR(200) NOT NULL,
content LONGTEXT NOT NULL,
author_id BIGINT NOT NULL,
created_at DATETIME(6) NOT NULL,
updated_at DATETIME(6) NOT NULL,
PRIMARY KEY (id),
CONSTRAINT fk_articles_author
	FOREIGN KEY (author_id)
    REFERENCES users(id)
    ON DELETE CASCADE
    

) ENGINE=InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '기사글';
  
  SELECT * FROM articles;
SELECT * FROM users;
DROP TABLE articles;
DROP TABLE user_roles;
DROP TABLE users;

USE k5_iot_springboot;

-- 0901 (주문 관리 시스템)
-- 트랜잭션, 트리거, 인덱스, 뷰 학습
# products(상품), stocks(재고), orders(주문 정보), order_items(주문 상세 정보)
# , order_logs(주문 기록 정보)

-- 안전 실행: 삭제 순서
# cf) SET FOREIGN_KEY_CHECKS: 외래 키 제약 조건을 활성화(1)하거나 비활성화(0)하는 명령어
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS order_logs;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS stocks;
DROP TABLE IF EXISTS products;
SET FOREIGN_KEY_CHECKS = 1;

-- 상품 정보 테이블 --
CREATE TABLE IF NOT EXISTS `products` (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price INT NOT NULL,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    CONSTRAINT uq_products_name UNIQUE (name),
    INDEX idx_products_name (name)		# 제품명으로 제품 조회 시 성능 향상
) ENGINE=InnoDB							# MYSQL에서 테이블이 데이터를 저장하고 관리하는 방식을 지정하는 명령어
  DEFAULT CHARSET = utf8mb4				# DB나 테이블의 기본 문자 집합 (4바이트까지 지원 - 이모지 포함)👍
  COLLATE = utf8mb4_unicode_ci			# 정렬 순서 지정 (대소문자 구분 없이 문자열 비교 정렬)
  COMMENT = '상품정보';
  
  # cf) ENGINE=InnoDB: 트랜잭션 지원(ACID), 외래 키 제약조건 지원(참조 무결성 보장)
  
  
  # 재고 정보 테이블
  CREATE TABLE IF NOT EXISTS `stocks` (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    CONSTRAINT fk_stocks_product
		FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE, # FOREIGN KEY
        CONSTRAINT chk_stocks_qty CHECK (quantity >= 0),					# CHECK 제약 조건
        INDEX idx_stocks_product_id (product_id)							# INDEX 제약 조건
  ) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci
    COMMENT = '상품 재고 정보';
    
 # 주문 정보 테이블
  CREATE TABLE IF NOT EXISTS `orders` (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    order_status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL, 
    CONSTRAINT fk_orders_user
		FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
	CONSTRAINT chk_orders_os CHECK (order_status IN ('PENDING', 'APPROVED', 'CANCELLED')),
	INDEX idx_orders_user (user_id),
    INDEX idx_orders_status (order_status),
    INDEX idx_orders_created_at (created_at)
  ) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci
    COMMENT = '주문 정보';
    
  # 주문 상세 정보 테이블  
  CREATE TABLE IF NOT EXISTS `order_items` (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,				# 주문 정보
    product_id BIGINT NOT NULL,				# 제품 정보 - 정규화 사례
    quantity INT NOT NULL,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL, 
    CONSTRAINT fk_order_items_order
		FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
	CONSTRAINT fk_order_items_porduct
		FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
	CONSTRAINT chk_order_items_aty CHECK (quantity > 0),
    INDEX idx_order_items_order (order_id),
    INDEX idx_order_items_product (product_id),
    UNIQUE KEY uq_order_product (order_id, product_id) # 주문과 제품 중복 불가
  ) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci
    COMMENT = '주문 상세 정보';
    
  # 주문 기록 정보 테이블  
  CREATE TABLE IF NOT EXISTS `order_logs` (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    message VARCHAR(255),
    -- 트리거가 직접 INSERT 하는 로그 테이블은 시간 누락 방지를 위해 DB 기본값 유지
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), 
    CONSTRAINT fk_order_logs_order
		FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
	INDEX idx_order_logs_order (order_id),
    INDEX idx_order_logs_created_at (created_at)
  ) ENGINE = InnoDB
    DEFAULT CHARSET = utf8mb4
    COLLATE = utf8mb4_unicode_ci
    COMMENT = '주문 기록 정보';
    
    ### 초기 데이터 설정 ###
    INSERT INTO products (name, price, created_at, updated_at)
    VALUES
		('겔럭시 Z플립 7', 50000, NOW(6), NOW(6)),
		('아이폰 16', 60000, NOW(6), NOW(6)),
		('겔럭시 S25 울트라', 55000, NOW(6), NOW(6)),
		('맥북 프로 14', 80000, NOW(6), NOW(6));
        
	INSERT INTO stocks (product_id, quantity, created_at, updated_at)
    VALUES
		(1, 50, NOW(6), NOW(6)),
		(2, 30, NOW(6), NOW(6)),
		(3, 70, NOW(6), NOW(6)),
		(4, 20, NOW(6), NOW(6));
  ### 0902
  -- 뷰 (행 단위)
  -- : 주문 상세 화면 (API) - 한 주문의 각 상품 라인 아이템 정보를 상세 하게 제공할 때
  -- : 예) GET / api/v1/orders/{orderId}/items
  CREATE OR REPLACE VIEW order_summary AS 
  SELECT
	o.id 							AS order_id,
    o.user_id 						AS user_id,
    o.order_status 					AS order_status,
    p.name 							AS product_name,
    oi.quantity 					AS quantity,
    p.price 						AS price,
    CAST((oi.quantity * p.price) 	AS SIGNED) AS total_price, -- BIGINT로 고정
    o.created_at					AS ordered_at
  FROM
	orders o
    JOIN order_items oi ON o.id = oi.order_id
    JOIN products p ON oi.product_id = p.id;

  -- 뷰 (주문 합계)
CREATE OR REPLACE VIEW order_totals AS
SELECT
	o.id 								AS order_id,
    o.user_id 							AS user_id,
    o.order_status 						AS order_status,
    CAST(SUM(oi.quantity * p.price) 	AS SIGNED) AS order_total_amount,
	CAST(SUM(oi.quantity) 				AS SIGNED) AS order_total_qty,
    MIN(o.created_at) 					AS ordered_at

FROM
	orders o
    JOIN order_items oi ON o.id = oi.order_id
    JOIN products p ON oi.product_id = p.id
GROUP BY
	o.id, o.user_id, o.order_status; -- 주문 '별' 합계: 주문(orders) 정보를 기준으로 그룹화
    
-- 트리거: 주문 생성 시 로그
# 고객 문의/장애 분석 시 "언제 주문 레코드가 생겼는지" 원인 추적에 사용
DELIMITER //
CREATE TRIGGER trg_after_order_insert
	AFTER INSERT ON orders
    FOR EACH ROW
    BEGIN
		INSERT INTO order_logs(order_id, message)
        VALUES (NEW.id, CONCAT('주문이 생성되었습니다. 주문 ID: ', NEW.id));
	END //
DELIMITER ;

-- 트리거: 주문 상태 변경 시 로그
# 상태 전이 추적 시 "누가 언제 어떤 상태로 바꿨는지" 원인 추적에 사용
DELIMITER //
CREATE TRIGGER trg_after_order_status_update
	AFTER UPDATE ON orders
    FOR EACH ROW
    BEGIN
		IF NEW.order_status <> OLD.order_status THEN -- A <> B 는 A != B와 같은 의미 (같지 않다)
			INSERT INTO order_logs(order_id, message)
            VALUES (NEW.id, CONCAT('주문 상태가 ', OLD.order_status
					, ' -> ' , '로 변경되었습니다.'));
		END IF;
	END //
    DELIMITER ;
  drop table products;
  drop table stocks;
  drop table order_items;
    SELECT * FROM `products`;
    SELECT * FROM `stocks`;
    SELECT * FROM `orders`;
    SELECT * FROM `order_items`;
    SELECT * FROM `order_logs`;

USE k5_iot_springboot;





































