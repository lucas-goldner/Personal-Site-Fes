import React from "react";
import "./styles.scss";
import { Row, Col } from "react-bootstrap";
import AnimationContainer from "components/animation-container";
import BaffleText from "components/baffle-text";
import ThemeContext from "../../context";
import emailjs from "emailjs-com";

class Contact extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: "",
      email: "",
      phone: "",
      message: "",
      error: false,
      show: false,
    };
    this.show = this.show.bind(this);
  }
  static contextType = ThemeContext;

  show() {
    this.setState({ show: true });
  }

  check(val) {
    if (this.state.error && val === "") {
      return false;
    } else {
      return true;
    }
  }

  submit() {
    if (
      this.state.name === "" ||
      this.state.email === "" ||
      this.state.message === ""
    ) {
      this.setState({ error: true });
    } else {
      this.setState({ error: false });
      emailjs
        .send(
          process.env.SERVICE_ID,
          process.env.TEMPLATE_ID,
          {
            from_name: this.state.name,
            email: this.state.email,
            number: this.state.phone,
            message: this.state.message,
            to_name: "Lucas Goldner",
          },
          process.env.USER_ID
        )
        .then(
          function (response) {
            console.log("SUCCESS!", response.status, response.text);
          },
          function (error) {
            console.log("FAILED...", error);
          }
        );
    }
  }
  render() {
    return (
      <section
        id={`${this.props.id}`}
        className="contact"
        style={{ height: this.context.height }}
      >
        <Row>
          <Col md={2} className="side">
            <h2>
              <BaffleText
                text="Contact"
                revealDuration={500}
                revealDelay={500}
                parentMethod={this.show}
                callMethodTime={1100}
              />
            </h2>
          </Col>
          <Col md={5} className="form">
            {this.form()}
          </Col>
          <Col md={5} className="map">
            {this.map()}
          </Col>
        </Row>
      </section>
    );
  }

  form() {
    if (this.state.show || this.context.height === "auto") {
      return (
        <AnimationContainer delay={0} animation="fadeInUp fast">
          <div className="form-container">
            <div className="line-text">
              <h4>Get In Touch</h4>
              <AnimationContainer delay={50} animation="fadeInUp fast">
                <div className="form-group">
                  <input
                    type="text"
                    className={`name ${
                      this.check(this.state.name) ? "" : "error"
                    }`}
                    placeholder="Name"
                    onChange={(e) => this.setState({ name: e.target.value })}
                  />
                </div>
              </AnimationContainer>
              <AnimationContainer delay={100} animation="fadeInUp fast">
                <div className="form-group">
                  <input
                    type="text"
                    className={`email ${
                      this.check(this.state.email) ? "" : "error"
                    }`}
                    placeholder="Email"
                    onChange={(e) => this.setState({ email: e.target.value })}
                  />
                </div>
              </AnimationContainer>
              <AnimationContainer delay={150} animation="fadeInUp fast">
                <div className="form-group">
                  <input
                    type="text"
                    className="phone"
                    placeholder="Phone"
                    onChange={(e) => this.setState({ phone: e.target.value })}
                  />
                </div>
              </AnimationContainer>
              <AnimationContainer delay={200} animation="fadeInUp fast">
                <div className="form-group">
                  <textarea
                    className={`message ${
                      this.check(this.state.message) ? "" : "error"
                    }`}
                    placeholder="Message"
                    onChange={(e) => this.setState({ message: e.target.value })}
                  ></textarea>
                </div>
              </AnimationContainer>
              <AnimationContainer delay={250} animation="fadeInUp fast">
                <div className="submit">
                  <button
                    className={`hover-button ${
                      this.state.error ? "error" : ""
                    }`}
                    onClick={() => this.submit()}
                  >
                    <span>Send Message</span>
                  </button>
                </div>
              </AnimationContainer>
            </div>
          </div>
        </AnimationContainer>
      );
    }
  }

  map() {
    if (this.state.show || this.context.height === "auto") {
      return (
        <AnimationContainer
          delay={1000}
          animation="fadeIn fast"
          height={this.context.height}
        >
          <iframe
            title="map"
            width="100%"
            height="100%"
            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2619.671296609889!2d9.254451415905514!3d48.95974450151858!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x4799cd709411aa19%3A0x943b069597674234!2sHeerstra%C3%9Fe%2013%2C%2071711%20Murr!5e0!3m2!1sde!2sde!4v1615071789410!5m2!1sde!2sde"
          />
        </AnimationContainer>
      );
    }
  }
}

export default Contact;
