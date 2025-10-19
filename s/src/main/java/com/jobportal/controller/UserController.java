package com.jobportal.controller;

import com.jobportal.entity.User;
import com.jobportal.repository.UserRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.Map;

@RestController
@RequestMapping("/users")
public class UserController {
    private final UserRepository repo;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public UserController(UserRepository repo) {
        this.repo = repo;
    }

    @PostMapping
    public ResponseEntity<?> register(@RequestBody @Valid User payload) {
        if (repo.existsByUsername(payload.getUsername()))
            return ResponseEntity.status(409).body(Map.of("message","Username already exists"));

        payload.setPassword(encoder.encode(payload.getPassword()));
        payload.setName(payload.getName().toUpperCase());
        repo.save(payload);
        return ResponseEntity.status(201).body(Map.of("message","Created"));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> get(@PathVariable Long id, Principal principal) {
        // principal will be map set by JwtFilter
        var optional = repo.findById(id);
        if (optional.isEmpty()) return ResponseEntity.status(404).body(Map.of("message","User not found"));
        return ResponseEntity.ok(optional.get());
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody User payload) {
        var opt = repo.findById(id);
        if (opt.isEmpty()) return ResponseEntity.status(404).body(Map.of("message","User not found"));
        var user = opt.get();
        if (payload.getName() != null) user.setName(payload.getName().toUpperCase());
        if (payload.getEmail() != null) user.setEmail(payload.getEmail());
        if (payload.getPhone() != null) user.setPhone(payload.getPhone());
        if (payload.getPassword() != null && !payload.getPassword().isBlank()) user.setPassword(encoder.encode(payload.getPassword()));
        if (payload.getExperience() != null) user.setExperience(payload.getExperience());
        if (payload.getEducation() != null) user.setEducation(payload.getEducation());
        repo.save(user);
        return ResponseEntity.ok(Map.of("message","Updated"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        var opt = repo.findById(id);
        if (opt.isEmpty()) return ResponseEntity.status(404).body(Map.of("message","User not found"));
        repo.deleteById(id);
        return ResponseEntity.ok(Map.of("message","User deleted successfully"));
    }
}
