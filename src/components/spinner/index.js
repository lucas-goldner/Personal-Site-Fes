import React from 'react'
import './styles.scss'

class Spinner extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      spin: true,
    }
  }

  componentDidMount() {
    const { duration } = this.props
    this.showSpinner(duration).then(() => {
      setTimeout(() => {
        document.getElementById('spinner').remove()
      }, 500)
    })
  }

  showSpinner(duration) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        this.setState({ spin: false })
        document.body.classList.remove('no-overflow')
        resolve()
      }, duration)
    })
  }

  render() {
    return (
      <div
        className={`spinner-container ${this.state.spin ? 'show' : ''}`}
        id="spinner"
      >
        <div className="spinner">
          <div className="ring"></div>
          <div className="ring"></div>
          <div className="dot"></div>
        </div>
      </div>
    )
  }
}

export default Spinner
