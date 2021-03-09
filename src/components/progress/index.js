import React from "react";
import handleViewport from "react-in-viewport";
import "./styles.scss";

class Progress_Animation extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      value: 0,
      inViewport: false,
      animation_complete: false,
      display: "",
    };
  }

  componentDidUpdate() {
    if (
      this.state.inViewport !== this.props.inViewport &&
      !this.state.animation_complete
    ) {
      this.setState({ inViewport: this.props.inViewport });
      this.setState({ animation_complete: true });
      this.showProgress();
    }
  }

  showProgress() {
    setTimeout(() => {
      this.setState({ value: this.props.value });
    }, this.props.delay);
  }

  render() {
    const { name } = this.props;
    return (
      <div className="progress-container">
        <span className="name">{name}</span>
        <span className="value">{this.props.display}</span>
        <div
          className="progress"
          style={{ width: `${this.state.value * 20}%` }}
        ></div>
      </div>
    );
  }
}
const Progress = handleViewport(Progress_Animation);

export default Progress;
