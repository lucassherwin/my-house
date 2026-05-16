import { test, expect, type Page } from "@playwright/test";

const uniqueEmail = () => `test+${Date.now()}@example.com`;

async function signup(
    page: Page,
    opts: {
        firstName: string;
        lastName: string;
        email: string;
        password: string;
    },
) {
    await page.goto("/signup");
    await page.fill("#first_name", opts.firstName);
    await page.fill("#last_name", opts.lastName);
    await page.fill("#email", opts.email);
    await page.fill("#password", opts.password);
    await page.click('button[type="submit"]');
    await page.waitForURL("/");
}

async function logout(page: Page) {
    await page.context().clearCookies();
}

test.describe("Authentication flow", () => {
    test("unauthenticated user visiting / is redirected to /login", async ({
        page,
    }) => {
        await page.goto("/");
        await expect(page).toHaveURL("/login");
        await expect(page.getByText(/sign in/i).first()).toBeVisible();
    });

    test("signup creates account and lands on home page with greeting", async ({
        page,
    }) => {
        const email = uniqueEmail();
        await signup(page, {
            firstName: "Jane",
            lastName: "Doe",
            email,
            password: "password123",
        });

        await expect(page.locator("h1")).toContainText(
            "Hello Jane - welcome home",
        );
    });

    test("login with valid credentials lands on home page", async ({
        page,
    }) => {
        const email = uniqueEmail();
        await signup(page, {
            firstName: "John",
            lastName: "Smith",
            email,
            password: "secret123",
        });
        await logout(page);

        await page.goto("/login");
        await page.fill("#email", email);
        await page.fill("#password", "secret123");
        await page.click('button[type="submit"]');
        await page.waitForURL("/");

        await expect(page.locator("h1")).toContainText(
            "Hello John - welcome home",
        );
    });

    test("login with invalid credentials shows inline error", async ({
        page,
    }) => {
        await page.goto("/login");
        await page.fill("#email", "nobody@example.com");
        await page.fill("#password", "wrongpassword");
        await page.click('button[type="submit"]');

        await expect(page.locator("ul.text-destructive")).toBeVisible();
        await expect(page).toHaveURL("/login");
    });

    test("signup with duplicate email shows validation errors", async ({
        page,
    }) => {
        const email = uniqueEmail();
        await signup(page, {
            firstName: "Alice",
            lastName: "A",
            email,
            password: "pass1234",
        });
        await logout(page);

        await page.goto("/signup");
        await page.fill("#first_name", "Bob");
        await page.fill("#last_name", "B");
        await page.fill("#email", email);
        await page.fill("#password", "pass1234");
        await page.click('button[type="submit"]');

        await expect(page.locator("ul.text-destructive")).toBeVisible();
        await expect(page).toHaveURL("/signup");
    });

    test("authenticated user visiting /login is redirected to /", async ({
        page,
    }) => {
        const email = uniqueEmail();
        await signup(page, {
            firstName: "Eve",
            lastName: "E",
            email,
            password: "pass5678",
        });

        await page.goto("/login");
        await expect(page).toHaveURL("/");
    });
});
