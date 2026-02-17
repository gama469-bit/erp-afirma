require('dotenv').config();
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.FRONTEND_PORT || 8082;

console.log('[frontend] 🚀 Starting frontend server...');

// ⚠️ IMPORTANT: Order matters! Specific routes BEFORE general static middleware

// Serve uploaded files (CVs, etc.) - MUST be before general static files
const uploadsPath = path.join(__dirname, '..', 'public', 'uploads');
console.log('[frontend] 📁 Uploads path:', uploadsPath);
console.log('[frontend] 📁 Uploads path exists?', fs.existsSync(uploadsPath));

app.use('/uploads', express.static(uploadsPath, {
  dotfiles: 'allow',
  index: false
}));

console.log('[frontend] ✅ /uploads middleware configured');

// Proxy API requests to API server
app.use('/api', createProxyMiddleware({
  target: `http://localhost:${process.env.API_PORT || 3000}`,
  changeOrigin: true,
  pathRewrite: {
    '^/api': '' // Remove /api prefix when forwarding to backend
  }
}));

// Serve static frontend files (AFTER specific routes)
app.use(express.static(path.join(__dirname, '..', 'src')));

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '..', 'src', 'index.html'));
});

// Debug endpoint to list uploaded files
app.get('/api/debug/uploads', (req, res) => {
  try {
    const uploadsDir = path.join(__dirname, '..', 'public', 'uploads', 'cvs');
    const files = fs.readdirSync(uploadsDir);
    res.json({
      uploadsDir,
      exists: fs.existsSync(uploadsDir),
      files: files
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, '127.0.0.1', () => {
  console.log(`[frontend] ✅ Frontend server listening on http://localhost:${PORT}`);
  console.log(`[frontend] 📁 Static files from: ${path.join(__dirname, '..', 'src')}`);
  console.log(`[frontend] 📁 Uploads from: ${uploadsPath}`);
});
