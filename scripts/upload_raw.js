const fs = require('fs');
const http = require('http');
const path = require('path');

const filePath = path.join(__dirname, '..', 'employees_sample.xlsx');
if (!fs.existsSync(filePath)) {
  console.error('File not found:', filePath);
  process.exit(2);
}

const fileBuffer = fs.readFileSync(filePath);
const boundary = '----NodeFormBoundary' + Date.now().toString(16);
const CRLF = '\r\n';
const filename = path.basename(filePath);

const bodyStart = Buffer.from(`--${boundary}${CRLF}` +
  `Content-Disposition: form-data; name="file"; filename="${filename}"${CRLF}` +
  `Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet${CRLF}${CRLF}`
);
const bodyEnd = Buffer.from(`${CRLF}--${boundary}--${CRLF}`);
const contentLength = bodyStart.length + fileBuffer.length + bodyEnd.length;

const options = {
  hostname: '127.0.0.1',
  port: 3000,
  path: '/upload-employees',
  method: 'POST',
  headers: {
    'Content-Type': 'multipart/form-data; boundary=' + boundary,
    'Content-Length': contentLength
  },
};

const req = http.request(options, (res) => {
  let data = '';
  res.setEncoding('utf8');
  res.on('data', chunk => data += chunk);
  res.on('end', () => {
    console.log('STATUS', res.statusCode);
    try {
      const parsed = JSON.parse(data);
      console.log(JSON.stringify(parsed, null, 2));
    } catch (e) {
      console.log('RESPONSE (non-json):', data);
    }
  });
});

req.on('error', (e) => {
  console.error('REQUEST ERROR', e.message);
});

req.write(bodyStart);
req.write(fileBuffer);
req.write(bodyEnd);
req.end();
