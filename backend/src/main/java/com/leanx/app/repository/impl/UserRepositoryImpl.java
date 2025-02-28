package main.java.com.leanx.app.repository.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import main.java.com.leanx.app.model.User;
import main.java.com.leanx.app.repository.UserRepository;

public class UserRepositoryImpl implements UserRepository  {

    @Override
    public void create(User user) throws IllegalArgumentException, SQLException {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'create'");
    }

    @Override
    public User read(Integer id) throws SQLException {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public void update(User user, Map<String, Object> updates) throws IllegalArgumentException, SQLException {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'update'");
    }

    @Override
    public void delete(Integer id) throws IllegalArgumentException, SQLException {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'delete'");
    }

    @Override
    public List<User> findAll() throws SQLException {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'findAll'");
    }
    
}
