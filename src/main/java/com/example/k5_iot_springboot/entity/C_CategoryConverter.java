package com.example.k5_iot_springboot.entity;

// Enum DB 행위 동작 처리 

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = false) // 코드흐름으로 전환 (자동X)
public class C_CategoryConverter implements AttributeConverter<C_Category, String> {

    // C_Category dbValue 문자열 적용
    @Override
    public String convertToDatabaseColumn(C_Category cCategory) {
        return cCategory == null ? null : cCategory.getDbValue();
    }

    // C_Category 적용
    @Override
    public C_Category convertToEntityAttribute(String s) {
        return C_Category.fromDbValue(s);
    }
}
