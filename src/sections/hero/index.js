import Glitch from "components/glitch";
import React from "react";
import { Col, Row } from "react-bootstrap";
import Typewriter from "typewriter-effect";
import ThemeContext from "../../context";
import heroData from "../../../data/hero.json";
import "./styles.scss";

class Hero extends React.Component {
  static contextType = ThemeContext;

  render() {
    return (
      <section
        id={`${this.props.id}`}
        className="hero"
        style={{ height: this.context.height }}
      >
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
                    "IOS Developer",
                    "Front End Engineer",
                    "Android Developer",
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
              src={heroData.data.Img.childImageSharp.fluid.src}
              alt="Lucas Goldner with inline skates posing in front of a graffiti wall"
            />
          </Col>
        </Row>
      </section>
    );
  }

  icons() {
    return heroData.data.icons.edges.map((value, index) => {
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
                (+(index % 2 === 0 ? 80 : 20) - +(index % 2 === 0 ? 70 : 10)) +
              +(index % 2 === 0 ? 70 : 10)
            }%`,
          }}
          alt="shape"
          key={index}
        />
      );
    });
  }
}

export default Hero;
