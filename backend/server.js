const express = require("express");
const cors = require("cors");

const { initializeApp, cert } = require("firebase-admin/app");
const {
  getFirestore,
  FieldValue,
} = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

const serviceAccount = JSON.parse(
  process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON
);

initializeApp({
  credential: cert(serviceAccount),
});

const db = getFirestore();

const app = express();

app.use(cors());

app.use(express.json());

app.post("/sendGateAlert", async (req, res) => {
  try {
    const { gateId, status, track } = req.body;

    console.log("====================================");
    console.log("NEW GATE ALERT");
    console.log("Gate :", gateId);
    console.log("Status :", status);
    console.log("Track :", track);
    console.log("====================================");

    // ======================================
// COLLECT TOKENS FROM ALL USERS
// ======================================

const tokens = [];

async function collectTokens(collectionName) {

  const snapshot =
      await db.collection(collectionName).get();

  let count = 0;

  snapshot.forEach((doc) => {

    const data = doc.data();

    if (
      data.fcmToken &&
      data.fcmToken.trim() !== ""
    ) {

      tokens.push(data.fcmToken);
      count++;

      console.log(
        `${collectionName} -> ${doc.id}`
      );

    }

  });

  console.log(
    `${collectionName} tokens = ${count}`
  );

}

await collectTokens("admins");

await collectTokens("operators");

await collectTokens("employees");

// Remove duplicate tokens

const uniqueTokens = [...new Set(tokens)];

console.log(
  "TOTAL TOKENS :",
  uniqueTokens.length,
);

    if (uniqueTokens.length === 0) {
      return res.status(200).json({
        success: false,
        message: "No employee tokens found",
      });
    }

    const message = {
      tokens: uniqueTokens,

      notification: {
  title: "Gate Alert",
  body: `${gateId} is now ${status}`,
},

      android: {
        priority: "high",

        notification: {
          channelId: "railway_alerts",
          sound: "default",
          defaultSound: true,
          defaultVibrateTimings: true,
        },
      },

      data: {
        gateId: gateId,
        status: status,
        track: track,
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    const response =
      await getMessaging().sendEachForMulticast(
        message
      );

    console.log("==============================");
    console.log("SUCCESS :", response.successCount);
    console.log("FAILED  :", response.failureCount);
    console.log("==============================");

    if (response.failureCount > 0) {

  for (let i = 0; i < response.responses.length; i++) {

    const resp = response.responses[i];

    if (resp.success) continue;

    const failedToken = uniqueTokens[i];

    console.log("FAILED TOKEN :", failedToken);
    console.log(resp.error);

    const collections = [
      "admins",
      "operators",
      "employees",
    ];

    for (const collection of collections) {

      const snapshot =
          await db.collection(collection).get();

      for (const doc of snapshot.docs) {

        if (doc.data().fcmToken === failedToken) {

          console.log(
            `REMOVING INVALID TOKEN FROM ${collection}/${doc.id}`
          );

          await doc.ref.update({
            fcmToken: FieldValue.delete(),
          });

        }

      }

    }

  }

}

    return res.status(200).json({
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount,
    });

  } catch (e) {

    console.error(e);

    return res.status(500).json({
      success: false,
      error: e.message,
    });
  }
});

app.get("/", (req, res) => {
  res.send("Railway Crossing Alert API Running");
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(
    `SERVER RUNNING ON PORT ${PORT}`
  );
});