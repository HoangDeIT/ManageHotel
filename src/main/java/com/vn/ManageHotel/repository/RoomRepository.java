package com.vn.ManageHotel.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.vn.ManageHotel.domain.Room;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long> {
    @Procedure(name = "getPaginatedRooms")
    List<Room> getPaginatedRooms(@Param("searchTerm") String searchTerm, @Param("pageNum") Integer pageNum,
            @Param("pageSize") Integer pageSize, @Param("roomType") String roomType);

    @Query(value = "SELECT getTotalPagesForRooms(:searchTerm, :pageSize, :roomType)", nativeQuery = true)
    int getTotalPagesForRooms(@Param("searchTerm") String searchTerm, @Param("pageSize") int pageSize,
            @Param("roomType") String roomType);
}