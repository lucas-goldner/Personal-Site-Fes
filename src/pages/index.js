import React from "react";
import Helmet from "react-helmet";
import Layout from "components/layout";
import Spinner from "components/spinner";
import Hero from "sections/hero";
import About from "sections/about";
import Portfolio from "sections/portfolio";
import Services from "sections/services";
import Contact from "sections/contact";
import metaData from "../../data/meta.json";

class HomePage extends React.Component {
  render() {
    const { site } = metaData.data;
    return (
      <div>
        <Helmet>
          <title>{site.meta.title}</title>
          <meta name="author" content={site.meta.author} />
          <meta name="description" content={site.meta.description} />
          <meta name="keywords" content={site.meta.keywords} />
        </Helmet>
        <Layout>
          <Hero id="home" />
          <About id="about" />
          <Services id="services" />
          <Portfolio id="portfolio" />
          <Contact id="contact" />
        </Layout>
        <Spinner duration={1000} />
      </div>
    );
  }
}

export default HomePage;
