package com.vn.ManageHotel.service;

import com.vn.ManageHotel.domain.Staff;
import com.vn.ManageHotel.repository.StaffRepository;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StaffService {

    private final StaffRepository staffRepository;

    public StaffService(StaffRepository staffRepository) {
        this.staffRepository = staffRepository;
    }

    @Transactional
    public List<Staff> getPaginatedStaff(String searchTerm, int pageNum, int pageSize) {
        return staffRepository.getPaginatedStaff(searchTerm, pageNum, pageSize);
    }

    @Transactional
    public int getTotalPages(String searchTerm, int pageSize) {
        return staffRepository.getTotalPages(searchTerm, pageSize);
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

    public Staff saveStaff(Staff staff) {
        return staffRepository.save(staff);
    }

    public boolean isHavePhone(String num) {
        return staffRepository.existsByPhoneNumber(num);
    }

    public List<Staff> getAllStaffs() {
        return staffRepository.findAll();
    }

    public Staff getStaffById(long id) {
        return staffRepository.findById(id).orElse(null);
    }

    @Transactional
    public void deleteStaff(long id) {
        staffRepository.deleteById(id);
    }
}
