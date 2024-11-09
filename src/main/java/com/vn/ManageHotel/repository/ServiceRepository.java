package com.vn.ManageHotel.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.vn.ManageHotel.domain.Service;

import org.springframework.data.jpa.repository.query.Procedure;

import java.util.List;

public interface ServiceRepository extends JpaRepository<Service, Long> {

    @Procedure(name = "getPaginatedServices")
    List<Service> getPaginatedServices(
            @Param("searchTerm") String searchTerm,
            @Param("pageNum") Integer pageNum,
            @Param("pageSize") Integer pageSize);

    @Query(value = "SELECT getTotalPagesServices(:searchTerm, :pageSize)", nativeQuery = true)
    int getTotalPagesServices(
            @Param("searchTerm") String searchTerm,
            @Param("pageSize") int pageSize);
}
