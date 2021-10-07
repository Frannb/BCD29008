package DAO;

import entities.Calendario;
import db.ConnectionFactory;
import java.sql.*;

public abstract class CalendarioDAO {

    public static Calendario capturaCalendario(int ano, int semestre) {
        //conforme ano e semestre
        Calendario c = null;
        String sql = "SELECT * FROM CalendarioAcademico WHERE Ano = ? AND Semestre = ?";

        try (Connection conexao = ConnectionFactory.getDBConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setInt(1, ano);
            stmt.setInt(2, semestre);

            ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    c = new Calendario(rs.getInt("Ano"), rs.getInt("Semestre"),
                            rs.getDate("Inicio").toLocalDate(), rs.getDate("Fim").toLocalDate());
                }
             rs.close();
        } catch (SQLException ex) {
            System.err.println(ex.toString());
        }
        return c;
    }



}
