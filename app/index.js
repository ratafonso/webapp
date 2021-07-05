const express = require(`express`);
const mysql = require(`mysql`);
const app = express();
const port = 3000;
const redis = require('redis');

const con = mysql.createConnection({
  host: process.env.DBHOST,
  user: process.env.DBUSER,
  password: process.env.DBPASS,
  database: process.env.DBNAME
});

const DB_HOST = process.env.REDIS_PORT_6379_TCP_ADDR || '127.0.0.1';
const DB_PORT = process.env.REDIS_PORT_6379_TCP_PORT || 6379;

app.get("/", (req, res) => {

//Inicia a conexao com o Banco de Dados, se der erro, exibe mensagem de erro. Se o resultado de saída for 0, ele exibe a mensagem na tela;
con.connect((err) => {
  con.query(
    `SELECT msg FROM projestudo`,
      (err, result, fields) => {
        if (err) res.send(err);
        if (result) res.json({
          data: result[0].msg
      });
    });
  });
});

// Envia uma mensagem de log no console
app.listen(port, () => {
  console.log(`Running on port:${port}`);
});
