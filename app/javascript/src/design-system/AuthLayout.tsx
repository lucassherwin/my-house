import React from "react";
import { Home } from "lucide-react";
import ThemeToggle from "./ThemeToggle";

interface AuthLayoutProps {
  children: React.ReactNode;
}

const AuthLayout: React.FC<AuthLayoutProps> = ({ children }) => (
  <div
    className="relative min-h-screen flex flex-col items-center justify-center bg-background px-4 py-12"
    style={{
      backgroundImage:
        "radial-gradient(ellipse 80% 50% at 50% -10%, hsl(var(--primary) / 0.08), transparent 70%)",
    }}
  >
    <div className="absolute top-4 right-4">
      <ThemeToggle />
    </div>

    <div className="mb-8 flex flex-col items-center gap-2">
      <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-primary text-primary-foreground shadow-sm">
        <Home className="h-6 w-6" />
      </div>
      <span className="text-xl font-semibold tracking-tight text-foreground">
        My House
      </span>
    </div>

    <div className="w-full max-w-sm">{children}</div>
  </div>
);

export default AuthLayout;
