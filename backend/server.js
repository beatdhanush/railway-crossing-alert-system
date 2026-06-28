const express = require("express");

const {
  initializeApp,
  cert,
} = require("firebase-admin/app");

const {
  getFirestore,
} = require("firebase-admin/firestore");

const {
  getMessaging,
} = require("firebase-admin/messaging");

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
    const {
      gateId,
      status,
      track,
    } = req.body;

    console.log("================================");
    console.log("NEW GATE ALERT");
    console.log("Gate :", gateId);
    console.log("Status :", status);
    console.log("Track :", track);
    console.log("================================");

    const snapshot =
        await db.collection("employees").get();

    const tokens = [];

    snapshot.forEach((doc) => {

      const data = doc.data();

      console.log(
        "Employee :",
        data.employeeId,
      );

      const tracks =
          data.selectedTracks || [];

      if (
        tracks
          .map((t) => t.toLowerCase())
          .includes(track.toLowerCase()) &&
        data.fcmToken
      ) {
        console.log(
          "MATCH FOUND ->",
          data.employeeId,
        );

        tokens.push(data.fcmToken);
      }
    });

    console.log(
      "TOTAL TOKENS :",
      tokens.length,
    );

    if (tokens.length === 0) {
      return res.json({
        success: false,
        message: "No Tokens Found",
      });
    }

    const response =
        await getMessaging().sendEachForMulticast({

      tokens,

      notification: {
        title: `🚨 Gate ${gateId}`,
        body: `Gate is now ${status}`,
      },

      android: {

        priority: "high",

        notification: {

          channelId: "railway_alerts",

          priority: "max",

          visibility: "public",

          sound: "default",

          defaultSound: true,

          defaultVibrateTimings: true,

          notificationCount: 1,

          sticky: false,

          localOnly: false,

          defaultLightSettings: true,

          eventTimestamp: Date.now(),

          tag: `${gateId}`,

        },
      },

      data: {

        gateId,

        status,

        track,

        click_action:
            "FLUTTER_NOTIFICATION_CLICK",

      },
    });

    console.log("========================");
    console.log(response);
    console.log("========================");

    res.json({
      success: true,
      sent: response.successCount,
    });

  } catch (e) {

    console.log(e);

    res.status(500).json({
      error: e.message,
    });

  }
});

const PORT =
    process.env.PORT || 3000;

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`SERVER RUNNING ON PORT ${PORT}`);
});