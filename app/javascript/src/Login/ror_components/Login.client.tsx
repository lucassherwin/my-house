import React, { useState } from "react";
import AuthLayout from "@/design-system/AuthLayout";
import FormCard from "@/design-system/FormCard";
import FormInput from "@/design-system/FormInput";
import { Button } from "@/components/ui/button";
import { useFetch } from "@/hooks/useFetch";

const Login: React.FC = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const { fetch: login, status, errors } = useFetch("/login", {
    method: "POST",
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const ok = await login({ email, password });
    if (ok) window.location.href = "/";
  };

  return (
    <AuthLayout>
      <FormCard title="Welcome back" description="Sign in to your account to continue.">
        <form onSubmit={handleSubmit} className="space-y-4">
          <FormInput
            label="Email"
            id="email"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            autoComplete="email"
          />
          <FormInput
            label="Password"
            id="password"
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            autoComplete="current-password"
          />
          {errors.length > 0 && (
            <ul className="text-sm text-destructive space-y-1">
              {errors.map((err) => (
                <li key={err}>{err}</li>
              ))}
            </ul>
          )}
          <Button
            type="submit"
            className="w-full"
            disabled={status === "pending"}
          >
            {status === "pending" ? "Signing in…" : "Sign in"}
          </Button>
          <p className="text-sm text-center text-muted-foreground">
            Don&apos;t have an account?{" "}
            <a href="/signup" className="font-medium text-primary hover:underline">
              Sign up
            </a>
          </p>
        </form>
      </FormCard>
    </AuthLayout>
  );
};

export default Login;
