import { fileURLToPath, URL } from "node:url";

import { defineConfig } from "vitest/config";
import vue from "@vitejs/plugin-vue";
import { loadEnv } from "vite";


// https://vitejs.dev/config/
export default defineConfig(async ({ command, mode }) => {
  
  return {
    server: {
      proxy: {
        "/api": {
          target: process.env.VITE_BACKEND_URL, // dans le meilleur des mondes ça aurait suffit a setup le lien avec la backend
          changeOrigin: true,
          secure: false,
          rewrite: (path) => path.replace(/^\/api/, ""),
        }
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
