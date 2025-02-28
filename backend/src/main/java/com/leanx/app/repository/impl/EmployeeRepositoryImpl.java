package main.java.com.leanx.app.repository.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import main.java.com.leanx.app.model.Employee;
import main.java.com.leanx.app.repository.EmployeeRepository;

public class EmployeeRepositoryImpl implements EmployeeRepository {

    @Override
    public void create(Employee employee) throws IllegalArgumentException, SQLException {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'create'");
    }

    @Override
    public Employee read(Integer id) throws SQLException {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public void update(Employee employee, Map<String, Object> updates) throws IllegalArgumentException, SQLException {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'update'");
    }

    @Override
    public void delete(Integer id) throws IllegalArgumentException, SQLException {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'delete'");
    }

    @Override
    public List<Employee> findAll() throws SQLException {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'findAll'");
    }
    
}
