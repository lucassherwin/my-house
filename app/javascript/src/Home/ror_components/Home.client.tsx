import { CollapsibleMenu } from "@/design-system/CollapsibleMenu";
import React from "react";

interface Household {
  id: string;
  name: string;
}

interface HomeProps {
  name: string;
  household: Household | null;
}

const Home: React.FC<HomeProps> = ({ name, household }) => (
  <main className="flex flex-col items-center justify-center py-24 gap-8">
    <h1 className="text-2xl font-semibold">Hello {name} - welcome home</h1>

    {household && (
      <div>
        <CollapsibleMenu title={household.name} />
      </div>
    )}
  </main>
);

export default Home;
