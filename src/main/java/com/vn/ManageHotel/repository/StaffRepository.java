package com.vn.ManageHotel.repository;

import com.vn.ManageHotel.domain.Staff;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StaffRepository extends JpaRepository<Staff, Long> {

    @Procedure(name = "getPaginatedStaff")
    List<Staff> getPaginatedStaff(@Param("searchTerm") String searchTerm, @Param("pageNum") Integer pageNum,
            @Param("pageSize") Integer pageSize);

    @Query(value = "SELECT getTotalPages(:searchTerm, :pageSize)", nativeQuery = true)
    int getTotalPages(@Param("searchTerm") String searchTerm, @Param("pageSize") int pageSize);

    boolean existsByPhoneNumber(String phoneNumber);

    Optional<Staff> findById(long id);

    void deleteById(long id);
}
