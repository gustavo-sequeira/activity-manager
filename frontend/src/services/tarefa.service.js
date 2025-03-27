import axios from "axios";

const API_URL = "http://localhost:9000/tarefa";

const insert = (codigo_usuario, descricao) => {
  return axios.post(API_URL , {
    codigo_usuario,
    descricao
  });
};


const TarefaService = {
    insert
}

export default TarefaService;
