package com.vn.ManageHotel.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.vn.ManageHotel.domain.Room;
import com.vn.ManageHotel.repository.RoomRepository;

@Service
public class RoomService {

    private final RoomRepository roomRepository;

    public RoomService(RoomRepository roomRepository) {
        this.roomRepository = roomRepository;
    }

    @Transactional
    public List<Room> getPaginatedRooms(String searchTerm, int pageNum, int pageSize, String roomType) {
        return roomRepository.getPaginatedRooms(searchTerm, pageNum, pageSize, roomType);
    }

    @Transactional
    public int getTotalPagesForRooms(String searchTerm, int pageSize, String roomType) {
        return roomRepository.getTotalPagesForRooms(searchTerm, pageSize, roomType);
    }

    public Room saveRoom(Room room) {
        return this.roomRepository.save(room);
    }

    public List<Room> getAllRooms() {
        return roomRepository.findAll();
    }

    public Room getRoomById(long id) {
        return roomRepository.findById(id).orElse(null);
    }

    public void deleteRoom(long id) {
        roomRepository.deleteById(id);
    }
}