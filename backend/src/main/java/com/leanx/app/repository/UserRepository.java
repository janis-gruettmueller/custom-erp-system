package main.java.com.leanx.app.repository;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import main.java.com.leanx.app.model.User;

public interface UserRepository extends CrudRepository<User> {

    @Override
    void create(User user) throws IllegalArgumentException, SQLException;

    @Override
    User read(Integer id) throws SQLException;

    @Override
    void update(User user,  Map<String, Object> updates) throws IllegalArgumentException, SQLException;

    @Override
    void delete(Integer id) throws IllegalArgumentException, SQLException;

    @Override
    List<User> findAll() throws SQLException;
}
