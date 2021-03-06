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
        <link rel="preconnect" href="https://fonts.gstatic.com"></link>
        <link
          href="https://fonts.googleapis.com/css2?family=Poppins&display=swap"
          rel="stylesheet"
        ></link>
      </Head>
      <Layout>
        <Hero id="home" />
        <About id="about" />
      </Layout>
    </div>
  );
}
