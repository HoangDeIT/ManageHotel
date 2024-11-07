package com.vn.ManageHotel.service;

import com.vn.ManageHotel.domain.Staff;
import com.vn.ManageHotel.repository.StaffRepository;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

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
        return staffRepository.getTotalPagesForStaff(searchTerm, pageSize);
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

    public void deleteStaff(long id) {
        staffRepository.deleteById(id);
    }

    public Optional<Staff> getStaffByPhoneNumber(String phoneNumber) {
        return staffRepository.findByPhoneNumber(phoneNumber);
    }
}
