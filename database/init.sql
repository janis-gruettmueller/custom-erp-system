/********************************************************
 * File: init.sql
 * Version: 1.0
 * Author: Janis Grüttmüller on 13.02.2025
 * Description: sql script to initialize the ERP Systems 
 * productive database and pre-populate it with data
 *
 * change history:
 * 13.02.2025 - added the user access managment logic
 *******************************************************/

/* ====================================================================== *
 *                    create database and schema                          *
 * ====================================================================== */

DROP DATABASE IF EXISTS erp_prod;

CREATE DATABASE erp_prod;

USE erp_prod;


-------------- Users, Roles and Permissions (User Administration Modul) -------------------
CREATE TABLE roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(255) NOT NULL,
    role_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE permissions (
    permission_id INT PRIMARY KEY AUTO_INCREMENT,
    permission_name VARCHAR(255) NOT NULL,
    permission_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    user_status ENUM('ACTIVE', 'LOCKED', 'DELETED') NOT NULL DEFAULT 'ACTIVE',
    /*
        - ACTIVE: User can log in and use the system.
        - LOCKED: User is temporarily blocked (e.g., failed logins, security issues).
        - DELETED: Soft delete -> User cannot log in, and role mappings are removed.
    */
    password_hash VARCHAR(255) NOT NULL,
    num_failed_login INT DEFAULT 0,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_until TIMESTAMP DEFAULT NULL,
    FOREIGN KEY (created_by) REFERENCES users(user_id),
    INDEX idx_username (username)
);

-- table for managing permissions per role
CREATE TABLE role_permissions (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    FOREIGN KEY (permission_id) REFERENCES permissions(permission_id)
);

-- table for managing user access rights
CREATE TABLE user_roles (
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    assigned_by INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    FOREIGN KEY (assigned_by) REFERENCES users(user_id)
    
);

------------------------ Change Logging for User Access Rights -----------------------

CREATE TABLE security_audit_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    role_id INT DEFAULT NULL,
    updated_by INT NOT NULL,
    action_type ENUM('USER_CREATED', 'USER_DELETED', 'ROLE_ASSIGNED', 'ROLE_REMOVED') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (updated_by) REFERENCES users(user_id)
);

------------ Employee, Payroll, Salary and Benefits (HR Operations) -------------------

-- table to store essential employee information and personal data
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    job_titel VARCHAR(100),
    department VARCHAR(100),
    employment_type ENUM('FULL_TIME', 'PART_TIME', 'CONTRACTOR') NOT NULL,
    hire_date DATE NOT NULL,
    start_date DATE DEFAULT NULL,
    termination_date DATE DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL,
    last_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- table to store historical payroll data
