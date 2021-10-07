package DAO;

import db.ConnectionFactory;
import entities.Emprestimo;
import java.time.LocalDate;
import java.sql.*;

public abstract class EmprestimoDAO {

    public static boolean efetuaEmprestimo(Emprestimo e) {
        boolean resultado = false;
        String sql = "INSERT INTO Emprestimo(Matricula, idAtividade," +
                " DataEmprestimo, DataPrevisaoEntrega) VALUES (?,?,?,?)";
        // Try-with-resources irá fechar automaticamente a conexão
        try (Connection conexao = ConnectionFactory.getDBConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setInt(1, e.getMatricula());
            stmt.setInt(2, e.getIdAtividade());
            stmt.setDate(3, Date.valueOf(e.getDataEmprestimo()));
            stmt.setDate(4, Date.valueOf(e.getDataPrevisaoEntrega()));
            stmt.execute();
            resultado = true;

        } catch (SQLException ex) {
            System.err.println(ex.toString());
        }
        return resultado;
    }

    public static boolean addEmprestimo(Emprestimo e, int patrimonio) {
        boolean resultado = false;
        String sql = "INSERT INTO Emprestimo_Equipamento(idEmprestimo, Matricula, Patrimonio) VALUES (?,?,?)";

        try (Connection conexao = ConnectionFactory.getDBConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setInt(1, e.getIdEmprestimo());
            stmt.setInt(2, e.getMatricula());
            stmt.setInt(3, patrimonio);

            resultado = stmt.execute();

        } catch (SQLException ex) {
            System.err.println(ex.toString());
        }
        return resultado;
    }


    //Funcionando
    public static boolean renovarEmprestimo(int idEmprestimo, LocalDate data, int qR) {
        boolean resultado = false;
        if (!verificaAtraso(idEmprestimo)) {
            String sql = "UPDATE Emprestimo SET dataPrevisaoEntrega = ?, dataEmprestimo = ? WHERE idEmprestimo = ?";
            try (Connection conexao = ConnectionFactory.getDBConnection();
                 PreparedStatement stmt = conexao.prepareStatement(sql)) {

                stmt.setDate(1, Date.valueOf(data));
                stmt.setDate(2, Date.valueOf(LocalDate.now()));
                stmt.setInt(3, idEmprestimo);

                resultado = stmt.execute();
                if (!resultado) {
                    resultado = incrementoRenovacao(idEmprestimo, qR);
                }

            } catch (SQLException ex) {
                System.err.println(ex.toString());
            }
        }
        return resultado;
    }
    //Funcionando
    public static boolean FinalizarEmprestimo(int idEmprestimo) {
        boolean resultado = false;

        String sql = "UPDATE Emprestimo SET dataDevolucao = ? WHERE idEmprestimo = ?";
        try (Connection conexao = ConnectionFactory.getDBConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setDate(1, Date.valueOf(LocalDate.now()));
            stmt.setInt(2, idEmprestimo);

            resultado = stmt.execute();

        } catch (SQLException ex) {
            System.err.println(ex.toString());
        }
        return resultado;
    }
    //Funcionando
    public static Emprestimo buscarEmprestimo(int idEmprestimo) {
        Emprestimo e = null;
        String sql = "SELECT * FROM Emprestimo NATURAL JOIN Emprestimo_Equipamento WHERE idEmprestimo = ?";

        try (Connection conexao = ConnectionFactory.getDBConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, idEmprestimo);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                e = new Emprestimo(rs.getInt("idEmprestimo"),
                        rs.getInt("Matricula"),
                        rs.getInt("Patrimonio"),
                        rs.getInt("idAtividade"),
                        rs.getDate("DataEmprestimo").toLocalDate(),
                        rs.getDate("DataPrevisaoEntrega").toLocalDate(),
                        rs.getInt("QuantidadeRenovacao"));

            }
            rs.close();

        } catch (SQLException ex) {
            System.err.println(ex.toString());
        }
        return e;
    }
    //Funcionando
    public static boolean incrementoRenovacao(int idEmprestimo, int quantR) {
        boolean resultado = false;

        String sql = "UPDATE Emprestimo SET QuantidadeRenovacao = ? WHERE idEmprestimo = ?";
        try (Connection conexao = ConnectionFactory.getDBConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, quantR);
            stmt.setInt(2, idEmprestimo);

            resultado = stmt.execute();

        } catch (SQLException ex) {
            System.err.println(ex.toString());
        }
        return resultado;
    }

    public static boolean verificaAtraso(int idEmprestimo) {
        boolean resultado = false;

        String sql = "SELECT * FROM Emprestimo NATURAL JOIN Emprestimo_Equipamento " +
                "WHERE NOW() >= DataPrevisaoEntrega AND DataDevolucao IS NULL AND idEmprestimo = ?";

        try (Connection conexao = ConnectionFactory.getDBConnection();
             PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, idEmprestimo);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                resultado = true;
            }
            rs.close();

        } catch (SQLException ex) {
            System.err.println(ex.toString());
        }
        return resultado;
    }

}
