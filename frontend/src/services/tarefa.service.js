import axios from "axios";

const API_URL = "http://localhost:9000/tarefa";

const insert = (codigousuario, descricao) => {
  return axios.post(API_URL , {codigousuario, descricao, });
};

const TarefaService = {
    insert
}

export default TarefaService;
