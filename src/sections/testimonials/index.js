import React from 'react'
import { Row, Col, Container } from 'react-bootstrap'
import { graphql, StaticQuery } from 'gatsby'
import BaffleText from 'components/baffle-text'
import AnimationContainer from 'components/animation-container'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faQuoteLeft } from '@fortawesome/free-solid-svg-icons'
import Slider from 'react-slick'
import ThemeContext from '../../context'
import 'slick-carousel/slick/slick-theme.css'
import './styles.scss'

class Testimonials extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      show: false,
    }

    this.show = this.show.bind(this)
  }

  static contextType = ThemeContext

  show() {
    this.setState({ show: true })
  }

  render() {
    return (
      <section
        id={`${this.props.id}`}
        className="testimonials"
        style={{ height: this.context.height }}
      >
        <Row
          className="top"
          style={{
            maxHeight:
              this.context.height !== 'auto'
                ? this.context.height * 0.8
                : 'inherit',
          }}
        >
          <div className="content">
            <Col md={12}>
              <div className="line-text">
                <h4>Testimonnials</h4>
              </div>
              <div className="heading">
                <BaffleText
                  text="Reviews by Clients"
                  revealDuration={500}
                  revealDelay={500}
                  parentMethod={this.show}
                  callMethodTime={1100}
                />
              </div>
              <div
                className="testimonials_container"
                style={{
                  minHeight:
                    this.context.height !== 'auto'
                      ? this.context.height * 0.6
                      : 'auto',
                }}
              >
                <Container>
                  {this.quote()}
                  {this.testimonial_slider()}
                </Container>
              </div>
            </Col>
          </div>
        </Row>
        <Row className="bottom">{this.clients()}</Row>
      </section>
    )
  }

  clients() {
    if (this.state.show || this.context.height === 'auto') {
      return this.props.clients.edges.map((value, index) => {
        return (
          <Col md={2} className="client" key={index}>
            <AnimationContainer delay={100} animation="fadeIn slower">
              <img src={value.node.childImageSharp.fluid.src} alt="client" />
            </AnimationContainer>
          </Col>
        )
      })
    }
  }

  testimonial_slider() {
    const settings = {
      dots: true,
      swipe: true,
      infinite: true,
      speed: 500,
      slidesToShow: 1,
      slidesToScroll: 1,
      arrows: false,
      autoplay: true,
      autoplaySpeed: 10000,
      loop: true,
    }
    if (this.state.show) {
      return (
        <AnimationContainer delay={100} animation="fadeIn slow">
          <Slider {...settings}>{this.testimonial_items()}</Slider>
        </AnimationContainer>
      )
    }
  }
  testimonial_items() {
    if (this.state.show || this.context.height === 'auto') {
      return this.props.testimonials.edges.map((value, index) => {
        return (
          <div className="testimonial" key={index}>
            <h2>{value.content.frontmatter.heading}</h2>
            <div
              className="testimonial_content"
              dangerouslySetInnerHTML={{
                __html: value.content.html,
              }}
            />
            <div className="client_container">
              <div className="client">
                <img
                  src={
                    value.content.frontmatter.image.childImageSharp.fluid.src
                  }
                  alt={value.content.frontmatter.name}
                />
                <div className="info">
                  <p className="name">{value.content.frontmatter.name}</p>
                  <p className="profession">
                    {value.content.frontmatter.profession}
                  </p>
                </div>
              </div>
            </div>
          </div>
        )
      })
    }
  }

  quote() {
    if (this.state.show) {
      return (
        <div className="quote">
          <AnimationContainer delay={0} animation="fadeIn slow">
            <FontAwesomeIcon icon={faQuoteLeft} />
          </AnimationContainer>
        </div>
      )
    }
  }
}

export default props => (
  <StaticQuery
    query={graphql`
          query {
            clients: allFile(filter: {extension: {regex: "/(png)/"}, relativeDirectory: {eq: "clients"}}) {
              edges {
                node {
                  childImageSharp {
                    fluid(maxWidth: 500) {
                      src
                    }
                  }
                }
              }
            }
            testimonials: allMarkdownRemark(filter: {fileAbsolutePath: {regex: "/(testimonials)/"}}, sort: {fields: [frontmatter___id], order: ASC}, limit: 8) {
                edges {
                  content: node {
                    html
                    frontmatter {
                      id
                      name
                      profession
                      heading
                      image {
                        childImageSharp {
                          fluid(maxWidth: 200, maxHeight: 200) {
                            src
                          }
                        }
                      }
                    }
                  }
                }
              }
          }
        `}
    render={({ clients, testimonials }) => (
      <Testimonials clients={clients} testimonials={testimonials} {...props} />
    )}
  />
)
