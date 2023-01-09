// // dosn't work
module.exports = {
    devServer: {
    proxy: {
        "/api": {
          ws: true,
          changeOrigin: true,
          target: process.env.VITE_BACKEND_URL           
        }
      }
    }
}