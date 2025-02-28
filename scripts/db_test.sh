#!/bin/bash

DB_USER="root"
DB_PASS=""
DB_NAME="erp_prod"
REPORT_FILE="test_report.txt"

EXPECTED_TABLES=(
    "roles" "permissions" "users" "role_permissions" "user_roles"
    "security_audit_log" "user_history_log" "employees" "payroll"
    "salaries" "payroll_deductions" "payment_details" "employee_benefits"
    "user_employee_link"
)

# Erwartete Spalten pro Tabelle
EXPECTED_COLUMNS_ROLES=("role_id" "role_name" "role_description" "created_at" "last_updated_at")
EXPECTED_COLUMNS_PERMISSIONS=("permission_id" "permission_name" "permission_description" "created_at" "last_updated_at")
EXPECTED_COLUMNS_USERS=("user_id" "username" "user_status" "user_type" "is_verified" "password_hash" "num_failed_login_attempts" "last_login_at" "valid_until" "created_by" "created_at" "last_updated_by" "last_updated_at")
EXPECTED_COLUMNS_ROLE_PERMISSIONS=("role_id" "permission_id" "created_by" "created_at")
EXPECTED_COLUMNS_USER_ROLES=("user_id" "role_id" "created_at" "created_by")
EXPECTED_COLUMNS_SECURITY_AUDIT_LOG=("log_id" "user_id" "role_id" "changed_by" "changed_at" "activity_type")
EXPECTED_COLUMNS_USER_HISTORY_LOG=("log_id" "user_id" "changed_by" "changed_at" "field_name" "old_value" "new_value" "description")
EXPECTED_COLUMNS_EMPLOYEES=("employee_id" "first_name" "last_name" "email" "job_titel" "department" "employment_type" "employment_status" "hire_date" "start_date" "termination_date" "termination_reason" "retention_end_date" "created_at" "created_by" "last_updated_by" "last_updated_at")
EXPECTED_COLUMNS_PAYROLL=("payroll_id" "employee_id" "pay_period_start" "pay_period_end" "gross_salary" "total_deductions" "net_salary" "payment_date" "payment_status" "created_at" "last_updated_at")
EXPECTED_COLUMNS_SALARIES=("salary_id" "employee_id" "base_salary" "effective_date" "created_at" "last_updated_at")
EXPECTED_COLUMNS_PAYROLL_DEDUCTIONS=("deduction_id" "payroll_id" "deduction_type" "amount")
EXPECTED_COLUMNS_PAYMENT_DETAILS=("employee_id" "payment_method" "account_holder_name" "encrypted_bank_account" "created_at" "last_updated_at")
EXPECTED_COLUMNS_EMPLOYEE_BENEFITS=("benefit_id" "employee_id" "benefit_type" "start_date" "end_date" "amount")
EXPECTED_COLUMNS_USER_EMPLOYEE_LINK=("user_id" "employee_id" "created_at")

# Funktion zum Ausführen von Tests
run_test() {
    QUERY=$1
    TEST_NAME=$2
    RESULT=$(mysql -u$DB_USER -p$DB_PASS -D $DB_NAME -se "$QUERY")

    if [[ -z "$RESULT" ]]; then
        echo "[FAIL] $TEST_NAME" | tee -a $REPORT_FILE
    else
        echo "[PASS] $TEST_NAME" | tee -a $REPORT_FILE
    fi
}

# Prüfen, ob alle erwarteten Tabellen existieren
for TABLE in "${EXPECTED_TABLES[@]}"; do
    run_test "SHOW TABLES LIKE '$TABLE';" "Tabelle '$TABLE' existiert"
done

# Prüfen, ob jede Tabelle die erwarteten Spalten hat
check_columns() {
    TABLE=$1
    EXPECTED_COLUMNS=$2

    for COLUMN in "${!EXPECTED_COLUMNS[@]}"; do
        run_test "SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_NAME='$TABLE' AND COLUMN_NAME='$COLUMN';" \
            "Spalte '$COLUMN' in '$TABLE' vorhanden"
    done
}

check_columns "roles" "${EXPECTED_COLUMNS_ROLES[@]}"
check_columns "permissions" "${EXPECTED_COLUMNS_PERMISSIONS[@]}"
check_columns "users" "${EXPECTED_COLUMNS_USERS[@]}"
check_columns "role_permissions" "${EXPECTED_COLUMNS_ROLE_PERMISSIONS[@]}"
check_columns "user_roles" "${EXPECTED_COLUMNS_USER_ROLES[@]}"
check_columns "security_audit_log" "${EXPECTED_COLUMNS_SECURITY_AUDIT_LOG[@]}"
check_columns "user_history_log" "${EXPECTED_COLUMNS_USER_HISTORY_LOG[@]}"
check_columns "employees" "${EXPECTED_COLUMNS_EMPLOYEES[@]}"
check_columns "payroll" "${EXPECTED_COLUMNS_PAYROLL[@]}"
check_columns "salaries" "${EXPECTED_COLUMNS_SALARIES[@]}"
check_columns "payroll_deductions" "${EXPECTED_COLUMNS_PAYROLL_DEDUCTIONS[@]}"
check_columns "payment_details" "${EXPECTED_COLUMNS_PAYMENT_DETAILS[@]}"
check_columns "employee_benefits" "${EXPECTED_COLUMNS_EMPLOYEE_BENEFITS[@]}"
check_columns "user_employee_link" "${EXPECTED_COLUMNS_USER_EMPLOYEE_LINK[@]}"

echo "---------------------------------" >> $REPORT_FILE
echo "Tests abgeschlossen. Report gespeichert unter $REPORT_FILE."