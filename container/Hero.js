import React, { useState } from "react";
import { Row, Col } from "react-bootstrap";
import Typewriter from "typewriter-effect";
import Glitch from "../components/Glitch";
import ThemeContext from "../utils/context";
import heroData from "../data/hero.json";

function Hero({ id }) {
  const [height, setHeight] = useState(0);
  return (
    <section id={`${id}`} className="hero" style={{ height: "auto" }}>
      <Row>
        <Col md={6} className="content">
          <div className="content-text">
            <div className="line-text">
              <h4>俺は</h4>
            </div>
            <Glitch text="Lucas Goldner" />
            <Typewriter
              options={{
                strings: [
                  "IOS App Developer",
                  "Front End Engineer",
                  "Android App Developer",
                ],
                autoStart: true,
                loop: true,
              }}
            />
            <button className="hover-button">
              <span>Download CV</span>
            </button>
          </div>
          {heroData.icons.edges.map((value, index) => {
            return (
              <img
                src={value.node.childImageSharp.fluid.src}
                className={`animated fadeIn move-${
                  Math.floor(Math.random() * 10) % 2 === 0 ? "up" : "down"
                } float-image`}
                style={{
                  left: `${index * 10}%`,
                  bottom: `${
                    Math.random() *
                      (+(index % 2 === 0 ? 80 : 20) -
                        +(index % 2 === 0 ? 70 : 10)) +
                    +(index % 2 === 0 ? 70 : 10)
                  }%`,
                }}
                alt="shape"
                key={index}
              />
            );
          })}
        </Col>
        <Col md={6} className="img">
          <img src={heroData.Img.childImageSharp.fluid.src} alt="person" />
        </Col>
      </Row>
    </section>
  );
}

export default Hero;
