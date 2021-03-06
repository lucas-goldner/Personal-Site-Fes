import React from "react";
import Particles from "react-particles-js";
import { Row, Col } from "react-bootstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faGithub,
  faLinkedin,
  faTwitter,
  faYoutube,
} from "@fortawesome/free-brands-svg-icons";
import Progress from "../components/Progress";
import { useRouter } from "next/router";

function About({ id }) {
  const router = useRouter();
  return (
    <section id={id} className="about" style={{ height: "auto" }}>
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
      <Row>
        <Col md={6} className="content">
          <div className="content-text">
            <div className="line-text">
              <h4>About Me</h4>
            </div>
            <h3>I'm a Full Stack web developer working from home</h3>
            <div className="separator" />
            <p>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus
              suscipit nisi vitae feugiat vestibulum. Aliquam porta nulla vel
              odio scelerisque, pretium volutpat dui euismod. Integer porttitor
              dolor placerat malesuada dictum. Fusce enim dolor, dignissim quis
              ornare at, elementum nec turpis. Donec ac interdum libero, sed
              condimentum lectus. Nunc nec iaculis tortor. Donec interdum
              sollicitudin eros in pharetra. Donec ultricies laoreet dictum.
              Maecenas vestibulum sodales justo, id hendrerit orci aliquet
              gravida. Nulla facilisi.
            </p>
            <div className="social_icons">
              <FontAwesomeIcon
                icon={faGithub}
                className="social_icon"
                onClick={() => router.push("https://www.github.com")}
              />
              <FontAwesomeIcon
                icon={faTwitter}
                className="social_icon"
                onClick={() => router.push("https://www.twitter.com")}
              />
              <FontAwesomeIcon
                icon={faYoutube}
                className="social_icon"
                onClick={() => router.push("https://www.youtube.com")}
              />
              <FontAwesomeIcon
                icon={faLinkedin}
                className="social_icon"
                onClick={() => router.push("https://www.linkedin.com")}
              />
            </div>
          </div>
        </Col>

        <Col md={6} className="skills">
          <div className="line-text">
            <h4>My Skills</h4>
          </div>
          <div className="skills-container">
            <Progress name="Web Design" value={90} delay={1100} />
            <Progress name="Angular" value={50} delay={1100} />
            <Progress name="React" value={80} delay={1100} />
            <Progress name="Vue" value={40} delay={1100} />
            <Progress name="MongoDB" value={100} delay={1100} />
            <Progress name="CSS" value={50} delay={1100} />
          </div>
        </Col>
      </Row>
    </section>
  );
}

export default About;
