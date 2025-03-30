import React, { useEffect, useState } from "react";
import axios from "axios";
import { Routes, Route, Link } from "react-router-dom";
import FormTarefa from "./FormTarefa";

const API_URL = "http://localhost:9000/tarefa";

const Tarefa = () => {
  const [tarefas, setTarefas] = useState([]);
  const [successful, setSuccessful] = useState(false);
  const [message, setMessage] = useState("");

  useEffect(() => {

   // axios.get(API_URL + "/usuario/" + JSON.parse(localStorage.getItem("codigo")))
   axios.get(API_URL + "/usuario/" + JSON.parse(localStorage.getItem("codigo"))) 
      .then((response) => {
        if (Object.values(response.data).length > 1) {
          setTarefas(response.data)
        };
      },
        (error) => {
          const resMessage =
            (error.response &&
              error.response.data &&
              error.response.data.message) ||
            error.message ||
            error.toString();

          setMessage(resMessage);
          setSuccessful(false);
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
    {JSON.parse(localStorage.getItem("codigo")) ? (
      <>
        <h2>Lista de Tarefas</h2>
        <Link to="/create">Criar Nova Tarefa</Link>
        <ul>
          {tarefas.map(tarefa => (
            <li key={tarefa.codigo} style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
              {tarefa.descricao + " " + tarefa.codigo} -  {tarefa.codigo ? "✅" : "❌"}
              <Link to={"/edit/" + tarefa.codigo}>Editar</Link>
              <button onClick={() => excluirTarefa(tarefa.codigo)}>Excluir</button>
            </li>
          ))}
        </ul>

        <div className="container mt-3">
          <Routes>
          <Route exact path="/create" element={<FormTarefa />} />
          <Route exact path="/edit" element={<FormTarefa />} />
          </Routes>
        </div>
      </>
    ) : (
      <Link to="/home"></Link>
    )}
    {message && (
      <div className="form-group">
        <div
          className={
            successful ? "alert alert-success" : "alert alert-danger"
          }
          role="alert"
        >
          {message}
        </div>
      </div>
    )}
  </>);
}

export default Tarefa;
