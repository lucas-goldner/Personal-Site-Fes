import Head from "next/head";
import Layout from "../container/Layout";
import Hero from "../container/Hero";

export default function Home() {
  return (
    <div>
      <Head>
        <title>Lucas Goldner Persona(l) Site</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Layout>
        <Hero id="home" />
      </Layout>
    </div>
  );
}
