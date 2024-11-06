package com.vn.ManageHotel.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.vn.ManageHotel.domain.Staff;
import com.vn.ManageHotel.service.StaffService;

import jakarta.validation.Valid;

import org.springframework.web.bind.annotation.PostMapping;

@Controller
@RequestMapping("/staff")
public class StaffController {
    @Autowired
    private StaffService staffService;

    @GetMapping("")
    public String getMethodName(Model model,
            @RequestParam(required = false) String searchTerm,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "3") int pageSize) {
        List<Staff> staffs = staffService.getPaginatedStaff(searchTerm, pageNum,
                pageSize);
        System.out.println(">>>>>>" + staffs);

        int totalPages = staffService.getTotalPages(searchTerm, pageSize);

        List<Integer> pageArray = StaffService.getPagination(totalPages, pageNum, 5);
        model.addAttribute("nhanViens", staffs);
        model.addAttribute("pageArray", pageArray);
        model.addAttribute("currentPage", pageNum);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("newStaff", new Staff());
        return "staff/show";
    }

    @PostMapping("")
    public String postMethodName(Model model, @ModelAttribute("newStaff") @Valid Staff staff,
            BindingResult newBindingResult) {
        if (newBindingResult.hasErrors()) {
            List<Staff> staffs = staffService.getPaginatedStaff(null, 1,
                    10);
            model.addAttribute("nhanViens", staffs);
            int totalPages = staffService.getTotalPages(null, 10);
            model.addAttribute("currentPage", 1);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("errors", newBindingResult);
            return "staff/show";
        }
        System.out.println(staff);
        return "redirect:/staff";
    }

}
