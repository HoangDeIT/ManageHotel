package com.vn.ManageHotel.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.vn.ManageHotel.domain.Customer;
import com.vn.ManageHotel.domain.Staff;
import com.vn.ManageHotel.service.CustomerService;
import com.vn.ManageHotel.service.StaffService;
import com.vn.ManageHotel.utils.PaginationUtils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    private final CustomerService customerService;
    private final StaffService staffService;

    public CustomerController(CustomerService customerService,
            StaffService staffService) {
        this.customerService = customerService;
        this.staffService = staffService;
    }

    private void setupModel(Model model,
            List<Customer> customerList,
            int totalPages,
            int currentPage,
            String searchTerm,
            Customer newCustomer) {
        List<Integer> pageArray = PaginationUtils.getPagination(totalPages, currentPage, 5);
        model.addAttribute("customerList", customerList);
        model.addAttribute("pageArray", pageArray);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("searchTerm", searchTerm);
        model.addAttribute("newCustomer", newCustomer);
    }

    @GetMapping("")
    public String getMethodName(Model model,
            @RequestParam(value = "searchTerm", required = false) String searchTerm,
            @RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum,
            @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        if (model.containsAttribute("currentPage")) {
            pageNum = (int) model.asMap().get("currentPage");
        }
        int totalPages = customerService.getTotalPagesForCustomers(searchTerm, size);
        if (pageNum > totalPages)
            pageNum = totalPages;
        else if (pageNum <= 0)
            pageNum = 1;
        List<Customer> customerList = customerService.getPaginatedCustomers(searchTerm, pageNum, size);
        setupModel(model, customerList, totalPages, pageNum, searchTerm, new Customer());
        return "customer/show";
    }

    @PostMapping("")
    public String postMethodName(Model model, @ModelAttribute("newCustomer") @Valid Customer customer,
            BindingResult bindingResult, HttpServletRequest request) {
        if (bindingResult.hasErrors()) {
            List<Customer> customerList = customerService.getPaginatedCustomers(null, 1, 10);
            int totalPages = customerService.getTotalPagesForCustomers(null, 10);
            setupModel(model, customerList, totalPages, 1, null, customer);
            model.addAttribute("errors", bindingResult);
            return "customer/show";
        }
        HttpSession session = request.getSession(false);
        long idStaff = (long) session.getAttribute("staffId");
        Staff staffCreate = staffService.getStaffById(idStaff);
        customer.setCreatedBy(staffCreate);
        customerService.saveCustomer(customer);
        return "redirect:/customer";
    }

    @GetMapping("/update/{cid}")
    public String getUpdateCustomer(@PathVariable String cid, Model model, RedirectAttributes redirectAttributes) {
        long id;
        try {
            id = Long.parseLong(cid);
        } catch (NumberFormatException e) {
            redirectAttributes.addFlashAttribute("status", "ID không hợp lệ. Vui lòng kiểm tra lại.");
            return "redirect:/customer";
        }

        List<Customer> customerList = customerService.getAllCustomers();
        Customer customerById = customerService.getCustomerById(id);
        if (customerById == null) {
            redirectAttributes.addFlashAttribute("status", "ID không hợp lệ. Vui lòng kiểm tra lại.");
        }
        model.addAttribute("customerList", customerList);
        model.addAttribute("customerById", customerById);
        return "customer/update";
    }

    @PostMapping("/update")
    public String updateCustomer(@ModelAttribute("customerById") @Valid Customer customer, BindingResult bindingResult,
            RedirectAttributes redirectAttributes, Model model) {
        if (bindingResult.hasErrors()) {
            List<Customer> customerList = customerService.getAllCustomers();
            model.addAttribute("customerList", customerList);
            model.addAttribute("customerById", customer);
            model.addAttribute("errors", bindingResult);
            return "customer/update";
        }
        Customer currentCustomer = customerService.getCustomerById(customer.getId());
        customer.setCreatedBy(currentCustomer.getCreatedBy());
        customer.setRentals(currentCustomer.getRentals());
        customerService.saveCustomer(customer);
        int pageSize = 10;
        int pageNum = 1; // Default starts from page 1
        List<Customer> customerList = customerService.getAllCustomers();

        // Find the position of the updated customer in the list
        int customerIndex = -1;
        for (int i = 0; i < customerList.size(); i++) {
            if (customerList.get(i).getId().equals(customer.getId())) {
                customerIndex = i;
                break;
            }
        }

        // If the customer is found in the list
        if (customerIndex != -1) {
            // Calculate the page number where this customer is located
            pageNum = (customerIndex / pageSize) + 1;
        }

        // Add flash attributes to retain state after redirect
        redirectAttributes.addFlashAttribute("currentPage", pageNum);
        redirectAttributes.addFlashAttribute("status", "Cập nhật khách hàng thành công.");
        return "redirect:/customer";
    }

    @PostMapping("/delete")
    public String deleteCustomer(@RequestParam("id") long id, RedirectAttributes redirectAttributes) {
        try {
            customerService.deleteCustomer(id);
            redirectAttributes.addFlashAttribute("status", "Xóa khách hàng thành công.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("status", "Xóa khách hàng thất bại. Vui lòng thử lại.");
        }
        return "redirect:/customer";
    }

}
