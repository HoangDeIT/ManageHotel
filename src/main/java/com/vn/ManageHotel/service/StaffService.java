package com.vn.ManageHotel.service;

import com.vn.ManageHotel.domain.Staff;
import com.vn.ManageHotel.repository.StaffRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class StaffService {

    @Autowired
    private StaffRepository staffRepository;

    @Transactional
    public List<Staff> getPaginatedStaff(String searchTerm, int pageNum, int pageSize) {
        return staffRepository.getPaginatedNhanVien(searchTerm, pageNum, pageSize);
    }

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

    @Transactional
    public int getTotalPages(String searchTerm, int pageSize) {

        return staffRepository.getTotalPages(searchTerm, pageSize);
    }
}