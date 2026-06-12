const express = require('express');
const app = express();
const port = 8080;
const ROBOT_IP = '192.168.1.99';
const fs = require('fs').promises;
const SAVE_FILE = 'C:\\Users\\SpartaProg\\FanucPrograms\\gateway\\recipes.json';

app.use(express.json());

app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') return res.sendStatus(200);
  next();
});

app.post('/api/write-recipe', async (req, res, next) => {
  const curRecipe = req.body.recipe;
  const registers = req.body.writes;
  try {
    await writeRegisters(registers);
    res.json({ ok: true, recipe: curRecipe, registers: req.body.writes.length });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/save', async (req, res) => {
  // const recipe_base = (req.body.recipe * 37) + 140;
  // const registers = req.body.writes;
  // const data = [];
  // let set_active;
  
  // for (let i = 0; i < 20; i++)
  // {
  //   set_active = new Set();
  //   for (const R in req.body[i])
  //   {
  //     if (R.val == 1 && ((R.reg - 140) % 37) != 0)
  //       set_active.add((R.reg - 140) % 37);
  //   }
  //   data.push({recipe: i + 1, rcp_holes: [...set_active]});
  // }
  const data = req.body;
  const text = JSON.stringify(data);
  try{
    await fs.writeFile(SAVE_FILE, text);
    res.json({ ok: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/load', async (req, res) => {
  try {
    const text = await fs.readFile(SAVE_FILE, 'utf8');
    res.json(JSON.parse(text));
  } catch (error) {
    const empty_arr = Array.from({ length: 20 }, (_, i) => ({ recipe: i + 1, rcp_holes: [] }));
    res.json(empty_arr);
  }
});

app.listen(port, () => {
  console.log(`listening on port: ${port}...`);
});

async function writeRegisters(writes) {
  for (const w of writes) {
    const url = `http://${ROBOT_IP}/karel/ComSet?sValue=${w.val}&sIndx=${w.reg}&sRealFlag=-1&sFc=2`;
    console.log(`R[${w.reg}] = ${w.val}`);
    await fetch(url);
  }
}