import { fileURLToPath, URL } from "node:url";

import { defineConfig } from "vitest/config";
import vue from "@vitejs/plugin-vue";
import { loadEnv } from "vite";


// https://vitejs.dev/config/
export default defineConfig(async ({ command, mode }) => {
  const env = loadEnv(mode, process.cwd());
  console.log("env", process.env.VITE_BACKEND_URL);  
  return {
    server: {
      proxy: {
        "/api": {
          target: process.env.VITE_BACKEND_URL || "http://localhost:3000",
          changeOrigin: true,
          secure: false,
          rewrite: (path) => path.replace(/^\/api/, ""),
        },
      },
      cors: false,
      headers: {
        "Access-Control-Allow-Origin": "*",
      },
    },
    plugins: [vue()],
    resolve: {
      alias: {
        "@": fileURLToPath(new URL("./src", import.meta.url)),
      },
    },
    test: {
      globals: true,
      environment: "happy-dom",
      deps: {
        external: [/src\/external/],
      },
    },
  };
});
