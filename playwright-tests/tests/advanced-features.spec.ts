import { test, expect } from '@playwright/test';

/**
 * Playwright Performance and Load Testing
 * 
 * These tests demonstrate advanced Playwright capabilities
 * for performance testing and load scenarios.
 */

test.describe('Performance Testing with Playwright', () => {
  test('should measure page load performance', async ({ page }) => {
    // Start performance timing
    await page.goto('/', { waitUntil: 'networkidle' });
    
    // Get performance metrics
    const performanceMetrics = await page.evaluate(() => {
      const navigation = performance.getEntriesByType('navigation')[0] as PerformanceNavigationTiming;
      return {
        domContentLoaded: navigation.domContentLoadedEventEnd - navigation.domContentLoadedEventStart,
        loadComplete: navigation.loadEventEnd - navigation.loadEventStart,
        firstPaint: performance.getEntriesByType('paint').find(entry => entry.name === 'first-paint')?.startTime,
        firstContentfulPaint: performance.getEntriesByType('paint').find(entry => entry.name === 'first-contentful-paint')?.startTime,
        totalLoadTime: navigation.loadEventEnd - navigation.fetchStart
      };
    });

    console.log('Performance Metrics:', performanceMetrics);
    
    // Assert performance thresholds
    expect(performanceMetrics.totalLoadTime).toBeLessThan(5000); // 5 seconds max
    expect(performanceMetrics.domContentLoaded).toBeLessThan(2000); // 2 seconds max
  });

  test('should handle concurrent user actions', async ({ browser }) => {
    // Create multiple pages to simulate concurrent users
    const contexts = await Promise.all([
      browser.newContext(),
      browser.newContext(),
      browser.newContext()
    ]);

    const pages = await Promise.all(contexts.map(context => context.newPage()));

    // Simulate concurrent login attempts
    const loginPromises = pages.map(async (page, index) => {
      await page.goto('/');
      await page.fill('input[data-testid="username-field"]', 'testuser');
      await page.fill('input[data-testid="password-field"]', 'password123');
      await page.click('button[data-testid="login-button"]');
      await page.waitForSelector('text=Employee Management');
      return `User ${index + 1} logged in successfully`;
    });

    const results = await Promise.all(loginPromises);
    console.log('Concurrent login results:', results);

    // Cleanup
    await Promise.all(contexts.map(context => context.close()));
  });
});

test.describe('Visual Regression Testing', () => {
  test('should capture login screen screenshot', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveScreenshot('login-screen.png');
  });

  test('should capture employee list screenshot', async ({ page }) => {
    await page.goto('/');
    
    // Login
    await page.fill('input[data-testid="username-field"]', 'testuser');
    await page.fill('input[data-testid="password-field"]', 'password123');
    await page.click('button[data-testid="login-button"]');
    
    // Navigate to employee list
    await page.waitForSelector('text=Employee Management');
    await page.click('text=Employee List');
    await page.waitForSelector('[data-testid="employee-list"]');
    
    await expect(page).toHaveScreenshot('employee-list.png');
  });

  test('should capture employee form screenshot', async ({ page }) => {
    await page.goto('/');
    
    // Login and navigate
    await page.fill('input[data-testid="username-field"]', 'testuser');
    await page.fill('input[data-testid="password-field"]', 'password123');
    await page.click('button[data-testid="login-button"]');
    await page.waitForSelector('text=Employee Management');
    await page.click('text=Employee List');
    await page.waitForSelector('[data-testid="employee-list"]');
    
    // Open add employee form
    await page.click('button[data-testid="add-employee-button"]');
    await page.waitForSelector('[data-testid="employee-form"]');
    
    await expect(page).toHaveScreenshot('employee-form.png');
  });
});

test.describe('Accessibility Testing', () => {
  test('should have proper ARIA labels', async ({ page }) => {
    await page.goto('/');
    
    // Check for proper ARIA labels on form elements
    const usernameField = page.locator('input[data-testid="username-field"]');
    await expect(usernameField).toHaveAttribute('aria-label', 'Username');
    
    const passwordField = page.locator('input[data-testid="password-field"]');
    await expect(passwordField).toHaveAttribute('aria-label', 'Password');
    
    const loginButton = page.locator('button[data-testid="login-button"]');
    await expect(loginButton).toHaveAttribute('aria-label', 'Login');
  });

  test('should be keyboard navigable', async ({ page }) => {
    await page.goto('/');
    
    // Test keyboard navigation
    await page.keyboard.press('Tab'); // Should focus username field
    await expect(page.locator('input[data-testid="username-field"]')).toBeFocused();
    
    await page.keyboard.press('Tab'); // Should focus password field
    await expect(page.locator('input[data-testid="password-field"]')).toBeFocused();
    
    await page.keyboard.press('Tab'); // Should focus login button
    await expect(page.locator('button[data-testid="login-button"]')).toBeFocused();
  });

  test('should have proper heading structure', async ({ page }) => {
    await page.goto('/');
    
    // Check for proper heading hierarchy
    const headings = await page.locator('h1, h2, h3, h4, h5, h6').allTextContents();
    expect(headings.length).toBeGreaterThan(0);
    
    // Should have a main heading
    await expect(page.locator('h1')).toContainText(['Login', 'Employee Management']);
  });
});

