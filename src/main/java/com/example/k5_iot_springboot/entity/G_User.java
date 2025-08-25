package com.example.k5_iot_springboot.entity;


import com.example.k5_iot_springboot.common.enums.Gender;
import com.example.k5_iot_springboot.entity.base.BaseTimeEntity;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "users")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)

public class G_User extends BaseTimeEntity {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", updatable = false)
    private Long id;

    @Column(name = "login_id", unique = true, updatable = false, nullable = false, length = 50)
    private String loginId;

    @Column(name = "password", nullable = false, length = 255) // 암호화로 255설정
    private String password;

    @Column(name = "email", nullable = false, length = 255) //
    private String email;

    @Column(name = "nickname", nullable = false, length = 50)
    private String nickname;

    @Column(name = "gender", length = 20)
    @Enumerated(EnumType.STRING)
    private Gender gender;

    @Builder
    private G_User (String loginId, String password, String email, String nickname, Gender gender) {
        this.loginId = loginId;
        this.password = password;
        this.email = email;
        this.nickname = nickname;
        this.gender = gender;
    }
    public void changePassword(String password) {
        this.password = password;
    }


    public void changeProfile(String nickname, Gender gender) {
        this.nickname = nickname;
        this.gender = gender;
    }
}
