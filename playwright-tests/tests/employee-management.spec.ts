import { test, expect, Page } from '@playwright/test';

/**
 * Playwright E2E Tests for Flutter Employee Management App
 * 
 * This file demonstrates how Playwright would test the same functionality
 * that our Flutter testing framework covers. It shows the complexity 
 * difference between Flutter's unified testing approach and traditional 
 * browser-only E2E testing.
 */

class EmployeeManagementApp {
  private page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  // Authentication Methods
  async goto() {
    await this.page.goto('/');
  }

  async login(username: string, password: string) {
    // Wait for login form to be visible
    await this.page.waitForSelector('input[data-testid="username-field"]', { timeout: 30000 });
    
    // Fill login form
    await this.page.fill('input[data-testid="username-field"]', username);
    await this.page.fill('input[data-testid="password-field"]', password);
    
    // Click login button
    await this.page.click('button[data-testid="login-button"]');
    
    // Wait for successful login (home screen)
    await this.page.waitForSelector('text=Employee Management', { timeout: 15000 });
  }

  async logout() {
    await this.page.click('button[data-testid="logout-button"]');
    await this.page.waitForSelector('text=Login');
  }

  // Employee Management Methods
  async navigateToEmployeeList() {
    await this.page.click('text=Employee List');
    await this.page.waitForSelector('[data-testid="employee-list"]');
  }

  async addEmployee(name: string, email: string, phone: string) {
    await this.page.click('button[data-testid="add-employee-button"]');
    await this.page.waitForSelector('[data-testid="employee-form"]');
    
    await this.page.fill('input[data-testid="name-field"]', name);
    await this.page.fill('input[data-testid="email-field"]', email);
    await this.page.fill('input[data-testid="phone-field"]', phone);
    
    await this.page.click('button[data-testid="save-employee-button"]');
    await this.page.waitForSelector(`text=${name}`);
  }

  async editEmployee(employeeId: string, newName: string) {
    await this.page.click(`button[data-testid="edit-employee-${employeeId}"]`);
    await this.page.waitForSelector('[data-testid="employee-form"]');
    
    await this.page.fill('input[data-testid="name-field"]', newName);
    await this.page.click('button[data-testid="save-employee-button"]');
    
    await this.page.waitForSelector(`text=${newName}`);
  }

  async deleteEmployee(employeeId: string) {
    await this.page.click(`button[data-testid="delete-employee-${employeeId}"]`);
    await this.page.click('button[data-testid="confirm-delete"]');
    
    // Wait for employee to be removed from list
    await this.page.waitForFunction(
      (id) => !document.querySelector(`[data-testid="employee-item-${id}"]`),
      employeeId
    );
  }

  async searchEmployee(searchTerm: string) {
    await this.page.fill('input[data-testid="search-field"]', searchTerm);
    await this.page.waitForTimeout(1000); // Wait for search debounce
  }

  // Photo Upload Methods
  async uploadEmployeePhoto(employeeId: string, photoPath: string) {
    await this.page.click(`button[data-testid="edit-employee-${employeeId}"]`);
    await this.page.waitForSelector('[data-testid="employee-form"]');
    
    // Handle file upload
    const fileInput = this.page.locator('input[type="file"]');
    await fileInput.setInputFiles(photoPath);
    
    await this.page.click('button[data-testid="save-employee-button"]');
    
    // Verify photo was uploaded
    await this.page.waitForSelector(`img[data-testid="employee-photo-${employeeId}"]`);
  }

  // Validation Methods
  async expectEmployeeInList(name: string) {
    await expect(this.page.locator(`text=${name}`)).toBeVisible();
  }

  async expectEmployeeNotInList(name: string) {
    await expect(this.page.locator(`text=${name}`)).not.toBeVisible();
  }

  async expectValidationError(message: string) {
    await expect(this.page.locator(`text=${message}`)).toBeVisible();
  }
}

