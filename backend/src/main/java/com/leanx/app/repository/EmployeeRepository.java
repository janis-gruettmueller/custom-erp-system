package main.java.com.leanx.app.repository;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import main.java.com.leanx.app.model.Employee;

public interface EmployeeRepository extends CrudRepository<Employee> {
    
    @Override
    void create(Employee employee) throws IllegalArgumentException, SQLException;

    @Override
    Employee read(Integer id) throws SQLException;

    @Override
    void update(Employee employee,  Map<String, Object> updates) throws IllegalArgumentException, SQLException;

    @Override
    void delete(Integer id) throws IllegalArgumentException, SQLException;

    @Override
    List<Employee> findAll() throws SQLException;
}
