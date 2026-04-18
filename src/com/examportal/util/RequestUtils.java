package com.examportal.util;

public final class RequestUtils {

    private RequestUtils() {
    }

    public static String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    public static Integer parsePositiveInt(String value) {
        Integer parsedValue = parseInt(value);
        if (parsedValue == null || parsedValue <= 0) {
            return null;
        }
        return parsedValue;
    }

    public static Integer parseInt(String value) {
        String trimmed = trimToNull(value);
        if (trimmed == null) {
            return null;
        }
        try {
            return Integer.valueOf(trimmed);
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
