require('dotenv').config();
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const path = require('path');

const app = express();
const PORT = process.env.FRONTEND_PORT || 8082;

// Proxy API requests to API server
app.use('/api', createProxyMiddleware({
  target: `http://localhost:${process.env.API_PORT || 3000}`,
  changeOrigin: true,
  pathRewrite: {
    '^/api': '' // Remove /api prefix when forwarding to backend
  }
}));

// Serve static frontend files
app.use(express.static(path.join(__dirname, '..', 'src')));

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '..', 'src', 'index.html'));
});

app.listen(PORT, '127.0.0.1', () => {
  console.log(`Frontend server listening on port ${PORT}`);
});
