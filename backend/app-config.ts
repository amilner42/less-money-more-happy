/// Module for app encapsulating app configuration.

/**
 * Config for the backend.
 */
export const APP_CONFIG = {
  "app": {
    "baseUrl": "http://lessmoneymorehappy.com",
    "secondsBeforeReloginNeeded": 1000 * 60 * 60 * 24 * 365 * 10,
    "expressSessionSecretKey": "some123456789secret123456789key",
    "isHttps": false,
    "port": 3000,
    "apiSuffix": "/api"
  },
  "db": {
    "url": "mongodb://localhost:27017/LessMoneyMoreHappy"
  }
}
