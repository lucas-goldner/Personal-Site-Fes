import React, { useState } from "react";
import { Row, Col } from "react-bootstrap";
import Typewriter from "typewriter-effect";
import ThemeContext from "../utils/context";

function Hero({ id }) {
  const [height, setHeight] = useState(0);
  console.log("hey");
  return (
    <section
      id={`${id}`}
      className="hero"
      //style={{ height: this.context.height }}
    >
      <Row>
        <Col md={6} className="content">
          <div className="content-text">
            <div className="line-text">
              <h4>今日は</h4>
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
          {this.icons()}
        </Col>
        <Col md={6} className="img">
          <img
            src={this.props.mainImg.childImageSharp.fluid.src}
            alt="person"
          />
        </Col>
      </Row>
    </section>
  );
}

export default Hero;
