package entities;

import java.time.LocalDate;

public class ManipulaData {
    //FIXME FUNCIONANDO
    public static LocalDate verificaData(Emprestimo e, Calendario c, int semestre) {
        LocalDate dataDefinida = null;
        Calendario cProx;
        if (e.getIdAtividade() == 1) {                        // Verifica se a atividade é de ensino
            if (LocalDate.now().isEqual(c.getFim())) {        // Verifica se a data atual é igual ao fim do semestre
                dataDefinida = c.getFim();                    //Define a data de entrega como de hoje
            } else if (LocalDate.now().plusDays(15).isAfter(c.getFim())) {
                dataDefinida = c.getFim();                    // Verifica se a data é após o final do semestre
            } else {
                dataDefinida = LocalDate.now().plusDays(15);  //Só atualiza a data de renovação
            }

        } else { //Caso a atividade não for de ensino
            if(semestre == 1){
                cProx = DAO.CalendarioDAO.capturaCalendario(LocalDate.now().getYear(), 2);
            }else {
                cProx = DAO.CalendarioDAO.capturaCalendario(LocalDate.now().getYear()+1, 1);
            }

            if (LocalDate.now().isEqual(c.getFim())) {
                // Se o emprestimo for realizado no ultimo dia do semestre a entrega
                // será para o primeiro dia do proximo semestre
                dataDefinida = cProx.getInicio();
            } else{
                dataDefinida = c.getFim();
            }
        }
        return dataDefinida;
    }



}
