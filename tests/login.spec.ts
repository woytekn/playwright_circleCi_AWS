import { test, expect } from "@playwright/test";

test("has title", async ({ page }) => {
	await page.goto("https://saucedemo.com");
	await expect(page).toHaveTitle(/Swag/);
});

test("get started link", async ({ page }) => {
	await page.goto("https://saucedemo.com");
	await page.locator("#user-name").type("standard_user");
	await page.locator("#password").type("secret_sauce");
	await page.locator("#login-button").click();
	await expect(page.locator("#shopping_cart_container")).toBeVisible();
});
