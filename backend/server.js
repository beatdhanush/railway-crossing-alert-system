const express = require("express");

const { initializeApp, cert } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

const serviceAccount = JSON.parse(
  process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON
);

initializeApp({
  credential: cert(serviceAccount),
});

const db = getFirestore();

const app = express();

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

    const snapshot = await db.collection("employees").get();

    const tokens = [];

    snapshot.forEach((doc) => {
      const data = doc.data();

      console.log("Employee :", data.employeeId);
      console.log("Tracks :", data.selectedTracks);

      const tracks = data.selectedTracks || [];

      if (
        tracks
          .map((t) => t.toLowerCase())
          .includes(track.toLowerCase()) &&
        data.fcmToken
      ) {
        console.log("MATCH FOUND :", data.employeeId);

        tokens.push(data.fcmToken);
      }
    });

    console.log("TOKENS :", tokens.length);

    if (tokens.length === 0) {
      return res.status(200).json({
        success: false,
        message: "No employee tokens found",
      });
    }

    const message = {
      tokens,

      notification: {
        title: `🚨 Gate Alert - ${gateId}`,
        body: `Gate is now ${status}`,
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
      response.responses.forEach((resp, index) => {
        if (!resp.success) {
          console.log(
            "FAILED TOKEN:",
            tokens[index]
          );
          console.log(resp.error);
        }
      });
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