import React from "react";

interface HomeProps {
  name: string;
}

const Home: React.FC<HomeProps> = ({ name }) => (
  <main className="flex items-center justify-center py-24">
    <h1 className="text-2xl font-semibold">Hello {name} - welcome home</h1>
  </main>
);

export default Home;
