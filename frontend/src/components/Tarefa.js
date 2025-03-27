import React, { useEffect, useState } from "react";
import axios from "axios";
import { Routes, Route, Link } from "react-router-dom";
import FormTarefa from "./FormTarefa";

const API_URL = "http://localhost:9000/tarefa";

const Tarefa = () => {
  const [tarefas, setTarefas] = useState([]);


  useEffect(() => {
    axios.get(API_URL + "/usuario/1").then((response) => {
      setTarefas(response.data);
    });
  }, []);

  const excluirTarefa = (id) => {
    console.log(API_URL + "/" + id);
    return axios.delete(API_URL + "/" + id)
      .then(() => {
        setTarefas(tarefas.filter(tarefa => tarefa.codigo !== id));
      })
      .catch(function (erro) {
        console.log('Erro:', erro.message)//se houver um erro, a função catch() é executada
      });
  };

  return (<>
    <h2>Lista de Tarefas</h2>
    <Link to="/create">Criar Nova Tarefa</Link>
    <ul>
      {tarefas.map(tarefa => (
        <li key={tarefa.codigo} style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
          {tarefa.descricao + " " + tarefa.codigo} -  {tarefa.codigo ? "✅" : "❌"}
          <Link to={API_URL + "/" + tarefa.codigo}>Editar</Link>
          <button onClick={() => excluirTarefa(tarefa.codigo)}>Excluir</button>
        </li>
      ))}
    </ul>

    <div className="container mt-3">
      <Routes>
        <Route exact path="/create" element={<FormTarefa />} />
      </Routes>
    </div>
  </>);
}

export default Tarefa;
