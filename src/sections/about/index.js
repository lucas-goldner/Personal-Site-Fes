import React from "react";
import Particles from "react-particles-js";
import Progress from "components/progress";
import { Row, Col } from "react-bootstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faGithub,
  faLinkedin,
  faTwitter,
  faStackOverflow,
  faYoutube,
} from "@fortawesome/free-brands-svg-icons";
import ThemeContext from "../../context";
import "./styles.scss";

class Hero extends React.Component {
  static contextType = ThemeContext;

  render() {
    return (
      <section
        id={`${this.props.id}`}
        className="about"
        style={{ height: this.context.height }}
      >
        {this.particles()}
        <Row>
          <Col md={6} className="content">
            <div className="content-text">
              <div className="line-text">
                <h4>About Me</h4>
              </div>
              <h3>I'm an App and Web Developer</h3>
              <div className="separator" />
              <p>
                Creating something from the ground up, entirely by myself, has
                always been my passion. I started to get into programming by
                making my own small game in Unity. After that, I started
                learning Java and got into Android App Development. After that,
                I tried out web development, HTML, CSS, JS, React. And other
                frameworks to code landing pages and earn some money. By working
                as a Front End Engineer, I made enough to buy myself a Mac and
                iPhone, so I could also start developing for iOS. During my
                fourth semester, I learned Python, and at my internship at{" "}
                <a href="https://bitfactory.io" className="freshColor">
                  Bitfactory{" "}
                </a>
                I worked as a Flutter Developer.
              </p>
              <div className="social social_icons">
                <FontAwesomeIcon
                  icon={faGithub}
                  className="social_icon"
                  onClick={() =>
                    window.open("https://github.lucas-goldner.com")
                  }
                />
                <FontAwesomeIcon
                  icon={faLinkedin}
                  className="social_icon"
                  onClick={() =>
                    window.open("https://linkedin.lucas-goldner.com")
                  }
                />
                <FontAwesomeIcon
                  icon={faYoutube}
                  className="social_icon"
                  onClick={() =>
                    window.open("https://youtube.lucas-goldner.com")
                  }
                />
                <FontAwesomeIcon
                  icon={faTwitter}
                  className="social_icon"
                  onClick={() =>
                    window.open("https://www.twitter.lucas-goldner.com")
                  }
                />
                <FontAwesomeIcon
                  icon={faStackOverflow}
                  className="social_icon"
                  onClick={() =>
                    window.open("https://stackoverflow.lucas-goldner.com")
                  }
                />
              </div>
            </div>
          </Col>
          <Col md={6} className="skills">
            <div className="line-text">
              <h4>My Skills</h4>
            </div>
            <div className="skills-container">
              <Progress
                name="JavaScript / TypeScript"
                value={5}
                delay={1100}
                display={"Most comfortable"}
              />
              <Progress
                name="Java"
                value={3}
                delay={1100}
                display={"Comfortable"}
              />
              <Progress
                name="Swift"
                value={4}
                delay={1100}
                display={"Advanced"}
              />
              <Progress
                name="Dart"
                value={3}
                delay={1100}
                display={"Comfortable"}
              />
              <Progress
                name="Python"
                value={4}
                delay={1100}
                display={"Advanced"}
              />
              <Progress name="C#" value={2} delay={1100} display={"Basic"} />
            </div>
          </Col>
        </Row>
      </section>
    );
  }

  particles() {
    return (
      <Particles
        className="particles"
        params={{
          particles: {
            number: {
              value: 50,
              density: {
                enable: false,
                value_area: 5000,
              },
            },
            line_linked: {
              enable: true,
              opacity: 0.5,
            },
            size: {
              value: 1,
            },
          },
          retina_detect: true,
        }}
      />
    );
  }
}

export default Hero;
