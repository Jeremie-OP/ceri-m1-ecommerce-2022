// // dosn't work
module.exports = {
    devServer: {
    proxy: {
        "/api": {
          ws: true,
          changeOrigin: true,
          target: "http://localhostway:8888/"
        }
      }
    }
}