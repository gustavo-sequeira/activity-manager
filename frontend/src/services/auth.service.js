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
        localStorage.setItem("login", JSON.stringify(response.data));
      }

      return response.data;
    });
};

const logout = () => {
  localStorage.removeItem("user");
  return axios.post(API_URL + "signout").then((response) => {
    return response.data;
  });
};

const getCurrentUser = () => {
  return JSON.parse(localStorage.getItem("login"));
};

const AuthService = {
  register,
  login,
  logout,
  getCurrentUser,
}

export default AuthService;
