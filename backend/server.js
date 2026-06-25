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

    console.log(
      "Gate Alert Request Received",
    );

    const employeesSnapshot =
      await db
        .collection("employees")
        .get();

    const tokens = [];

    employeesSnapshot.forEach((doc) => {

  const data = doc.data();

  console.log("EMPLOYEE:", data.employeeId);
  console.log("TRACKS:", data.selectedTracks);
  console.log("TOKEN:", data.fcmToken);
  console.log("REQUEST TRACK:", track);

  const selectedTracks =
      data.selectedTracks || [];

  if (
  selectedTracks
      .map(t => t.toLowerCase())
      .includes(track.toLowerCase()) &&
  data.fcmToken
) {

  console.log("MATCH FOUND");

  tokens.push(data.fcmToken);
}
});

    console.log(
      "Tokens Found:",
      tokens.length,
    );

    if (tokens.length === 0) {
      return res.json({
        success: false,
        message:
          "No employee tokens found",
      });
    }

    const response =
      await getMessaging()
        .sendEachForMulticast({
          tokens: tokens,

          notification: {
            title:
              `Gate Alert - ${gateId}`,

            body:
              `Gate is now ${status}`,
          },
        });

    console.log(response);

    res.json({
      success: true,
      sent:
        response.successCount,
    });

  } catch (error) {

    console.error(error);

    res.status(500).json({
      error: error.message,
    });
  }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`SERVER RUNNING ON PORT ${PORT}`);
});