CREATE TABLE payroll (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    pay_period_start DATE NOT NULL,
    pay_period_end DATE NOT NULL,
    gross_salary DECIMAL(10,2) NOT NULL,
    total_deductions DECIMAL(10,2) NOT NULL,
    net_salary DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_status ENUM('PENDING', 'PROCESSED', 'FAILED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- table to keep track of employee salaries and adjustments over time
CREATE TABLE salaries (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    base_salary DECIMAL(10,2) NOT NULL,
    effective_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- table to store payroll deductions like taxes, benefits, etc.
CREATE TABLE payroll_deductions (
    deduction_id INT PRIMARY KEY AUTO_INCREMENT,
    payroll_id INT NOT NULL,
    deduction_type ENUM('TAX', 'INSURANCE', 'PENSION', 'OTHER') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (payroll_id) REFERENCES payroll(payroll_id) ON DELETE CASCADE
);

-- table to store employees payment info
CREATE TABLE payment_details (
    employee_id INT PRIMARY KEY,
    payment_method ENUM('BANK_TRANSFER', 'CHECK') NOT NULL,
    account_holder_name VARCHAR(255) DEFAULT NULL,
    encrypted_bank_account VARBINARY(255) DEFAULT NULL,  -- Store encrypted bank account number (EU: IBAN)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

CREATE TABLE employee_benefits (
    benefit_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    benefit_type ENUM('HEALTH_INSURANCE', 'PENSION', 'PAID_LEAVE', 'OTHER') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE DEFAULT NULL,
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

---------------- Transactions, General Ledger, Controlling (Finance Modul) -----------------------------





/* ====================================================================== *
 *                    populate database with data                         *
 * ====================================================================== */


START TRANSACTION;
-- Create Roles
INSERT INTO roles (role_id, role_name, role_description) VALUES
    (1, 'Admin', 'Full access to system configurations and user management'),
    (2, 'FI Ops', 'Manages financial transactions, reports, and analysis'),
    (3, 'HR Ops', 'Manages employee records, payroll, and benefits'),
    (4, 'Employee', 'Access to personal data, payroll records, and requests of absence')
;

-- Create Permissions
INSERT INTO permissions (permission_id, permission_name, permission_description) VALUES
    (1, 'View Financial Data', 'Ability to view financial transactions and reports'),
    (2, 'Modify Financial Data', 'Ability to create and edit financial transactions'),
    (3, 'Approve Financial Data', 'Ability to approve or finalize financial data'),
    (4, 'View Payroll Data', 'Ability to view payroll and salary information'),
    (5, 'Modify Payroll Data', 'Ability to create and edit payroll and salary information'),
    (6, 'Approve Payroll Data', 'Ability to approve payroll and salary changes'),
    (7, 'View Employee Data', 'Ability to view employee personal information'),
    (8, 'Modify Employee Data', 'Ability to edit employee personal information'),
    (9, 'Submit Request of Absence', 'Ability to submit and view personal requests of absence'),
    (10, 'Create User', 'Ability to create new user accounts'),
    (11, 'Deactivate User', 'Ability to deactivate existing user accounts'),
    (12, 'Modify User Access', 'Ability to modify access rights of existing user accounts')
;

------------------------------- Assign Permissions to Roles --------------------------------------

-- Admin (Full Access)
INSERT INTO role_permissions (role_id, permission_id) VALUES
    (1, 1), (1, 2), (1, 3),     -- Financial Data (View, Modify, Approve)
    (1, 4), (1, 5), (1, 6),     -- Payroll Data (View, Modify, Approve)
    (1, 7), (1, 8), (1, 9),     -- Employee Data (View, Modify, Update)
    (1, 10), (1, 11), (1, 12)   -- User Access Management (Create, Deactivate, Modify Access)
;

-- FI Ops (Finance Operations)
INSERT INTO role_permissions (role_id, permission_id) VALUES
    (2, 1),  -- View Financial Data
    (2, 2),  -- Modify Financial Data
    (2, 3)   -- Approve Financial Data
;

-- HR Ops (HR Operations)
INSERT INTO role_permissions (role_id, permission_id) VALUES
    (3, 4), (3, 5), (3, 6),  -- Payroll Data (View, Modify, Approve)
    (3, 7), (3, 8), (3, 9)   -- Employee Data (View, Modify, Update) + Submit & Manage Requests
;

-- Employee (Personal Access)
INSERT INTO role_permissions (role_id, permission_id) VALUES
    (4, 4),  -- View Payroll Data
    (4, 7),  -- View Personal Employee Data
    (4, 9)  -- Submit or view Request of absence
;

COMMIT;

START TRANSACTION;

-- default system user for initial system setup -> it is highly recommended to lock the user following the initial setup
INSERT INTO users (user_id, username, user_status, password_hash, created_by) VALUES (1, 'SYS_USER', 'ACTIVE', '$2a$10$Z6v/1IM1G2x6e47i1HnhvuWAmNgTETU7RiYzc4kRxu7LdNy1.PARu', 1);  -- password: "initERP@2025" hashed with BCrypt
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1); -- assign SYS_USER admin rights

COMMIT;