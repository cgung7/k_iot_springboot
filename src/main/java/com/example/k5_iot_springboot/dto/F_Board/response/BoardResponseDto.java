package com.example.k5_iot_springboot.dto.F_Board.response;

/*
    게시글 응답 DTO 모음
    - 프론트 사용성을 높이기 위해 KST 문자열과 UTC ISO 문자열을 함께 제공
 */

import com.example.k5_iot_springboot.common.utils.DateUtils;
import com.example.k5_iot_springboot.entity.F_Board;
import lombok.Builder;
import org.springframework.context.annotation.Bean;
import org.springframework.data.domain.Page;

import java.util.List;

public class BoardResponseDto {

    // 게시글 상세 응답
    public record DetailResponse(
            Long id,
            String title,
            String content,
            String createdAtKst,
            String updatedAtKst,
            String createdUtcIso,
            String updatedUtcKst

    ) {
        public static DetailResponse from(F_Board board) {
            return new DetailResponse(
                    board.getId(),
                    board.getTitle(),
                    board.getContent(),
                    DateUtils.toKstString(board.getCreateAt()),
                    DateUtils.toKstString(board.getUpdatedAt()),
                    DateUtils.toUtcString(board.getCreateAt()),
                    DateUtils.toUtcString(board.getUpdatedAt())

            );
        }

    }

    // 게시글 목록/요약 응답
    // - 목록 API에서 가벼운 페러오드가 필요할 때 사용
    // cf) 페이로드: 전송되는 데이터 중 실질적인 정보
    public record SummeryResponse(
            Long id,
            String title,
            String createdAtKst,
            String createdUtcIso


    ) {

        public static SummeryResponse from(F_Board board) {
            return new SummeryResponse(
                    board.getId(),
                    board.getTitle(),
                    DateUtils.toKstString(board.getCreateAt()),
                    DateUtils.toUtcString(board.getCreateAt())


            );
        }

    }

    // === 페이지 정보 메타 === //
    @Builder
    public record PageMeta(
            int page,                       // 현재 페이지(0-based)
            int size,                       // 페이지 크기
            long totalElements,             // 전체 개수
            int totalPages,                 // 전체 페이지 수
            boolean hasNext,
            boolean hasPrevious,
            String sort                     // 정렬 정보(문자열화)
    ){
        public static PageMeta from(Page<?> p) {
            String sort = p.getSort().toString(); // ex) createdAt: DESC
            return PageMeta.builder()
                    .page(p.getNumber())
                    .size(p.getSize())
                    .totalElements(p.getTotalElements())
                    .totalPages(p.getTotalPages())
                    .hasNext(p.hasNext())
                    .hasPrevious(p.hasPrevious())
                    .sort(sort)
                    .build();
        }
    }

    // === OffSet 기반 응답 === //
    @Builder
    public record PageResponse(
            List<SummeryResponse> content,
            PageMeta meta
    ) {}

    // === Cursor 기반 응답 === //
    @Builder
    public record SliceResponse(
            List<SummeryResponse> content,
            boolean hasNext,
            Long nextCursor // 다음 호출 시 사용할 cursorId(마지막 아이템의 id 등)
    ) {}


}
