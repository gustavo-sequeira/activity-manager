import React, { useEffect, useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";


const API_URL = "http://localhost:9000/tarefa";

const FormTarefa = () => {
  const [descricao, setDescricao] = useState("");
  const navigate = useNavigate();
  const { id } = 1 



  useEffect(() => {
    if (id = 1) {
      return axios.get(API_URL+"/usuario/1").then((response) => {
        setDescricao(response.data.descricao);
      });
    }
  }, [id]);

  const handleSubmit = (e) => {
    e.preventDefault();
    const taskData = { descricao };

    if (id=1) {
      axios.put(API_URL+"/${id}", taskData).then(() => {
        navigate("/");
      });
    } else {
      axios.post(API_URL, taskData).then(() => {
        navigate("/");
      });
    }
  };

  return (
    <div>
      <h2>{id ? "Editar Tarefa" : "Criar Nova Tarefa"}</h2>
      <form onSubmit={handleSubmit}>
        <input 
          type="text" 
          value={descricao} 
          onChange={(e) => setDescricao(e.target.value)} 
          placeholder="Título da tarefa" 
          required 
        />
        
        <button type="submit">Salvar</button>
      </form>
    </div>
  );
};

export default FormTarefa;
