package com.vn.ManageHotel.utils;

import java.util.ArrayList;
import java.util.List;

public class PaginationUtils {

    public static List<Integer> getPagination(int totalPages, int currentPage, int maxPagesToShow) {
        List<Integer> pages = new ArrayList<>();
        int startPage = Math.max(1, currentPage - maxPagesToShow / 2);
        int endPage = Math.min(totalPages, currentPage + maxPagesToShow / 2);

        // Adjust if near the beginning or end
        if (endPage - startPage + 1 < maxPagesToShow) {
            if (startPage == 1) {
                endPage = Math.min(totalPages, startPage + maxPagesToShow - 1);
            } else {
                startPage = Math.max(1, endPage - maxPagesToShow + 1);
            }
        }

        for (int i = startPage; i <= endPage; i++) {
            pages.add(i);
        }

        return pages;
    }
}
