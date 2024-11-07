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

import com.vn.ManageHotel.domain.Room;
import com.vn.ManageHotel.service.RoomService;
import com.vn.ManageHotel.utils.PaginationUtils;
import com.vn.ManageHotel.utils.constant.RoomType;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/room")
public class RoomController {

    private final RoomService roomService;

    public RoomController(RoomService roomService) {
        this.roomService = roomService;
    }

    private void setupModel(Model model, List<Room> roomList, int totalPages, int currentPage, String searchTerm,
            Room newRoom, String roomType) {
        List<Integer> pageArray = PaginationUtils.getPagination(totalPages, currentPage, 5);
        model.addAttribute("roomList", roomList);
        model.addAttribute("pageArray", pageArray);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("searchTerm", searchTerm);
        model.addAttribute("newRoom", newRoom);
        model.addAttribute("roomType", roomType);
    }

    @GetMapping("")
    public String getRooms(Model model, @RequestParam(value = "searchTerm", required = false) String searchTerm,
            @RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum,
            @RequestParam(value = "size", required = false, defaultValue = "2") int size,
            @RequestParam(value = "roomType", required = false) String roomType) {
        if (model.containsAttribute("currentPage")) {
            pageNum = (int) model.asMap().get("currentPage");
        }
        int totalPages = roomService.getTotalPagesForRooms(searchTerm, size, roomType);
        List<Room> roomList = roomService.getPaginatedRooms(searchTerm, pageNum, size, roomType);
        setupModel(model, roomList, totalPages, pageNum, searchTerm, new Room(), roomType);
        return "room/show";
    }

    @PostMapping("")
    public String postRoom(Model model, @ModelAttribute("newRoom") @Valid Room room, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            List<Room> roomList = roomService.getPaginatedRooms(null, 1, 10, null);
            int totalPages = roomService.getTotalPagesForRooms(null, 10, null);
            setupModel(model, roomList, totalPages, 1, null, room, null);
            model.addAttribute("errors", bindingResult);
            return "room/show";
        }
        roomService.saveRoom(room);
        return "redirect:/room";
    }

    @GetMapping("/update/{sid}")
    public String getUpdateRoom(@PathVariable String sid, Model model, RedirectAttributes redirectAttributes) {
        long id;
        try {
            id = Long.parseLong(sid);
        } catch (NumberFormatException e) {
            redirectAttributes.addFlashAttribute("status", "ID không hợp lệ. Vui lòng kiểm tra lại.");
            return "redirect:/room";
        }
        List<Room> roomList = roomService.getAllRooms();
        Room roomById = roomService.getRoomById(id);
        model.addAttribute("roomList", roomList);
        model.addAttribute("roomById", roomById);
        return "room/update";
    }

    @PostMapping("/update")
    public String updateRoom(@ModelAttribute("roomById") @Valid Room room, BindingResult bindingResult,
            RedirectAttributes redirectAttributes, Model model) {
        if (bindingResult.hasErrors()) {
            List<Room> roomList = roomService.getAllRooms();
            model.addAttribute("roomList", roomList);
            model.addAttribute("roomById", room);
            model.addAttribute("errors", bindingResult);
            return "room/update";
        }
        roomService.saveRoom(room);
        int pageSize = 3; // Each page has 3 rooms
        int pageNum = 1; // Default starts from page 1
        List<Room> roomList = roomService.getAllRooms(); // Find the position of the updated room in the list
        int roomIndex = -1;
        for (int i = 0; i < roomList.size(); i++) {
            if (roomList.get(i).getId().equals(room.getId())) {
                roomIndex = i;
                break;
            }
        } // If the room is found in the list
        if (roomIndex != -1) { // Calculate the page number where this room is located
            pageNum = (roomIndex / pageSize) + 1;
        } // Add flash attributes to retain state after redirect
        redirectAttributes.addFlashAttribute("currentPage", pageNum);
        redirectAttributes.addFlashAttribute("status", "Cập nhật phòng thành công.");
        return "redirect:/room";
    }

    @PostMapping("/delete")
    public String deleteRoom(@RequestParam("id") long id, RedirectAttributes redirectAttributes) {
        try {
            roomService.deleteRoom(id);
            redirectAttributes.addFlashAttribute("status", "Xóa phòng thành công.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("status", "Có lỗi xảy ra khi xóa phòng.");
        }
        return "redirect:/room";
    }
}
