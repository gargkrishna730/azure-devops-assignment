const request = require('supertest');
const app = require('./app');

describe('Hello World App Tests', () => {
  test('GET / should return HTML with Hello World', async () => {
    const response = await request(app)
      .get('/')
      .expect(200);
    
    expect(response.text).toContain('Hello World');
    expect(response.text).toContain('Azure CI/CD Pipeline Demo');
  });

  test('GET /health should return health status', async () => {
    const response = await request(app)
      .get('/health')
      .expect(200);
    
    expect(response.body.status).toBe('healthy');
    expect(response.body).toHaveProperty('timestamp');
    expect(response.body).toHaveProperty('uptime');
  });

  test('GET /api/info should return app info', async () => {
    const response = await request(app)
      .get('/api/info')
      .expect(200);
    
    expect(response.body.message).toBe('Hello from Azure App Service!');
    expect(response.body).toHaveProperty('timestamp');
    expect(response.body).toHaveProperty('nodeVersion');
  });
});
