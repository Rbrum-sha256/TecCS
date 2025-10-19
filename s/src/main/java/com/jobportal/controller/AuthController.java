package com.jobportal.controller;

import com.jobportal.entity.User;
import com.jobportal.entity.Company;
import com.jobportal.repository.UserRepository;
import com.jobportal.repository.CompanyRepository;
import com.jobportal.util.JwtUtil;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
public class AuthController {

    private final UserRepository userRepo;
    private final CompanyRepository companyRepo;
    private final JwtUtil jwtUtil;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public AuthController(UserRepository userRepo, CompanyRepository companyRepo, JwtUtil jwtUtil) {
        this.userRepo = userRepo;
        this.companyRepo = companyRepo;
        this.jwtUtil = jwtUtil;
    }

    record LoginReq(String username, String password){}

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody @Valid LoginReq req) {
        var uOpt = userRepo.findByUsername(req.username);
        if (uOpt.isPresent()) {
            User u = uOpt.get();
            if (!encoder.matches(req.password, u.getPassword())) return ResponseEntity.status(401).body(Map.of("message","Invalid credentials"));
            Map<String,Object> claims = new HashMap<>();
            claims.put("sub", String.valueOf(u.getId()));
            claims.put("username", u.getUsername());
            claims.put("role", "USER");
            String token = jwtUtil.generateToken(claims);
            return ResponseEntity.ok(Map.of("token", token, "expires_in", 3600));
        }
        var cOpt = companyRepo.findByUsername(req.username);
        if (cOpt.isPresent()) {
            Company c = cOpt.get();
            if (!encoder.matches(req.password, c.getPassword())) return ResponseEntity.status(401).body(Map.of("message","Invalid credentials"));
            Map<String,Object> claims = new HashMap<>();
            claims.put("sub", String.valueOf(c.getId()));
            claims.put("username", c.getUsername());
            claims.put("role", "COMPANY");
            String token = jwtUtil.generateToken(claims);
            return ResponseEntity.ok(Map.of("token", token, "expires_in", 3600));
        }
        return ResponseEntity.status(401).body(Map.of("message","Invalid credentials"));
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout() {
        // Stateless JWT: logout handled client-side by deleting token. We return OK for protocol.
        return ResponseEntity.ok(Map.of("message","OK"));
    }
}
