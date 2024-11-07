package com.vn.ManageHotel.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.vn.ManageHotel.domain.Customer;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {
    @Procedure(name = "getPaginatedCustomers")
    List<Customer> getPaginatedCustomers(@Param("searchTerm") String searchTerm, @Param("pageNum") Integer pageNum,
            @Param("pageSize") Integer pageSize);

    @Query(value = "SELECT getTotalPagesForCustomers(:searchTerm, :pageSize)", nativeQuery = true)
    int getTotalPagesForCustomers(@Param("searchTerm") String searchTerm, @Param("pageSize") int pageSize);
}
