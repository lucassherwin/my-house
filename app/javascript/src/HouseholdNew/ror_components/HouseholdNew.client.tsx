import React, { useEffect, useState } from "react";
import FormCard from "@/design-system/FormCard";
import FormInput from "@/design-system/FormInput";
import { Button } from "@/components/ui/button";
import { useFetch } from "@/hooks/useFetch";
import { Home } from "lucide-react";

interface HouseholdResponse {
  id: string;
  name: string;
}

const HouseholdNew: React.FC = () => {
  const [name, setName] = useState("");
  const { fetch: createHousehold, status, errors, data } = useFetch<HouseholdResponse>(
    "/my-household",
    { method: "POST" },
  );

  useEffect(() => {
    if (status === "success" && data) {
      window.location.href = `/my-household/${data.id}`;
    }
  }, [status, data]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await createHousehold({ household: { name } });
  };

  return (
    <main className="flex min-h-[calc(100vh-4rem)] flex-col items-center justify-center px-4 py-16">
      <div className="mb-8 flex flex-col items-center gap-3 text-center">
        <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-primary text-primary-foreground shadow-sm">
          <Home className="h-7 w-7" />
        </div>
        <div>
          <h1 className="text-2xl font-semibold tracking-tight">Create your household</h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Give your household a name to get started.
          </p>
        </div>
      </div>

      <FormCard title="Household name">
        <form onSubmit={handleSubmit} className="space-y-4">
          <FormInput
            label="Name"
            id="name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="e.g. The Smith House"
            required
            autoFocus
          />
          {errors.length > 0 && (
            <ul className="text-sm text-destructive space-y-1">
              {errors.map((err) => (
                <li key={err}>{err}</li>
              ))}
            </ul>
          )}
          <Button type="submit" className="w-full" disabled={status === "pending"}>
            {status === "pending" ? "Creating…" : "Create household"}
          </Button>
        </form>
      </FormCard>
    </main>
  );
};

export default HouseholdNew;
