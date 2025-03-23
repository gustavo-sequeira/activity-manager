import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "./Login";
import Tarefa from "./Tarefa";

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/tarefa/:codigo_usuario" element={<Tarefa />} />
      </Routes>
    </Router>
  );
};

export default App;