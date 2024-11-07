package com.vn.ManageHotel.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.vn.ManageHotel.domain.Rental;

@Repository
public interface RentalRepository extends JpaRepository<Rental, Long> {

    @Procedure(name = "getPaginatedRentals")
    List<Rental> getPaginatedRentals(
            @Param("searchTerm") String searchTerm,
            @Param("pageNum") Integer pageNum,
            @Param("pageSize") Integer pageSize,
            @Param("startDate") String startDate,
            @Param("endDate") String endDate);

    @Query(value = "SELECT getTotalPagesForRentals(:searchTerm, :pageSize, :startDate, :endDate)", nativeQuery = true)
    int getTotalPagesForRentals(
            @Param("searchTerm") String searchTerm,
            @Param("pageSize") int pageSize,
            @Param("startDate") String startDate,
            @Param("endDate") String endDate);
}
