module.exports = {
  platform: "github",
  repositories: ["speziato/homelab"],
  onboarding: false,
  requireConfig: "optional",
  username: "speziatorenovate[bot]",
  allowedCommands: [
    "^/config/renovate-maintenance\\.sh$",
  ],
  customEnvVariables: {
    MISE_DATA_DIR: "/var/cache/mise/data",
    MISE_CACHE_DIR: "/var/cache/mise/cache",
    MISE_STATE_DIR: "/var/cache/mise/state",
    MISE_TMP_DIR: "/tmp/mise",
    MISE_AUTO_INSTALL: "false",
  },
};
