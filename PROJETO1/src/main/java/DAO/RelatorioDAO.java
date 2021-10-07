package DAO;
import db.ConnectionFactory;
import entities.Calendario;
import entities.Emprestimo;
import entities.Equipamento;
import entities.Pessoa;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public abstract class RelatorioDAO {

    public static List<Emprestimo> emprestimosEmAndamento(Calendario c) {
        List<Emprestimo> Lemprestimo = new ArrayList<>();
        String sql = "SELECT * FROM Emprestimo NATURAL JOIN Emprestimo_Equipamento WHERE DataPrevisaoEntrega >= ? " +
                "AND DataPrevisaoEntrega <= ?";

        // Try-with-resources irá fechar automaticamente a conexão
        try (Connection conexao = ConnectionFactory.getDBConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setDate(1, Date.valueOf(LocalDate.now()));
            stmt.setDate(2, Date.valueOf(c.getFim()));

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Emprestimo e = new Emprestimo(
                        rs.getInt("idEmprestimo"),
                        rs.getInt("Matricula"),
                        rs.getInt("Patrimonio"),
                        rs.getInt("idAtividade"),
                        rs.getDate("DataEmprestimo").toLocalDate(),
                        rs.getDate("DataPrevisaoEntrega").toLocalDate());
                Lemprestimo.add(e);
            }
            rs.close();
        } catch (SQLException ex) {
            System.err.println(ex.toString());
        }
        return Lemprestimo;
    }

    public static List<Pessoa> alunosQueJaRealizaramEmprestimo() {
        List<Pessoa> Lpessoas = new ArrayList<>();

        String sql = "SELECT DISTINCT Matricula, Nome, Sobrenome FROM Aluno NATURAL JOIN Emprestimo";

        // Try-with-resources irá fechar automaticamente a conexão
        try (Connection conexao = ConnectionFactory.getDBConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Pessoa p = new Pessoa(
                        rs.getInt("Matricula"),
                        rs.getString("Nome"),
                        rs.getString("Sobrenome"));
                Lpessoas.add(p);
            }
            rs.close();

        } catch (SQLException ex) {
            System.err.println(ex.toString());
        }
        return Lpessoas;
    }

    public static List<Equipamento> equipamentoJaEmprestadoAluno(int matricula) {
        List<Equipamento> Lequipamento = new ArrayList<>();
        String sql = "SELECT Patrimonio, Nome FROM Emprestimo_Equipamento NATURAL JOIN Equipamento WHERE Matricula = ?";

        // Try-with-resources irá fechar automaticamente a conexão
        try (Connection conexao = ConnectionFactory.getDBConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, matricula);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Equipamento eq = new Equipamento(
                        rs.getString("Patrimonio"),
                        rs.getString("Nome"));
                Lequipamento.add(eq);
            }
            rs.close();
        } catch (SQLException ex) {
            System.err.println(ex.toString());
        }
        return Lequipamento;
    }

    public static List<Emprestimo> emprestadoEmAndamentoVencido() {
        List<Emprestimo> Lemprestimo = new ArrayList<>();
        String sql = "SELECT * FROM Emprestimo NATURAL JOIN Emprestimo_Equipamento WHERE DataPrevisaoEntrega <= NOW() AND DataDevolucao IS NULL";

        // Try-with-resources irá fechar automaticamente a conexão
        try (Connection conexao = ConnectionFactory.getDBConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Emprestimo e = new Emprestimo(
                        rs.getInt("idEmprestimo"),
                        rs.getInt("Matricula"),
                        rs.getInt("Patrimonio"),
                        rs.getInt("idAtividade"),
                        rs.getDate("DataEmprestimo").toLocalDate(),
                        rs.getDate("DataPrevisaoEntrega").toLocalDate());
                Lemprestimo.add(e);
            }
            rs.close();
        } catch (SQLException ex) {
            System.err.println(ex.toString());
        }
        return Lemprestimo;
    }
}
