const express = require('express');
const app = express();
const port = 8080;

app.use(express.json());

app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') return res.sendStatus(200);
  next();
});

app.post('/api/write-recipe', (req, res, next) => {
  const curRecipe = req.body.recipe;
  const registers = req.body.writes.values();
  console.log(curRecipe);
  for (const value of registers) {
    console.log(value);
  }
  res.json({ ok: true, recipe: curRecipe, registers: req.body.writes.length });
});


app.listen(port, () => {
  console.log(`listening on port: ${port}...`);
});
