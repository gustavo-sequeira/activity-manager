import React, { useState, useRef } from "react";
import Form from "react-validation/build/form";
import Input from "react-validation/build/input";
import CheckButton from "react-validation/build/button";

import AuthService from "../services/auth.service";

const required = (value) => {
  if (!value) {
    return (
      <div className="invalid-feedback d-block">
        Campo é obrigatório
      </div>
    );
  }
};

const vnome = (value) => {
  if (value.length < 3 || value.length > 20) {
    return (
      <div className="invalid-feedback d-block">
        O nome deve 3 a 20 caracteres.
      </div>
    );
  }
};

const vlogin = (value) => {
  if (value.length < 3 || value.length > 20) {
    return (
      <div className="invalid-feedback d-block">
        O login deve 3 a 20 caracteres.
      </div>
    );
  }
};

const vsenha = (value) => {
  if (value.length < 6 || value.length > 40) {
    return (
      <div className="invalid-feedback d-block">
        A senha deve 6 a 40 caracteres.
      </div>
    );
  }
};

const Register = (props) => {
  const form = useRef();
  const checkBtn = useRef();

  const [nome, setNome] = useState("");
  const [login, setLogin] = useState("");
  const [senha, setSenha] = useState("");
  const [successful, setSuccessful] = useState(false);
  const [message, setMessage] = useState("");

  const onChangeNome = (e) => {
    const login = e.target.value;
    setNome(login);
  }; 

  const onChangeLogin = (e) => {
    const login = e.target.value;
    setLogin(login);
  };

  const onChangeSenha = (e) => {
    const senha = e.target.value;
    setSenha(senha);
  };

  const handleRegister = (e) => {
    e.preventDefault();

    setMessage("");
    setSuccessful(false);

    form.current.validateAll();

    if (checkBtn.current.context._errors.length === 0) {
      AuthService.register(nome, login, senha).then(
        (response) => {
         // setMessage(response.data.message);
          setMessage('Usuário cadastrado com sucesso');
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
    <div className="col-md-12">
      <div className="card card-container">
        <img
          src="//ssl.gstatic.com/accounts/ui/avatar_2x.png"
          alt="profile-img"
          className="profile-img-card"
        />

        <Form onSubmit={handleRegister} ref={form}>
          {!successful && (
            <div>
              <div className="form-group">
                <label htmlFor="nome">Nome</label>
                <Input
                  type="text"
                  className="form-control"
                  name="nome"
                  value={nome}
                  onChange={onChangeNome}
                  validations={[required, vnome]}
                />
              </div>

              <div className="form-group">
                <label htmlFor="login">Login</label>
                <Input
                  type="text"
                  className="form-control"
                  name="login"
                  value={login}
                  onChange={onChangeLogin}
                  validations={[required, vlogin]}
                />
              </div>

              <div className="form-group">
                <label htmlFor="senha">Senha</label>
                <Input
                  type="password"
                  className="form-control"
                  name="senha"
                  value={senha}
                  onChange={onChangeSenha}
                  validations={[required, vsenha]}
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
      </div>
    </div>
  );
};

export default Register;
