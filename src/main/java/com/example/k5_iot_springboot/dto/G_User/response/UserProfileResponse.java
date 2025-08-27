package com.example.k5_iot_springboot.dto.G_User.response;

import com.example.k5_iot_springboot.common.enums.Gender;

public final class UserProfileResponse {
    public record MyRageResponse(
            Long id,
            String loginId,
            String email,
            String nickname,
            Gender gender
    ) {}
}
