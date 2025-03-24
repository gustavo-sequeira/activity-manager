import axios from "axios";

const API_URL = "http://localhost:3000/";

const getPublicContent = () => {
  return axios.get(API_URL);
};

const getUserBoard = () => {
  return axios.get(API_URL + "/home");
};

const UserService = {
  getPublicContent,
  getUserBoard
}

export default UserService;
