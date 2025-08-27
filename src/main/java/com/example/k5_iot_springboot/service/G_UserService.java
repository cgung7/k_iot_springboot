package com.example.k5_iot_springboot.service;

import com.example.k5_iot_springboot.dto.G_User.request.UserProfileUpdateRequest;
import com.example.k5_iot_springboot.dto.G_User.response.UserProfileResponse;
import com.example.k5_iot_springboot.dto.ResponseDto;
import com.example.k5_iot_springboot.security.UserPrincipal;
import jakarta.validation.Valid;

public interface G_UserService {
    ResponseDto<UserProfileResponse.MyRageResponse> getMyInfo(UserPrincipal principal);

    ResponseDto<UserProfileResponse.MyRageResponse> updatedMyInfo(UserPrincipal principal, @Valid UserProfileUpdateRequest request);
}
