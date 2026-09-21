const { initializeApp, cert } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const fs = require("fs");

// 1. Cargamos el archivo de credenciales de forma segura
const serviceAccount = require("./credenciales.json");

// 2. Inicializamos Firebase Admin usando las funciones directas
initializeApp({
  credential: cert(serviceAccount)
});

const db = getFirestore();

// 3. Leemos el archivo JSON con los repuestos
const rawData = fs.readFileSync("repuestos.json", "utf-8");
const repuestos = JSON.parse(rawData);

async function subirDatos() {
  console.log(`🚀 Subiendo ${repuestos.length} repuestos a Firestore...`);

  for (const item of repuestos) {
    const id = item.id;
    delete item.id; // Borramos el ID del objeto para que no se guarde como campo

    // Guardamos el documento con su ID personalizado
    await db.collection("repuestos").doc(id).set(item);
    console.log(`  -> Subido: ${item.nombre} (ID: ${id})`);
  }

  console.log("✨ ¡Listo! Todos los repuestos están en Firebase sin duplicados.");
  process.exit(0);
}

subirDatos().catch((error) => {
  console.error("❌ Error al subir los datos:", error);
  process.exit(1);
});