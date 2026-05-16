importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyCu20dS4u2lwFhGukgLDMA8noDtEFYEaeE",
  authDomain: "modrik-1f0d3.firebaseapp.com",
  projectId: "modrik-1f0d3",
  storageBucket: "modrik-1f0d3.firebasestorage.app",
  messagingSenderId: "954028606901",
  appId: "1:954028606901:web:0fec35913785ba8222c5fc",
});

const messaging = firebase.messaging();