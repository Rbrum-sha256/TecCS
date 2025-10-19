package com.jobportal.controller;

import com.jobportal.entity.Company;
import com.jobportal.repository.CompanyRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/companies")
public class CompanyController {
    private final CompanyRepository repo;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public CompanyController(CompanyRepository repo) { this.repo = repo; }

    @PostMapping
    public ResponseEntity<?> register(@RequestBody Company payload) {
        if (repo.existsByUsername(payload.getUsername())) return ResponseEntity.status(409).body(Map.of("message","Username already exists"));
        payload.setPassword(encoder.encode(payload.getPassword()));
        payload.setName(payload.getName().toUpperCase());
        repo.save(payload);
        return ResponseEntity.status(201).body(Map.of("message","Created"));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> get(@PathVariable Long id) {
        var opt = repo.findById(id);
        if (opt.isEmpty()) return ResponseEntity.status(404).body(Map.of("message","Company not found"));
        return ResponseEntity.ok(opt.get());
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody Company payload) {
        var opt = repo.findById(id);
        if (opt.isEmpty()) return ResponseEntity.status(404).body(Map.of("message","Company not found"));
        var comp = opt.get();
        if (payload.getName() != null) comp.setName(payload.getName().toUpperCase());
        if (payload.getEmail() != null) comp.setEmail(payload.getEmail());
        if (payload.getPhone() != null) comp.setPhone(payload.getPhone());
        if (payload.getStreet() != null) comp.setStreet(payload.getStreet());
        if (payload.getNumber() != null) comp.setNumber(payload.getNumber());
        if (payload.getCity() != null) comp.setCity(payload.getCity());
        if (payload.getState() != null) comp.setState(payload.getState());
        if (payload.getPassword() != null && !payload.getPassword().isBlank()) comp.setPassword(encoder.encode(payload.getPassword()));
        repo.save(comp);
        return ResponseEntity.ok(Map.of("message","Updated"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        var opt = repo.findById(id);
        if (opt.isEmpty()) return ResponseEntity.status(404).body(Map.of("message","Company not found"));
        // business rule: ensure no active jobs - for now assume jobs must be empty
        var company = opt.get();
        if (company.getJobs() != null && !company.getJobs().isEmpty())
            return ResponseEntity.status(409).body(Map.of("message","Cannot delete company with active jobs"));
        repo.deleteById(id);
        return ResponseEntity.ok(Map.of("message","Company deleted successfully"));
    }

    @GetMapping
    public ResponseEntity<?> list() { return ResponseEntity.ok(repo.findAll()); }
}
