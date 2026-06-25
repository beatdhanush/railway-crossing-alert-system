importScripts(
  "https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js"
);

importScripts(
  "https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyAL-0ZoXa5lfxor94zwafCdv13kswEEeJs",
  authDomain: "railway-crossing-alert-system.firebaseapp.com",
  projectId: "railway-crossing-alert-system",
  storageBucket: "railway-crossing-alert-system.firebasestorage.app",
  messagingSenderId: "684747614293",
  appId: "1:684747614293:web:5f8cff19a8292bf8faccdc",
  measurementId: "G-CNND67X3GE",
});

const messaging = firebase.messaging();