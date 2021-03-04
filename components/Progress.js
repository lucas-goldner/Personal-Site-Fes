import React from "react";

function Progress() {
  return (
    <div className="progress-container">
      <span className="name">{name}</span>
      <span className="value">
        <CountUp
          start={0}
          end={this.state.inViewport === true ? this.state.value : 0}
        />
        %
      </span>
      <div className="progress" style={{ width: `${this.state.value}%` }}></div>
    </div>
  );
}

export default Progress;
