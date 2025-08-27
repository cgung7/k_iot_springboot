package com.example.k5_iot_springboot.service.impl;

import com.example.k5_iot_springboot.dto.G_User.request.UserProfileUpdateRequest;
import com.example.k5_iot_springboot.dto.G_User.response.UserProfileResponse;
import com.example.k5_iot_springboot.dto.ResponseDto;
import com.example.k5_iot_springboot.entity.G_User;
import com.example.k5_iot_springboot.repository.G_UserRepository;
import com.example.k5_iot_springboot.security.UserPrincipal;
import com.example.k5_iot_springboot.security.util.PrincipalUtils;
import com.example.k5_iot_springboot.service.G_UserService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class G_UserServiceImpl implements G_UserService {
    private final G_UserRepository userRepository;

    @Override
    public ResponseDto<UserProfileResponse.MyRageResponse> getMyInfo(UserPrincipal principal) {
        PrincipalUtils.requiredActive(principal);


        G_User user = userRepository.findByLoginId(principal.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("해당 username의 사용자가 없습니다." + principal.getUsername()));

               UserProfileResponse.MyRageResponse data = new UserProfileResponse.MyRageResponse(
                       user.getId(),
                       user.getLoginId(),
                       user.getEmail(),
                       user.getNickname(),
                       user.getGender()
        );
        return ResponseDto.setSuccess("SUCCESS",data);
    }
    @Override
    @Transactional
    public ResponseDto<UserProfileResponse.MyRageResponse> updatedMyInfo(
            UserPrincipal principal, UserProfileUpdateRequest request
    ) throws AccessDeniedException {
        PrincipalUtils.requiredActive(principal);

        G_User user = userRepository.findByLoginId(principal.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("해당 username의 사용자가 없습니다." + principal.getUsername()));

        user.changeProfile(request.nickname(),request.gender());
        userRepository.flush();

        UserProfileResponse.MyRageResponse data = new UserProfileResponse.MyRageResponse(
                user.getId(),
                user.getLoginId(),
                user.getEmail(),
                user.getNickname(),
                user.getGender()
        );

        return ResponseDto.setSuccess("SUCCESS",data);
    }
}
