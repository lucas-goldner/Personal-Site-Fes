import { faAngular, faReact } from "@fortawesome/free-brands-svg-icons";
import {
  faCode,
  faMobile,
  faPizzaSlice,
  faServer,
  faSmileBeam,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import AnimationContainer from "components/animation-container";
import BaffleText from "components/baffle-text";
import Counter from "components/counter";
import React from "react";
import { Col, Container, Row } from "react-bootstrap";
import ThemeContext from "../../context";
import "./styles.scss";

class Services extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      show: false,
    };
    this.show = this.show.bind(this);
  }

  static contextType = ThemeContext;

  show() {
    this.setState({ show: true });
  }

  render() {
    return (
      <section
        id={`${this.props.id}`}
        className="services"
        style={{ height: this.context.height }}
      >
        <Row
          className="top"
          style={{
            maxHeight:
              this.context.height !== "auto"
                ? this.context.height * 0.8
                : "inherit",
          }}
        >
          <div className="content">
            <Col md={12}>
              <div className="line-text">
                <h4>Services</h4>
              </div>
              <div className="heading">
                <BaffleText
                  text="What I Do"
                  revealDuration={500}
                  revealDelay={500}
                  parentMethod={this.show}
                  callMethodTime={1100}
                />
              </div>
              <div
                className="services_container"
                style={{
                  minHeight:
                    this.context.height !== "auto"
                      ? this.context.height * 0.6
                      : "inherit",
                }}
              >
                <Container>{this.services()}</Container>
              </div>
            </Col>
          </div>
        </Row>
        <Row className="bottom">{this.counters()}</Row>
      </section>
    );
  }

  services() {
    if (this.state.show || this.context.height === "auto") {
      return (
        <Row>
          <Col md={4} className="service">
            <AnimationContainer delay={200} animation="fadeInLeft fast">
              <div className="icon">
                <FontAwesomeIcon icon={faReact} />
              </div>
              <h4>Front-End React</h4>
              <p>
                React is my first and also my favourite library to create
                websites. It is easy to get in, but the learn curve I would
                argue is big. Learning React really changed how I code
                personally. I can create amazing websites today in more or less
                two - three days, if I have enough time.
              </p>
            </AnimationContainer>
          </Col>
          <Col md={4} className="service border-side">
            <AnimationContainer delay={400} animation="fadeInDown fast">
              <div className="icon">
                <svg
                  aria-hidden="true"
                  focusable="false"
                  data-prefix="fab"
                  data-icon="apple"
                  class="svg-inline--fa fa-apple fa-w-12"
                  role="img"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 384 512"
                >
                  <path
                    fill="currentColor"
                    d="M318.7 268.7c-.2-36.7 16.4-64.4 50-84.8-18.8-26.9-47.2-41.7-84.7-44.6-35.5-2.8-74.3 20.7-88.5 20.7-15 0-49.4-19.7-76.4-19.7C63.3 141.2 4 184.8 4 273.5q0 39.3 14.4 81.2c12.8 36.7 59 126.7 107.2 125.2 25.2-.6 43-17.9 75.8-17.9 31.8 0 48.3 17.9 76.4 17.9 48.6-.7 90.4-82.5 102.6-119.3-65.2-30.7-61.7-90-61.7-91.9zm-56.6-164.2c27.3-32.4 24.8-61.9 24-72.5-24.1 1.4-52 16.4-67.9 34.9-17.5 19.8-27.8 44.3-25.6 71.9 26.1 2 49.9-11.4 69.5-34.3z"
                  ></path>
                </svg>
              </div>
              <h4>IOS Apps</h4>
              <p>
                Funnily enough I started IOS Development, because my friend
                needed help in his app. I had no idea of Swift, but I was able
                to help him out quickly. I have built already an entire social
                media app, a workout tracker, a jogging tracker and even
                voicechat with WebRTC.
              </p>
            </AnimationContainer>
          </Col>
          <Col md={4} className="service">
            <AnimationContainer delay={600} animation="fadeInRight fast">
              <div className="icon">
                <FontAwesomeIcon icon={faMobile} />
              </div>
              <h4>React Native Apps</h4>
              <p>
                When I found out about this framework I was really excited to
                try it out. React is my favourite library already and making
                apps with it seams like a dream. Crossplattform might be the
                future, so it is good, that I already launched a React Native
                app.
              </p>
            </AnimationContainer>
          </Col>
          <Col md={4} className="service">
            <AnimationContainer delay={800} animation="fadeInLeft fast">
              <div className="icon">
                <svg
                  aria-hidden="true"
                  focusable="false"
                  data-prefix="fab"
                  data-icon="android"
                  class="svg-inline--fa fa-android fa-w-18"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 576 512"
                >
                  <path
                    fill="currentColor"
                    d="M420.55,301.93a24,24,0,1,1,24-24,24,24,0,0,1-24,24m-265.1,0a24,24,0,1,1,24-24,24,24,0,0,1-24,24m273.7-144.48,47.94-83a10,10,0,1,0-17.27-10h0l-48.54,84.07a301.25,301.25,0,0,0-246.56,0L116.18,64.45a10,10,0,1,0-17.27,10h0l47.94,83C64.53,202.22,8.24,285.55,0,384H576c-8.24-98.45-64.54-181.78-146.85-226.55"
                  ></path>
                </svg>
              </div>
              <h4>Android Apps</h4>
              <p>
                This is where I really started coding. I made an entire social
                media app in Java by myself in around two - three months. It
                really changed the way I code. Personally I would use Kotlin
                today for this section, but I need to learn it first.
              </p>
            </AnimationContainer>
          </Col>
          <Col md={4} className="service border-side">
            <AnimationContainer delay={1000} animation="fadeInUp fast">
              <div className="icon">
                <FontAwesomeIcon icon={faAngular} className="solid" />
              </div>
              <h4>Front-End Angular</h4>
              <p>
                Yes you are seeing right Angular. Yes I am able to make websites
                in Angular. Would I like to use React instead ? Yes, because I
                am much faster with React, but if you really need a website in
                Angular for some reason I can do that too.
              </p>
            </AnimationContainer>
          </Col>
          <Col md={4} className="service">
            <AnimationContainer delay={1200} animation="fadeInRight fast">
              <div className="icon">
                <FontAwesomeIcon icon={faServer} className="solid" />
              </div>
              <h4>Microservices</h4>
              <p>
                You need an API, a websocket server, a bot, a database ? Great
                because I have already worked on them all. Normally I use
                Javascript, to work on things as these, but I am also good in
                working with GO or Python.
              </p>
            </AnimationContainer>
          </Col>
        </Row>
      );
    }
  }

  counters() {
    if (this.state.show || this.context.height === "auto") {
      return (
        <Container>
          <Col md={4}>
            <AnimationContainer delay={100} animation="fadeIn fast">
              <Counter
                icon={faSmileBeam}
                value={4}
                text="Coding"
                symbol="Years"
                duration={2}
              />
            </AnimationContainer>
          </Col>
          <Col md={4}>
            <AnimationContainer delay={100} animation="fadeIn fast">
              <Counter
                icon={faPizzaSlice}
                value={17}
                text="Finished"
                symbol="Projetcs"
                duration={5}
              />
            </AnimationContainer>
          </Col>
          <Col md={4}>
            <AnimationContainer delay={100} animation="fadeIn fast">
              <Counter
                icon={faCode}
                value={609836}
                text="of Code"
                symbol="Lines"
                duration={10}
              />
            </AnimationContainer>
          </Col>
        </Container>
      );
    }
  }
}

export default Services;
