import * as Notifications from "expo-notifications";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { Platform } from "react-native";

interface SessionNotification {
  id: string;
  title: string;
  startTime: string;
}

export const initializeNotifications = async () => {
  // Request permissions
  const { status: existingStatus } = await Notifications.getPermissionsAsync();
  let finalStatus = existingStatus;

  if (existingStatus !== "granted") {
    const { status } = await Notifications.requestPermissionsAsync();
    finalStatus = status;
  }

  if (finalStatus !== "granted") {
    return false;
  }

  // Configure notifications
  Notifications.setNotificationHandler({
    handleNotification: async () => ({
      shouldShowAlert: true,
      shouldPlaySound: true,
      shouldSetBadge: false,
    }),
  });

  return true;
};

export const scheduleSessionNotifications = async () => {
  try {
    // Clear any existing scheduled notifications
    await Notifications.cancelAllScheduledNotificationsAsync();

    // Get sessions from storage
    const sessionsData = await AsyncStorage.getItem("session-notifications");
    if (!sessionsData) return;

    let sessions: SessionNotification[];
    try {
      const decodedData = atob(sessionsData);
      sessions = JSON.parse(decodedData);
    } catch (parseError) {
      console.error("Parse error:", parseError);
      return;
    }
    const now = new Date();

    for (const session of sessions) {
      const sessionStartTime = new Date(session.startTime);
      const notificationTime = new Date(
        sessionStartTime.getTime() - 10 * 60 * 1000
      );

      const secondsUntilNotification = Math.floor(
        (notificationTime.getTime() - now.getTime()) / 1000
      );
      
      const triggerSeconds = secondsUntilNotification;

      // Schedule notification
      try {
        if (Platform.OS === "android") {
          await Notifications.setNotificationChannelAsync(
            "session-notifications",
            {
              name: "Session Notifications",
              importance: Notifications.AndroidImportance.HIGH,
            }
          );
        }
        
        if (triggerSeconds > 0) {
          await Notifications.scheduleNotificationAsync({
            content: {
              title: "WSO2 CON",
              body: `${session.title} starts in 10 minutes`,
              data: { sessionId: session.id },
            },
            trigger: {
              seconds: triggerSeconds,
              type: "timeInterval",
            } as Notifications.NotificationTriggerInput,
          });
        }
      } catch (scheduleError) {
        console.error("Error scheduling specific notification:", scheduleError);
      }
    }
  } catch (error) {
    console.error("Error scheduling notifications:", error);
  }
};