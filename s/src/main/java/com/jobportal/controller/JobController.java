package com.jobportal.controller;

import com.jobportal.entity.Company;
import com.jobportal.entity.Job;
import com.jobportal.repository.CompanyRepository;
import com.jobportal.repository.JobRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.Map;

@RestController
@RequestMapping("/jobs")
public class JobController {

    private final JobRepository jobRepo;
    private final CompanyRepository companyRepo;

    public JobController(JobRepository jobRepo, CompanyRepository companyRepo) {
        this.jobRepo = jobRepo;
        this.companyRepo = companyRepo;
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody @Valid Job payload, Principal principal) {
        // principal holds auth map set in JwtFilter
        var auth = (java.util.Map) ((org.springframework.security.core.Authentication) principal).getPrincipal();
        String role = (String) auth.get("role");
        if (!"COMPANY".equals(role)) return ResponseEntity.status(403).body(Map.of("message","Forbidden"));
        Long companyId = Long.valueOf(String.valueOf(auth.get("id")));
        var comp = companyRepo.findById(companyId);
        if (comp.isEmpty()) return ResponseEntity.status(404).body(Map.of("message","Company not found"));
        payload.setCompany(comp.get());
        jobRepo.save(payload);
        return ResponseEntity.status(201).body(Map.of("message","Created"));
    }

    @GetMapping
    public ResponseEntity<?> list(@RequestParam(required = false) String area) {
        if (area != null) return ResponseEntity.ok(jobRepo.findByAreaContainingIgnoreCase(area));
        return ResponseEntity.ok(jobRepo.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> get(@PathVariable Long id) {
        var opt = jobRepo.findById(id);
        if (opt.isEmpty()) return ResponseEntity.status(404).body(Map.of("message","Job not found"));
        return ResponseEntity.ok(opt.get());
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody Job payload, Principal principal) {
        var opt = jobRepo.findById(id);
        if (opt.isEmpty()) return ResponseEntity.status(404).body(Map.of("message","Job not found"));
        var job = opt.get();
        var auth = (java.util.Map) ((org.springframework.security.core.Authentication) principal).getPrincipal();
        String role = (String) auth.get("role");
        if (!"COMPANY".equals(role)) return ResponseEntity.status(403).body(Map.of("message","Forbidden"));
        Long companyId = Long.valueOf(String.valueOf(auth.get("id")));
        if (!job.getCompany().getId().equals(companyId)) return ResponseEntity.status(403).body(Map.of("message","Forbidden"));
        if (payload.getTitle() != null) job.setTitle(payload.getTitle());
        if (payload.getArea() != null) job.setArea(payload.getArea());
        if (payload.getDescription() != null) job.setDescription(payload.getDescription());
        if (payload.getLocation() != null) job.setLocation(payload.getLocation());
        if (payload.getContact() != null) job.setContact(payload.getContact());
        if (payload.getSalary() != null) job.setSalary(payload.getSalary());
        jobRepo.save(job);
        return ResponseEntity.ok(Map.of("message","Job updated successfully"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id, Principal principal) {
        var opt = jobRepo.findById(id);
        if (opt.isEmpty()) return ResponseEntity.status(404).body(Map.of("message","Job not found"));
        var job = opt.get();
        var auth = (java.util.Map) ((org.springframework.security.core.Authentication) principal).getPrincipal();
        String role = (String) auth.get("role");
        if (!"COMPANY".equals(role)) return ResponseEntity.status(403).body(Map.of("message","Forbidden"));
        Long companyId = Long.valueOf(String.valueOf(auth.get("id")));
        if (!job.getCompany().getId().equals(companyId)) return ResponseEntity.status(403).body(Map.of("message","Forbidden"));
        jobRepo.delete(job);
        return ResponseEntity.ok(Map.of("message","Job deleted successfully"));
    }

    @GetMapping("/company/{companyId}")
    public ResponseEntity<?> listByCompany(@PathVariable Long companyId) {
        return ResponseEntity.ok(jobRepo.findByCompanyId(companyId));
    }
}
