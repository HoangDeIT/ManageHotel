package com.vn.ManageHotel.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.vn.ManageHotel.domain.Customer;
import com.vn.ManageHotel.repository.CustomerRepository;

import jakarta.transaction.Transactional;

@Service
public class CustomerService {
    private final CustomerRepository customerRepository;

    public CustomerService(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    @Transactional
    public List<Customer> getPaginatedCustomers(String searchTerm, int pageNum, int pageSize) {
        return customerRepository.getPaginatedCustomers(searchTerm, pageNum, pageSize);
    }

    @Transactional
    public int getTotalPagesForCustomers(String searchTerm, int pageSize) {
        return customerRepository.getTotalPagesForCustomers(searchTerm, pageSize);
    }

    public Customer saveCustomer(Customer customer) {
        return customerRepository.save(customer);
    }

    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }

    public Customer getCustomerById(long id) {
        return customerRepository.findById(id).orElse(null);
    }

    public void deleteCustomer(long id) {
        customerRepository.deleteById(id);
    }
}
