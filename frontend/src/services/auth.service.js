import axios from "axios";

const API_URL = "http://localhost:9000/usuario";

const register = (nome, login, senha) => {
  return axios.post(API_URL , {
    nome,
    login,
    senha,
  });
};

const login = (login, senha) => {
  return axios
    .post(API_URL + "/logar", {
      login,
      senha,
    })
    .then((response) => {
      if (response.data.login) {
        localStorage.setItem("login", JSON.stringify(response.data.login));
        localStorage.setItem("codigo", JSON.stringify(response.data.codigo));
      }

      return response.data;
    });
};

const logout = () => {
  localStorage.removeItem("login");
  localStorage.removeItem("codigo");
  return;
};

const getCurrentLogin = () => {
  return JSON.parse(localStorage.getItem("login"));
};

const getCurrentCodigo = () => {
  return JSON.parse(localStorage.getItem("codigo"));
};

const AuthService = {
  register,
  login,
  logout,
  getCurrentLogin,
  getCurrentCodigo,
}

export default AuthService;
