package com.vn.ManageHotel.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.vn.ManageHotel.domain.Service;
import com.vn.ManageHotel.repository.ServiceRepository;

import java.util.List;

@org.springframework.stereotype.Service
public class ServiceService {

    @Autowired
    private ServiceRepository serviceRepository;

    @Transactional
    public List<Service> getPaginatedServices(String searchTerm, int pageNum, int pageSize) {
        return serviceRepository.getPaginatedServices(searchTerm, pageNum, pageSize);
    }

    @Transactional
    public int getTotalPagesServices(String searchTerm, int pageSize) {
        return serviceRepository.getTotalPagesServices(searchTerm, pageSize);
    }

    public Service saveService(Service service) {
        return serviceRepository.save(service);
    }

    public List<Service> getAllServices() {
        return serviceRepository.findAll();
    }

    public Service getServiceById(long id) {
        return serviceRepository.findById(id).orElse(null);
    }

    public void deleteServiceById(long id) {
        this.serviceRepository.deleteById(id);
    }
}
