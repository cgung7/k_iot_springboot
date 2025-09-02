package com.example.k5_iot_springboot.entity.view;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Immutable;

import java.time.LocalDateTime;

@Entity
@Table(name = "order_totals")
@Getter
@NoArgsConstructor
@Immutable // import org.hibernate.annotations.Immutable;
public class OrderTotalsView {
    @Id @Column(name = "order_id")
    private Long orderId;

    // 뷰 컬럼명 그대로 사용(DB 작성)
    private Long user_id;
    private String order_status;
    private Integer order_total_amount;
    private Long order_total_qty;

    @Column(name = "ordered_at")
    private LocalDateTime orderedAt;


}
