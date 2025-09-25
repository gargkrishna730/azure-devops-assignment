const express = require('express');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.static('public'));
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hello World - Azure CI/CD Demo</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                color: white;
            }
            .container {
                text-align: center;
                background: rgba(255, 255, 255, 0.1);
                padding: 3rem;
                border-radius: 20px;
                backdrop-filter: blur(10px);
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
                border: 1px solid rgba(255, 255, 255, 0.18);
            }
            h1 {
                font-size: 3rem;
                margin-bottom: 1rem;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            }
            p {
                font-size: 1.2rem;
                margin-bottom: 2rem;
            }
            .info {
                background: rgba(255, 255, 255, 0.2);
                padding: 1rem;
                border-radius: 10px;
                margin-top: 2rem;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🌟 Hello World! 🌟</h1>
            <p>Welcome to the Azure CI/CD Pipeline Demo</p>
            <div class="info">
                <p><strong>Application:</strong> Node.js Express App</p>
                <p><strong>Deployment:</strong> Azure App Service</p>
                <p><strong>Pipeline:</strong> Azure DevOps</p>
                <p><strong>Infrastructure:</strong> Bicep Templates</p>
            </div>
            <p>🚀 Successfully deployed via Azure DevOps CI/CD Pipeline!</p>
        </div>
    </body>
    </html>
  `);
});

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    version: process.env.npm_package_version || '1.0.0'
  });
});

app.get('/api/info', (req, res) => {
  res.json({
    message: 'Hello from Azure App Service!',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
    nodeVersion: process.version
  });
});

// Start server
app.listen(port, () => {
  console.log(`🚀 Hello World app listening at http://localhost:${port}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`Node.js version: ${process.version}`);
});

module.exports = app;