test.describe('Employee Management App - Playwright E2E Tests', () => {
  let app: EmployeeManagementApp;

  test.beforeEach(async ({ page }) => {
    app = new EmployeeManagementApp(page);
    await app.goto();
  });

  test.describe('Authentication Flow', () => {
    test('should display login screen on app start', async ({ page }) => {
      await expect(page.locator('text=Login')).toBeVisible();
      await expect(page.locator('input[data-testid="username-field"]')).toBeVisible();
      await expect(page.locator('input[data-testid="password-field"]')).toBeVisible();
    });

    test('should login with valid credentials', async ({ page }) => {
      await app.login('testuser', 'password123');
      await expect(page.locator('text=Employee Management')).toBeVisible();
    });

    test('should show error with invalid credentials', async ({ page }) => {
      await app.login('invalid', 'invalid');
      await app.expectValidationError('Invalid credentials');
    });

    test('should logout successfully', async ({ page }) => {
      await app.login('testuser', 'password123');
      await app.logout();
      await expect(page.locator('text=Login')).toBeVisible();
    });
  });

  test.describe('Employee CRUD Operations', () => {
    test.beforeEach(async ({ page }) => {
      await app.login('testuser', 'password123');
      await app.navigateToEmployeeList();
    });

    test('should display employee list', async ({ page }) => {
      await expect(page.locator('[data-testid="employee-list"]')).toBeVisible();
    });

    test('should add new employee', async ({ page }) => {
      const employeeName = 'John Playwright';
      const employeeEmail = 'john.playwright@test.com';
      const employeePhone = '+1234567890';

      await app.addEmployee(employeeName, employeeEmail, employeePhone);
      await app.expectEmployeeInList(employeeName);
    });

    test('should edit existing employee', async ({ page }) => {
      // First add an employee
      await app.addEmployee('Edit Test User', 'edit@test.com', '+1111111111');
      
      // Then edit it (assuming we can get the employee ID)
      const newName = 'Edited Test User';
      await app.editEmployee('1', newName);
      await app.expectEmployeeInList(newName);
    });

    test('should delete employee', async ({ page }) => {
      // First add an employee
      const employeeName = 'Delete Test User';
      await app.addEmployee(employeeName, 'delete@test.com', '+2222222222');
      
      // Then delete it
      await app.deleteEmployee('1');
      await app.expectEmployeeNotInList(employeeName);
    });

    test('should search employees', async ({ page }) => {
      // Add some test employees
      await app.addEmployee('Search User 1', 'search1@test.com', '+3333333333');
      await app.addEmployee('Search User 2', 'search2@test.com', '+4444444444');
      await app.addEmployee('Different Name', 'different@test.com', '+5555555555');

      // Search for specific term
      await app.searchEmployee('Search User');
      
      // Should show matching employees
      await app.expectEmployeeInList('Search User 1');
      await app.expectEmployeeInList('Search User 2');
      await app.expectEmployeeNotInList('Different Name');
    });
  });

  test.describe('Form Validation', () => {
    test.beforeEach(async ({ page }) => {
      await app.login('testuser', 'password123');
      await app.navigateToEmployeeList();
    });

    test('should validate required fields', async ({ page }) => {
      await page.click('button[data-testid="add-employee-button"]');
      await page.click('button[data-testid="save-employee-button"]');
      
      await app.expectValidationError('Name is required');
      await app.expectValidationError('Email is required');
    });

    test('should validate email format', async ({ page }) => {
      await page.click('button[data-testid="add-employee-button"]');
      await page.fill('input[data-testid="name-field"]', 'Test User');
      await page.fill('input[data-testid="email-field"]', 'invalid-email');
      await page.click('button[data-testid="save-employee-button"]');
      
      await app.expectValidationError('Please enter a valid email');
    });

    test('should validate phone number format', async ({ page }) => {
      await page.click('button[data-testid="add-employee-button"]');
      await page.fill('input[data-testid="name-field"]', 'Test User');
      await page.fill('input[data-testid="email-field"]', 'test@example.com');
      await page.fill('input[data-testid="phone-field"]', 'invalid-phone');
      await page.click('button[data-testid="save-employee-button"]');
      
      await app.expectValidationError('Please enter a valid phone number');
    });
  });

  test.describe('Photo Upload', () => {
    test.beforeEach(async ({ page }) => {
      await app.login('testuser', 'password123');
      await app.navigateToEmployeeList();
    });

    test('should upload employee photo', async ({ page }) => {
      // Add employee first
      await app.addEmployee('Photo Test User', 'photo@test.com', '+6666666666');
      
      // Create a test image file
      const testImagePath = 'test-files/test-image.jpg';
      
      // Upload photo
      await app.uploadEmployeePhoto('1', testImagePath);
      
      // Verify photo is displayed
      await expect(page.locator('img[data-testid="employee-photo-1"]')).toBeVisible();
    });

    test('should validate photo file type', async ({ page }) => {
      await app.addEmployee('Photo Validation Test', 'photoval@test.com', '+7777777777');
      
      await page.click('button[data-testid="edit-employee-1"]');
      
      // Try to upload invalid file type
      const fileInput = page.locator('input[type="file"]');
      await fileInput.setInputFiles('test-files/test-document.txt');
      
      await app.expectValidationError('Please select a valid image file');
    });
  });

  test.describe('Responsive Design', () => {
    test('should work on mobile viewport', async ({ page }) => {
      // Set mobile viewport
      await page.setViewportSize({ width: 375, height: 667 });
      
      await app.login('testuser', 'password123');
      
      // Check if mobile navigation works
      await expect(page.locator('[data-testid="mobile-menu-button"]')).toBeVisible();
      await page.click('[data-testid="mobile-menu-button"]');
      await expect(page.locator('[data-testid="mobile-nav-menu"]')).toBeVisible();
    });

    test('should work on tablet viewport', async ({ page }) => {
      // Set tablet viewport
      await page.setViewportSize({ width: 768, height: 1024 });
      
      await app.login('testuser', 'password123');
      await app.navigateToEmployeeList();
      
      // Verify layout adapts to tablet
      await expect(page.locator('[data-testid="employee-grid"]')).toHaveClass(/tablet-layout/);
    });
  });

  test.describe('Performance Tests', () => {
    test('should load app within acceptable time', async ({ page }) => {
      const startTime = Date.now();
      await app.goto();
      await page.waitForSelector('text=Login');
      const loadTime = Date.now() - startTime;
      
      // Should load within 5 seconds
      expect(loadTime).toBeLessThan(5000);
    });

    test('should handle large employee lists', async ({ page }) => {
      await app.login('testuser', 'password123');
      await app.navigateToEmployeeList();
      
      // Add many employees and check performance
      for (let i = 0; i < 50; i++) {
        await app.addEmployee(`Employee ${i}`, `employee${i}@test.com`, `+123456${i.toString().padStart(4, '0')}`);
      }
      
      // List should still be responsive
      const startTime = Date.now();
      await app.searchEmployee('Employee 25');
      const searchTime = Date.now() - startTime;
      
      expect(searchTime).toBeLessThan(2000); // Search should complete within 2 seconds
    });
  });

  test.describe('Error Handling', () => {
    test('should handle network errors gracefully', async ({ page }) => {
      await app.login('testuser', 'password123');
      
      // Simulate network failure
      await page.route('**/api/**', route => route.abort());
      
      await app.navigateToEmployeeList();
      await page.click('button[data-testid="add-employee-button"]');
      await app.addEmployee('Network Test', 'network@test.com', '+8888888888');
      
      await app.expectValidationError('Network error. Please try again.');
    });

    test('should handle server errors', async ({ page }) => {
      await app.login('testuser', 'password123');
      
      // Simulate server error
      await page.route('**/api/employees', route => 
        route.fulfill({ status: 500, body: 'Internal Server Error' })
      );
      
      await app.navigateToEmployeeList();
      await app.expectValidationError('Server error. Please try again later.');
    });
  });
});

