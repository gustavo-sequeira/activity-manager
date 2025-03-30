import React, { useState, useEffect } from "react";
import { Routes, Route, Link } from "react-router-dom";
import "bootstrap/dist/css/bootstrap.min.css";
import "./App.css";

import AuthService from "./services/auth.service";

import Login from "./components/Login";
import Register from "./components/Register";
import Home from "./components/Home";
import Tarefa from "./components/Tarefa";
import FormTarefa from "./components/FormTarefa";

import EventBus from "./common/EventBus";

const App = () => {
  const [currentLogin, setCurrentLogin] = useState(undefined);

  useEffect(() => {
    const login = AuthService.getCurrentLogin();

    if (login) {
      setCurrentLogin(login);
    }

    EventBus.on("logout", () => {
      logOut();
    });

    return () => {
      EventBus.remove("logout");
    };
  }, []);

  const logOut = () => {
    AuthService.logout();
    setCurrentLogin(undefined);
  };

  return (
    <div>
      <nav className="navbar navbar-expand navbar-dark bg-dark">
        <Link to={"/"} className="navbar-brand">
          Pharmapele
        </Link>

        {currentLogin ? (
          <div className="navbar-nav ml-auto">
            <li className="nav-item">
              <Link to={"/tarefa"} className="nav-link">
                Tarefas
              </Link>
            </li>
            <li className="nav-item">
              <a href="/login" className="nav-link" onClick={logOut}>
                Sair
              </a>
            </li>
          </div>
        ) : (
          <div className="navbar-nav ml-auto">
            <li className="nav-item">
              <Link to={"/login"} className="nav-link">
                Entrar
              </Link>
            </li>

            <li className="nav-item">
              <Link to={"/register"} className="nav-link">
                Registrar
              </Link>
            </li>
          </div>
        )}
      </nav>

      <div className="container mt-3">
        <Routes>
        <Route exact path="/" element={<Home />} />
          <Route exact path="/login" element={<Login />} />
          <Route exact path="/register" element={<Register />} />
          <Route exact path="/tarefa" element={<Tarefa />} />
          <Route exact path="/create" element={<FormTarefa />} />
          <Route exact path="/edit/:codigoTarefa" element={<FormTarefa />} />
        </Routes>
      </div>

      {/* <AuthVerify logOut={logOut}/> */}
    </div>
  );
};

export default App;
