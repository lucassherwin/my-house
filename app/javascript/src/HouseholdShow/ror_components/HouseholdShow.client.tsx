import React from "react";

interface HouseholdShowProps {
  household: {
    id: string;
    name: string;
  };
}

const HouseholdShow: React.FC<HouseholdShowProps> = ({ household }) => (
  <main className="flex min-h-[calc(100vh-4rem)] flex-col items-center justify-center px-4">
    <h1 className="text-3xl font-semibold tracking-tight">
      Welcome to {household.name}
    </h1>
  </main>
);

export default HouseholdShow;
