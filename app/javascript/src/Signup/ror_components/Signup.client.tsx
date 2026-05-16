import React, { useState } from "react";
import AuthLayout from "@/design-system/AuthLayout";
import FormCard from "@/design-system/FormCard";
import FormInput from "@/design-system/FormInput";
import { Button } from "@/components/ui/button";
import { useFetch } from "@/hooks/useFetch";

// Field names are snake_case to match the Rails JSON API directly.
interface SignupForm {
  email: string;
  first_name: string;
  last_name: string;
  password: string;
}

const Signup: React.FC = () => {
  const [form, setForm] = useState<SignupForm>({
    email: "",
    first_name: "",
    last_name: "",
    password: "",
  });
  const { fetch: signup, status, errors } = useFetch("/signup", {
    method: "POST",
  });

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement & { name: keyof SignupForm }>,
  ) =>
    setForm((prev) => ({
      ...prev,
      [e.target.name as keyof SignupForm]: e.target.value,
    }));

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const ok = await signup(form);
    if (ok) window.location.href = "/";
  };

  return (
    <AuthLayout>
      <FormCard title="Create account" description="Sign up to get started with My House.">
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
            <FormInput
              label="First name"
              id="first_name"
              name="first_name"
              value={form.first_name}
              onChange={handleChange}
              required
            />
            <FormInput
              label="Last name"
              id="last_name"
              name="last_name"
              value={form.last_name}
              onChange={handleChange}
              required
            />
          </div>
          <FormInput
            label="Email"
            id="email"
            name="email"
            type="email"
            value={form.email}
            onChange={handleChange}
            required
            autoComplete="email"
          />
          <FormInput
            label="Password"
            id="password"
            name="password"
            type="password"
            value={form.password}
            onChange={handleChange}
            required
            autoComplete="new-password"
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
            {status === "pending" ? "Creating account…" : "Create account"}
          </Button>
          <p className="text-sm text-center text-muted-foreground">
            Already have an account?{" "}
            <a href="/login" className="font-medium text-primary hover:underline">
              Sign in
            </a>
          </p>
        </form>
      </FormCard>
    </AuthLayout>
  );
};

export default Signup;
