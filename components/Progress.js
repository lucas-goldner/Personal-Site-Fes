import React, { useState, useEffect } from "react";
import handleViewport from "react-in-viewport";
import CountUp from "react-countup";

function Progress({ name, value, delay }) {
  const [thisValue, setThisValue] = useState(value);
  const [inViewport, setInViewport] = useState(false);
  const [animationComplete, setAnimationComplete] = useState(false);

  useEffect(() => {
    if (inViewport !== inViewport && !animationComplete) {
      setInViewport(inViewport);
      setAnimationComplete(animationComplete);
      showProgress();
    }
  }, []);

  const showProgress = () => {
    setTimeout(() => {
      setThisValue(value);
    }, delay);
  };

  return (
    <div className="progress-container">
      <span className="name">{name}</span>
      <span className="value">
        <CountUp start={0} end={inViewport === true ? thisValue : 0} />%
      </span>
      <div className="progress" style={{ width: `${thisValue}%` }}></div>
    </div>
  );
}

export default Progress;
