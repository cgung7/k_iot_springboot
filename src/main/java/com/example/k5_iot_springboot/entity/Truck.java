package com.example.k5_iot_springboot.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "trucks")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Setter
public class Truck {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 트럭을 운영하는 사용자 ID
    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "owner_id", nullable = false,
            foreignKey = @ForeignKey(name = "fk_trucks_user")
    )
    private G_User user;

    @Column(nullable = false, length = 100)
    private String name; // 트럭 이름

    @Column(length = 50)
    private String category; // 트럭 내 메뉴(커피, 디저트 등)

    @Column(length = 50)
    private String region;

    @Column(length = 255)
    private String description;

    // == 예약 리스트 == //
    @OneToMany(mappedBy = "truck", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Reservation> reservations = new ArrayList<>();

    public void addReservation(Reservation reservation) {
        reservations.add(reservation);
        reservation.setTruck(this);
    }


}