test.describe('Cross-Browser Compatibility', () => {
  ['chromium', 'firefox', 'webkit'].forEach(browserName => {
    test(`should work in ${browserName}`, async ({ browser }) => {
      // This test will run for each browser in the projects config
      const context = await browser.newContext();
      const page = await context.newPage();
      
      await page.goto('/');
      
      // Basic functionality test
      await expect(page.locator('text=Login')).toBeVisible();
      
      await page.fill('input[data-testid="username-field"]', 'testuser');
      await page.fill('input[data-testid="password-field"]', 'password123');
      await page.click('button[data-testid="login-button"]');
      
      await page.waitForSelector('text=Employee Management');
      await expect(page.locator('text=Employee Management')).toBeVisible();
      
      await context.close();
    });
  });
});

test.describe('Mobile Responsiveness', () => {
  test('should work on iPhone', async ({ browser }) => {
    const context = await browser.newContext({
      ...devices['iPhone 12'],
    });
    const page = await context.newPage();
    
    await page.goto('/');
    
    // Check mobile-specific elements
    await expect(page.locator('[data-testid="mobile-layout"]')).toBeVisible();
    
    // Test mobile navigation
    await page.click('[data-testid="mobile-menu-button"]');
    await expect(page.locator('[data-testid="mobile-nav-menu"]')).toBeVisible();
    
    await context.close();
  });

  test('should work on Android', async ({ browser }) => {
    const context = await browser.newContext({
      ...devices['Pixel 5'],
    });
    const page = await context.newPage();
    
    await page.goto('/');
    
    // Test touch interactions
    await page.tap('input[data-testid="username-field"]');
    await page.fill('input[data-testid="username-field"]', 'testuser');
    
    await page.tap('input[data-testid="password-field"]');
    await page.fill('input[data-testid="password-field"]', 'password123');
    
    await page.tap('button[data-testid="login-button"]');
    await page.waitForSelector('text=Employee Management');
    
    await context.close();
  });
});

/**
 * Advanced Playwright Features Demo
 * 
 * This section shows advanced Playwright capabilities that would be
 * complex to implement in Flutter testing, demonstrating both the
 * power and complexity of browser-based testing.
 */

test.describe('Advanced Playwright Features', () => {
  test('should intercept and modify network requests', async ({ page }) => {
    // Intercept API calls and modify responses
    await page.route('**/api/employees', async route => {
      const response = await route.fetch();
      const json = await response.json();
      
      // Modify response data
      json.data = json.data || [];
      json.data.push({
        id: 999,
        name: 'Playwright Injected Employee',
        email: 'playwright@test.com',
        phone: '+0000000000'
      });
      
      await route.fulfill({
        response,
        json: json
      });
    });

    await page.goto('/');
    await page.fill('input[data-testid="username-field"]', 'testuser');
    await page.fill('input[data-testid="password-field"]', 'password123');
    await page.click('button[data-testid="login-button"]');
    
    await page.waitForSelector('text=Employee Management');
    await page.click('text=Employee List');
    
    // Should see the injected employee
    await expect(page.locator('text=Playwright Injected Employee')).toBeVisible();
  });

  test('should test file downloads', async ({ page }) => {
    await page.goto('/');
    await page.fill('input[data-testid="username-field"]', 'testuser');
    await page.fill('input[data-testid="password-field"]', 'password123');
    await page.click('button[data-testid="login-button"]');
    
    await page.waitForSelector('text=Employee Management');
    await page.click('text=Employee List');
    
    // Start waiting for download before clicking
    const downloadPromise = page.waitForEvent('download');
    await page.click('button[data-testid="export-employees-button"]');
    const download = await downloadPromise;
    
    // Verify download
    expect(download.suggestedFilename()).toBe('employees.csv');
    
    // Save and verify file content
    const path = await download.path();
    expect(path).toBeTruthy();
  });

  test('should test drag and drop', async ({ page }) => {
    await page.goto('/');
    await page.fill('input[data-testid="username-field"]', 'testuser');
    await page.fill('input[data-testid="password-field"]', 'password123');
    await page.click('button[data-testid="login-button"]');
    
    await page.waitForSelector('text=Employee Management');
    await page.click('text=Employee List');
    
    // Test drag and drop for reordering employees
    const firstEmployee = page.locator('[data-testid="employee-item-1"]');
    const secondEmployee = page.locator('[data-testid="employee-item-2"]');
    
    await firstEmployee.dragTo(secondEmployee);
    
    // Verify order changed
    const employees = await page.locator('[data-testid^="employee-item-"]').allTextContents();
    expect(employees[0]).not.toBe(employees[1]);
  });

  test('should test geolocation', async ({ browser }) => {
    const context = await browser.newContext({
      geolocation: { latitude: 37.7749, longitude: -122.4194 }, // San Francisco
      permissions: ['geolocation'],
    });
    
    const page = await context.newPage();
    await page.goto('/');
    
    // Test location-based features
    await page.click('button[data-testid="use-location-button"]');
    
    const location = await page.evaluate(() => {
      return new Promise((resolve) => {
        navigator.geolocation.getCurrentPosition((position) => {
          resolve({
            latitude: position.coords.latitude,
            longitude: position.coords.longitude
          });
        });
      });
    });
    
    expect(location).toEqual({ latitude: 37.7749, longitude: -122.4194 });
    
    await context.close();
  });
});

import { devices } from '@playwright/test';