import React from "react";
import { Home } from "lucide-react";
import { cn } from "@/lib/utils";
import { getCsrfToken } from "@/lib/csrf";
import { Button } from "@/components/ui/button";
import ThemeToggle from "./ThemeToggle";

interface NavbarProps {
  className?: string;
}

const NAV_LINKS = ["My House", "My Lists"] as const;

async function logout() {
  try {
    await globalThis.fetch("/logout", {
      method: "DELETE",
      headers: { "X-CSRF-Token": getCsrfToken() },
    });
  } finally {
    window.location.href = "/login";
  }
}

const Navbar: React.FC<NavbarProps> = ({ className }) => (
  <header
    className={cn(
      "sticky top-0 z-50 w-full border-b border-border bg-background/95 backdrop-blur-sm",
      className,
    )}
  >
    <nav className="mx-auto flex h-16 max-w-7xl items-center gap-1 px-4 sm:px-6">
      {/* Logo */}
      <button
        onClick={() => console.log("My House")}
        className="mr-3 flex items-center gap-2.5 rounded-lg px-1 py-1.5 transition-opacity hover:opacity-80 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
        aria-label="My House home"
      >
        <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground shadow-sm">
          <Home className="h-4 w-4" />
        </div>
        <span className="text-base font-semibold tracking-tight text-foreground">
          My House
        </span>
      </button>

      {/* Left nav links */}
      <div className="flex items-center gap-0.5">
        {NAV_LINKS.map((label) => (
          <Button
            key={label}
            variant="ghost"
            size="sm"
            className="text-muted-foreground hover:text-foreground"
            onClick={() => console.log(label)}
          >
            {label}
          </Button>
        ))}
      </div>

      {/* Right: theme toggle + logout */}
      <div className="ml-auto flex items-center gap-2">
        <ThemeToggle />
        <Button
          variant="ghost"
          size="sm"
          className="text-muted-foreground hover:text-destructive hover:bg-destructive/10"
          onClick={logout}
        >
          Logout
        </Button>
      </div>
    </nav>
  </header>
);

export default Navbar;
