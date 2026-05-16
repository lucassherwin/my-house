import React from "react";

interface HomeProps {
  name: string;
}

const Home: React.FC<HomeProps> = ({ name }) => (
  <div className="min-h-screen flex items-center justify-center">
    <h1 className="text-2xl font-semibold">Hello {name} - welcome home</h1>
  </div>
);

export default Home;
