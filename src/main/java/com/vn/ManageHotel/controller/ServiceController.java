package com.vn.ManageHotel.controller;

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

import com.vn.ManageHotel.domain.Service;
import com.vn.ManageHotel.service.ServiceService;
import com.vn.ManageHotel.utils.PaginationUtils;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/service")
public class ServiceController {

    private final ServiceService serviceService;

    public ServiceController(ServiceService serviceService) {
        this.serviceService = serviceService;
    }

    private void setupServiceModel(Model model,
            List<Service> serviceList,
            int totalPages,
            int currentPage,
            String searchTerm,
            Service newService) {
        List<Integer> pageArray = PaginationUtils.getPagination(totalPages, currentPage, 5);
        model.addAttribute("serviceList", serviceList);
        model.addAttribute("pageArray", pageArray);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("searchTerm", searchTerm);
        model.addAttribute("newService", newService);
    }

    @GetMapping("")
    public String getServices(Model model,
            @RequestParam(value = "searchTerm", required = false) String searchTerm,
            @RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum,
            @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        if (model.containsAttribute("currentPage")) {
            pageNum = (int) model.asMap().get("currentPage");
        }

        int totalPages = serviceService.getTotalPagesServices(searchTerm, size);
        if (pageNum > totalPages)
            pageNum = totalPages;
        else if (pageNum <= 0)
            pageNum = 1;
        List<Service> serviceList = serviceService.getPaginatedServices(searchTerm, pageNum, size);

        setupServiceModel(model, serviceList, totalPages, pageNum, searchTerm, new Service());
        return "service/show";
    }

    @PostMapping("")
    public String postService(Model model, @ModelAttribute("newService") @Valid Service service,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            List<Service> serviceList = serviceService.getPaginatedServices(null, 1, 10);
            int totalPages = serviceService.getTotalPagesServices(null, 10);
            setupServiceModel(model, serviceList, totalPages, 10, null, service);
            model.addAttribute("errors", bindingResult);
            return "service/show";
        }
        serviceService.saveService(service);
        return "redirect:/service";
    }

    @GetMapping("/update/{sid}")
    public String getUpdateService(@PathVariable String sid, Model model, RedirectAttributes redirectAttributes) {
        long id;
        try {
            id = Long.parseLong(sid);
        } catch (NumberFormatException e) {
            redirectAttributes.addFlashAttribute("status", "ID không hợp lệ. Vui lòng kiểm tra lại.");
            return "redirect:/service";
        }
        List<Service> serviceList = serviceService.getAllServices();
        Service serviceById = serviceService.getServiceById(id);
        model.addAttribute("serviceList", serviceList);
        model.addAttribute("serviceById", serviceById);
        return "service/update";
    }

    @PostMapping("/update")
    public String updateService(@ModelAttribute("serviceById") @Valid Service service, BindingResult bindingResult,
            RedirectAttributes redirectAttributes, Model model) {
        if (bindingResult.hasErrors()) {
            List<Service> serviceList = serviceService.getAllServices();
            model.addAttribute("serviceList", serviceList);
            model.addAttribute("serviceById", service);
            model.addAttribute("errors", bindingResult);
            return "service/update";
        }
        serviceService.saveService(service);
        int pageSize = 3; // Each page has 3 services
        int pageNum = 1; // Default starts from page 1
        List<Service> serviceList = serviceService.getAllServices(); // Find the position of the updated service in the
                                                                     // list
        int serviceIndex = -1;
        for (int i = 0; i < serviceList.size(); i++) {
            if (serviceList.get(i).getId().equals(service.getId())) {
                serviceIndex = i;
                break;
            }
        } // If the service is found in the list
        if (serviceIndex != -1) { // Calculate the page number where this service is located
            pageNum = (serviceIndex / pageSize) + 1;
        } // Add flash attributes to retain state after redirect
        redirectAttributes.addFlashAttribute("currentPage", pageNum);
        redirectAttributes.addFlashAttribute("status", "Cập nhật dịch vụ thành công.");
        return "redirect:/service";
    }

    @PostMapping("/delete")
    public String deleteService(@RequestParam("id") long id, RedirectAttributes redirectAttributes) {
        try {
            serviceService.deleteServiceById(id);
            redirectAttributes.addFlashAttribute("status", "Xóa dịch vụ thành công.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("status", "Có lỗi xảy ra khi xóa dịch vụ.");
        }
        return "redirect:/service";
    }

}
