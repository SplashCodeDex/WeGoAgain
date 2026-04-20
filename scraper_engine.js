// scraper_engine.js
// This script parses data from our sources and uploads it to Firestore.
// To run: npx -y node scraper_engine.js

import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc } from 'firebase/firestore';
import fs from 'fs';

// Replace with your actual firebase-applet-config.json content if importing fails
const configPath = './firebase-applet-config.json';
const firebaseConfig = JSON.parse(fs.readFileSync(configPath, 'utf-8'));

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app, firebaseConfig.firestoreDatabaseId);

// ---------------------------------------------------------
// Example Data Block (Simulated Reddit/Quora Extraction)
// ---------------------------------------------------------
const SEED_TRUTHS = [
  {
    title: "Start so small that your mind can't reject it",
    content: "Every long journey begins with a single step — but consistency begins with a tiny step.\n\nPeople fail because they start big. Big demands big willpower. And willpower is unreliable.\n\nExample:\nIf you want to read daily, don't start with 20 pages. Start with 2 pages. The goal isn't progress — the goal is identity.",
    category: "Actionable Tip",
    source: "Quora - Better Life_1",
    createdAt: Date.now()
  },
  {
    title: "Motivation is a myth. Environment is everything.",
    content: "Stop relying on motivation to get work done. Motivation is just an emotion, and like all emotions, it fades.\n\nInstead, design an environment where doing the right thing is the path of least resistance. \n\nDelete distraction apps, leave your running shoes by the bed, put a book on your pillow. Don't fight friction, remove it.",
    category: "Hard Truth",
    source: "Reddit - r/Productivity",
    createdAt: Date.now()
  },
  {
    title: "You are the average of your 5 habits, not just people.",
    content: "We often hear 'you are the average of the 5 people you spend the most time with.' But you are also the average of your 5 daily habits.\n\nYour habits dictate your identity. Look at what you do on a random Tuesday. That is who you are becoming.",
    category: "Philosophy",
    source: "Reddit - r/selfimprovement",
    createdAt: Date.now()
  }
];

// ---------------------------------------------------------
// Pipeline Push Engine
// ---------------------------------------------------------
async function runPipeline() {
  console.log("🚀 Initializing Master Data Pipeline...");
  
  for (const truth of SEED_TRUTHS) {
    try {
      const docRef = await addDoc(collection(db, "truths"), truth);
      console.log(`✅ Ingres Successful: ${truth.title} (ID: ${docRef.id})`);
    } catch (e) {
      console.error(`❌ Error adding document: `, e);
    }
  }

  console.log("🏁 Pipeline execution complete! We now own our data.");
  process.exit(0);
}

runPipeline();
