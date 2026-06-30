const fs = require("fs");
const path = require("path");

const url = process.env.VITE_SUPABASE_URL || "";
const anonKey = process.env.VITE_SUPABASE_ANON_KEY || "";

const content = `window.VITE_SUPABASE_URL = ${JSON.stringify(url)};\nwindow.VITE_SUPABASE_ANON_KEY = ${JSON.stringify(anonKey)};\n\nwindow.VM_AGRO_SUPABASE_CONFIG = {\n  url: window.VITE_SUPABASE_URL,\n  anonKey: window.VITE_SUPABASE_ANON_KEY\n};\n`;

const targets = [
  path.join(__dirname, "..", "supabase-config.js"),
  path.join(__dirname, "..", "publicacao-hastaagro", "supabase-config.js")
];

for (const target of targets) {
  fs.writeFileSync(target, content, "utf8");
}

console.log("Supabase config generated.");
