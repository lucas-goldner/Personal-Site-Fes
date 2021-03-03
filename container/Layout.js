import React, { useState, useEffect } from "react";
import { ThemeProvider } from "../utils/context";

function Layout({ children }) {
  const [height, setHeight] = useState(0);
  const [mobile, setMobile] = useState(false);
  const [scrolllock, setScrolllock] = useState(0);
  const [width, setWidth] = useState(0);
  const [sections, setSections] = useState([
    "home",
    "about",
    "services",
    "portfolio",
    "testimonials",
    "contact",
  ]);
  const [sectionID, setSectionID] = useState(0);
  const [scrolling, setScrolling] = useState(false);

  useEffect(() => {
    setDefaults();
    window.addEventListener("resize", this.updateDimensions);
  }, []);

  const updateDimensions = () => {
    if (width !== window.innerWidth) {
      window.location.reload();
    }
    setHeight(window.innerHeight);
    setWidth(window.innerWidth);
    if (window.innerWidth < 1025) {
      setScrolllock(false);
      if (window.innerWidth < 992) {
        setMobile(true);
      }
    } else {
      setScrolllock(true);
      setMobile(false);
    }
  };

  const setDefaults = () => {
    setHeight(window.innerWidth < 992 ? "auto" : window.innerHeight);
    setMobile(window.innerWidth < 992 ? true : false);
    setScrolllock(window.innerWidth < 1025 ? false : true);
    setWidth(window.innerWidth);
  };

  return (
    <>
      <ThemeProvider
        value={{ height: mobile ? "auto" : height }}
      ></ThemeProvider>
    </>
  );
}

export default Layout;
