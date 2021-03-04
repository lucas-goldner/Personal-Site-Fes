import Head from "next/head";
import Layout from "../container/Layout";
import Hero from "../container/Hero";
import About from "../container/About";

export default function Home() {
  return (
    <div>
      <Head>
        <title>Lucas Goldner Persona(l) Site</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Layout>
        <Hero id="home" />
        <About id="about" />
      </Layout>
    </div>
  );
}