/**
 * COMPARISON SUMMARY: Flutter Testing vs Playwright
 * 
 * ADVANTAGES OF FLUTTER TESTING:
 * 1. Single codebase for all platforms (mobile, web, desktop)
 * 2. No browser dependencies - tests run in Flutter environment
 * 3. Widget-level testing with direct access to Flutter widgets
 * 4. Faster execution - no browser startup overhead
 * 5. More reliable - no DOM/CSS selector brittleness
 * 6. Better debugging with Flutter DevTools integration
 * 7. Type safety with Dart language
 * 8. Direct access to Flutter state management
 * 9. No need for test IDs - can test by widget type/properties
 * 10. Golden tests for visual regression testing
 * 
 * PLAYWRIGHT LIMITATIONS:
 * 1. Browser-only testing (can't test mobile app directly)
 * 2. Requires running actual web server
 * 3. Brittle CSS/DOM selectors
 * 4. Slower due to browser automation overhead
 * 5. Network dependency for every test
 * 6. Platform-specific issues across browsers
 * 7. Complex setup for file uploads and native features
 * 8. JavaScript-only testing (unless using TypeScript)
 * 9. Requires extensive test ID management
 * 10. Limited access to application state
 * 
 * CONCLUSION:
 * Flutter's integrated testing approach is superior for cross-platform
 * applications, providing better performance, reliability, and developer
 * experience compared to traditional browser-based E2E testing tools
 * like Playwright.
 */