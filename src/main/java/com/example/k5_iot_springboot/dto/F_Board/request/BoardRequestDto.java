package com.example.k5_iot_springboot.dto.F_Board.request;

/*
    게시글 요청 DTO
    - Controller 바인딩용

 */

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class BoardRequestDto {

    // 게시글 생성 요청
    public record CreatedRequest(
            @NotBlank(message = "제목은 비어있을 수 없습니다.")
            @Size(max = 100, message = "제목은 최대 100자까지 가능합니다.")
            String title,

            @NotBlank(message = "내용은 비어있을 수 없습니다.")
            String content

    ) {}

    // 게시글 수정 요청
    public record UpdateRequest(
            @NotBlank(message = "제목은 비어있을 수 없습니다.")
            @Size(max = 100, message = "제목은 최대 100자까지 가능합니다.")
            String title,

            @NotBlank(message = "내용은 비어있을 수 없습니다.")
            String content

    ) {}

}
