package com.example.k5_iot_springboot.dto.G_Admin.response;

import com.example.k5_iot_springboot.common.enums.RoleType;

import java.time.LocalDateTime;
import java.util.Set;

public final class RoleManageResponse {
    public record UpdateRolesResponse(
            Long userId,
            String loginId,
            Set<RoleType> roles,
            LocalDateTime updatedAt

    ) {}

    public record AddRolesResponse(
            Long userId,
            String loginId,
            RoleType added,
            Set<RoleType> roles,
            LocalDateTime updatedAt

    ) {}

    public record RemoveRolesResponse(
            Long userId,
            String loginId,
            RoleType removed,
            Set<RoleType> roles,
            LocalDateTime updatedAt

    ) {}


    }

