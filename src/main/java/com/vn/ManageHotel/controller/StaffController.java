package com.vn.ManageHotel.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.vn.ManageHotel.domain.Staff;
import com.vn.ManageHotel.service.StaffService;
import com.vn.ManageHotel.service.UploadService;
import com.vn.ManageHotel.utils.PaginationUtils;

import jakarta.validation.Valid;

import org.springframework.web.bind.annotation.PostMapping;

@Controller
@RequestMapping("/staff")
public class StaffController {
    @Value("${server.url}")
    private String serverUrl;

    private final StaffService staffService;
    private final PasswordEncoder passwordEncoder;
    private final UploadService uploadService;

    public StaffController(StaffService staffService, PasswordEncoder passwordEncoder, UploadService uploadService) {
        this.staffService = staffService;
        this.passwordEncoder = passwordEncoder;
        this.uploadService = uploadService;
    }

    @GetMapping("")
    public String getMethodName(Model model,
            @RequestParam(required = false) String searchTerm,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {

        if (model.containsAttribute("currentPage")) {
            pageNum = (int) model.asMap().get("currentPage");
        }

        int totalPages = staffService.getTotalPages(searchTerm, pageSize);
        if (pageNum > totalPages)
            pageNum = totalPages;
        else if (pageNum <= 0)
            pageNum = 1;
        List<Staff> staffList = staffService.getPaginatedStaff(searchTerm, pageNum, pageSize);
        List<Integer> pageArray = PaginationUtils.getPagination(totalPages, pageNum, 5);
        model.addAttribute("staffList", staffList);
        model.addAttribute("pageArray", pageArray);
        model.addAttribute("currentPage", pageNum);
        model.addAttribute("searchTerm", searchTerm);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("newStaff", new Staff());
        model.addAttribute("serverUrl", serverUrl);
        return "staff/show";
    }

    @PostMapping("")
    public String postMethodName(Model model,
            @ModelAttribute("newStaff") @Valid Staff staff,
            BindingResult bindingResult,
            @RequestParam("nFile") MultipartFile file) {
        if (bindingResult.hasErrors() || staffService.isHavePhone(staff.getPhoneNumber())) {
            List<Staff> staffList = staffService.getPaginatedStaff(null, 1, 10);
            if (staffService.isHavePhone(staff.getPhoneNumber())) {
                bindingResult.rejectValue("phoneNumber", "error.phoneNumber", "Số điện thoại đã tồn tại");
            }
            model.addAttribute("staffList", staffList);
            int totalPages = staffService.getTotalPages(null, 10);
            model.addAttribute("currentPage", 1);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("newStaff", staff); // Thêm lại đối tượng staff để giữ thông tin người dùng đã nhập
            model.addAttribute("errors", bindingResult);
            return "staff/show";
        }
        staff.setPassword(passwordEncoder.encode(staff.getPassword()));
        if (!file.isEmpty()) {
            String avatar = this.uploadService.handleSaveUploadFile(file, "avatar");
            staff.setAvatar(avatar);
        } else {
            staff.setAvatar(null);
        }
        staffService.saveStaff(staff);
        return "redirect:/staff";
    }

    @PostMapping("/approve")
    public String blockStaff(@RequestParam("id") Long id,
            @RequestParam("page") int currentPage,
            RedirectAttributes redirectAttributes) {
        Staff staff = staffService.getStaffById(id);
        if (staff != null) {
            staff.setApproved(!staff.isApproved());
            staffService.saveStaff(staff);
        }

        int pageNum = currentPage;

        redirectAttributes.addFlashAttribute("currentPage", pageNum);
        if (staff.isApproved()) {
            redirectAttributes.addFlashAttribute("status", "Cấp phép cho người dùng: " + staff.getFullName());
        } else {
            redirectAttributes.addFlashAttribute("status", "Chặn người dùng: " + staff.getFullName());

        }

        return "redirect:/staff";
    }

    @GetMapping("/update/{sid}")
    public String getUpdateStaff(@PathVariable String sid, Model model, RedirectAttributes redirectAttributes) {
        long id;
        try {
            id = Long.parseLong(sid);
        } catch (NumberFormatException e) {
            redirectAttributes.addFlashAttribute("status", "ID không hợp lệ. Vui lòng kiểm tra lại.");
            return "redirect:/staff";
        }

        List<Staff> staffList = staffService.getAllStaffs();
        Staff staffById = staffService.getStaffById(id);
        if (staffById == null) {
            redirectAttributes.addFlashAttribute("status", "ID không hợp lệ. Vui lòng kiểm tra lại.");
            return "redirect:/staff";
        }
        model.addAttribute("staffList", staffList);
        model.addAttribute("staffById", staffById);
        model.addAttribute("staffAvatar", staffById.getAvatar());

        return "staff/update";
    }

    @PostMapping("/update")
    public String updateStaff(@ModelAttribute("staffById") @Valid Staff staff, BindingResult bindingResult,
            RedirectAttributes redirectAttributes, Model model, @RequestParam("nFile") MultipartFile file) {

        if (bindingResult.hasErrors() ||
                (staffService.isHavePhone(staff.getPhoneNumber()) && !staff.getPhoneNumber().equals(staffService
                        .getStaffById(staff.getId()).getPhoneNumber()))) {
            if (staffService.isHavePhone(staff.getPhoneNumber()) && !staff.getPhoneNumber().equals(staffService
                    .getStaffById(staff.getId()).getPhoneNumber())) {
                bindingResult.rejectValue("phoneNumber", "error.phoneNumber", "Số điện thoại đã tồn tại");
            }
            List<Staff> staffList = staffService.getAllStaffs();
            model.addAttribute("staffList", staffList);
            model.addAttribute("staffById", staff);
            model.addAttribute("staffAvatar", staffService.getStaffById(staff.getId()).getAvatar());
            model.addAttribute("errors", bindingResult);
            return "staff/update";
        }
        staff.setPassword(staffService.getStaffById(staff.getId()).getPassword());
        staff.setAvatar(staffService.getStaffById(staff.getId()).getAvatar());
        if (!file.isEmpty()) {
            this.uploadService.handleDeleteFile(staffService.getStaffById(staff.getId()).getAvatar(), "avatar");
            String finalName = this.uploadService.handleSaveUploadFile(file, "avatar");
            staff.setAvatar(finalName);
        }
        staffService.saveStaff(staff);
        int pageSize = 3; // Each page has 3 staff members
        int pageNum = 1; // Default starts from page 1
        List<Staff> staffList = staffService.getAllStaffs();

        // Find the position of the updated staff in the list
        int staffIndex = -1;
        for (int i = 0; i < staffList.size(); i++) {
            if (staffList.get(i).getId().equals(staff.getId())) {
                staffIndex = i;
                break;
            }
        }

        // If the staff member is found in the list
        if (staffIndex != -1) {
            // Calculate the page number where this staff member is located
            pageNum = (staffIndex / pageSize) + 1;
        }

        // Add flash attributes to retain state after redirect
        redirectAttributes.addFlashAttribute("currentPage", pageNum);
        redirectAttributes.addFlashAttribute("status", "Cập nhật nhân viên thành công.");
        return "redirect:/staff";
    }

    @PostMapping("/delete")
    public String deleteStaff(@RequestParam("id") long id, RedirectAttributes redirectAttributes) {
        staffService.deleteStaff(id);
        redirectAttributes.addFlashAttribute("status", "Xóa thành công.");
        return "redirect:/staff";
    }

}
