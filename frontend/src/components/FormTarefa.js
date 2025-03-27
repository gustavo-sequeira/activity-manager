import React, { useRef, useState } from "react";

import Form from "react-validation/build/form";
import Input from "react-validation/build/input";

import CheckButton from "react-validation/build/button";
import TarefaService from "../services/tarefa.service";


const required = (value) => {
  if (!value) {
    return (
      <div className="invalid-feedback d-block">
        Campo é obrigatório
      </div>
    );
  }
};

const vdescricao = (value) => {
  if (value.length < 3 || value.length > 20) {
    return (
      <div className="invalid-feedback d-block">
        O nome deve 3 a 20 caracteres.
      </div>
    );
  }
};

const FormTarefa = ({codigoUsuario}) => {
  const form = useRef();
  const checkBtn = useRef();

  const [codigousuario, setCodigousuario] = useState("");
  const [descricao, setDescricao] = useState("");
  const [successful, setSuccessful] = useState(false);
  const [message, setMessage] = useState("");

  const onChangDescricao = (e) => {
    const descricao = e.target.value;
    setDescricao(descricao);
  }; 

    const handleSalvar = (e) => {
      e.preventDefault();
  
      setMessage("");
      setSuccessful(false);
  
      form.current.validateAll();

      setCodigousuario(JSON.parse(localStorage.getItem("codigo")));

      if (checkBtn.current.context._errors.length === 0) {
        TarefaService.insert(codigousuario, descricao).then(
          (response) => {
           // setMessage(response.data.message);
            setMessage('Tarefa salva com sucesso');
            setSuccessful(true);
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
          }
        );
      }
    };   
 
  return (
    <>
    <div>
      <h2>Formulário de tarefas</h2>
    </div>
    <Form onSubmit={handleSalvar} ref={form}>
    {!successful && (
      <div>
        <div className="form-group">
          <label htmlFor="codigo">Codigo</label>
          <Input
            type="text"
            className="form-control"
            name="codigo"
            value={codigoUsuario} // mudar isso aqui
            disabled 
          />
        </div>

        <div className="form-group">
          <label htmlFor="descricao">Descrição</label>
          <Input
            type="text"
            className="form-control"
            name="descricao"
            value={descricao}
            onChange={onChangDescricao}
            validations={[required, vdescricao]}
          />
        </div>

        <div className="form-group">
          <button className="btn btn-primary btn-block">Salvar</button>
        </div>
      </div>
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
    <CheckButton style={{ display: "none" }} ref={checkBtn} />
  </Form>
  </>
  );
};

export default FormTarefa;
