import React from "react";
import Particles from "react-particles-js";
import Progress from "components/progress";
import { Row, Col } from "react-bootstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faGithub,
  faLinkedin,
  faTwitter,
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
                Creating something from the ground up, completly by myself, has
                always been my passion. I started to get into programming by
                making my own small game in Unity. After that I started learning
                Java and got into Android App Development, mainly because I am
                Co-Founder of{" "}
                <a href="https://flowus.app" className="freshColor">
                  FlowUS
                </a>
                . I also learnt all about web development HTML, CSS, JS, React
                and other frameworks, in order to code our landing page for the
                app. By working as a Front End Engineer, I made enough money to
                buy me a Mac and IPhone, so I can also assist my team in the IOS
                Development department. Along the way I learnt some languages,
                like Python and Go for microservices.
              </p>
              <div className="social social_icons">
                <FontAwesomeIcon
                  icon={faGithub}
                  className="social_icon"
                  onClick={() => window.open("https://www.github.com")}
                />
                <FontAwesomeIcon
                  icon={faTwitter}
                  className="social_icon"
                  onClick={() => window.open("https://www.twitter.com")}
                />
                <FontAwesomeIcon
                  icon={faYoutube}
                  className="social_icon"
                  onClick={() => window.open("https://www.youtube.com")}
                />
                <FontAwesomeIcon
                  icon={faLinkedin}
                  className="social_icon"
                  onClick={() => window.open("https://www.linkedin.com")}
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
                name="JavaScript"
                value={5}
                delay={1100}
                display={"Mastered"}
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
              <Progress name="Go" value={2} delay={1100} display={"Good"} />
              <Progress
                name="Python"
                value={1}
                delay={1100}
                display={"Beginner"}
              />
              <Progress
                name="C#"
                value={3}
                delay={1100}
                display={"Comfortable"}
              />
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
