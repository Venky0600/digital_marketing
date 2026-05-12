const admin = require('firebase-admin');

// Ensure you have a serviceAccountKey.json in the root directory (or use ENV vars)
// Since this is a test/development environment, we'll initialize without a cert if not found,
// but provide the structure so it's production-ready.

let initialized = false;

try {
  // If FIREBASE_SERVICE_ACCOUNT is provided in .env as a base64 or JSON string, use it.
  if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
    initialized = true;
    console.log('Firebase Admin initialized.');
  } else {
    console.warn('FIREBASE_SERVICE_ACCOUNT not set in .env. Push notifications will be mocked.');
  }
} catch (error) {
  console.error('Failed to initialize Firebase Admin:', error.message);
}

const sendPushNotification = async (tokens, title, body, data = {}) => {
  if (!initialized) {
    console.log(`[MOCK PUSH] To: ${tokens}, Title: ${title}, Body: ${body}`);
    return;
  }

  const message = {
    notification: { title, body },
    data,
    tokens: Array.isArray(tokens) ? tokens : [tokens],
  };

  try {
    const response = await admin.messaging().sendMulticast(message);
    console.log(response.successCount + ' messages were sent successfully');
  } catch (error) {
    console.error('Error sending push notification:', error);
  }
};

module.exports = { sendPushNotification };
