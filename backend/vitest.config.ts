import { defineConfig } from "vitest/config";

export default defineConfig({
  resolve: {
    alias: {
      "@": new URL("./src", import.meta.url).pathname,
    },
  },
  test: {
    include: ["tests/**/*.test.ts"],
    exclude: ["**/node_modules/**, **/.git/**"],
    globals: true,
    testTimeout: 10_000,
    globalSetup: ["./tests/setup/globalSetup.ts"],
    setupFiles: ["./tests/setup/setup.ts"],
    clearMocks: true,
    restoreMocks: true,
    // Run with single worker to ensure database operations don't conflict
    maxWorkers: 1,
    coverage: {
      provider: "v8",
      enabled: true,
    },
  },
});
