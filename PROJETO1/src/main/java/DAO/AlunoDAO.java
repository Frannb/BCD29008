package DAO;

import db.ConnectionFactory;
import entities.Pessoa;
import java.sql.*;
import java.time.LocalDate;

public abstract class AlunoDAO {
    public final static boolean inserirAluno(Pessoa p) {
        boolean resultado = false;
        String sql = "INSERT INTO Aluno(Matricula, Nome, Sobrenome, DataNascimento) VALUES (?,?,?,?)";

        // Try-with-resources irá fechar automaticamente a conexão
        try (Connection conexao = ConnectionFactory.getDBConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setInt(1, p.getMatricula());
            stmt.setString(2, p.getNome());
            stmt.setString(3, p.getSobrenome());
            stmt.setDate(4, Date.valueOf(p.getDataNascimento()));

            resultado = stmt.execute();

        } catch (SQLException ex) {
            System.err.println(ex.toString());
        }
        return resultado;
    }

    /**
     * Procura o aluno no semestre e ano
     */
    public final static boolean procuraAluno(int matricula, int semestre){
        boolean resultado = false;

        String sql =  "SELECT * FROM Status WHERE Ano = ? AND Semestre = ? AND Matricula = ?";

        try (Connection conexao = ConnectionFactory.getDBConnection();
            PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setInt(1, LocalDate.now().getYear());
            stmt.setInt(2, semestre);
            stmt.setInt(3, matricula);

            resultado = stmt.execute();

        } catch (SQLException ex) {
            System.err.println(ex.toString());
        }
        return resultado;
    }
}