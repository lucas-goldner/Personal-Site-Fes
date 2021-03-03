import React, { useState, useEffect } from "react";
import { ThemeProvider } from "../utils/context";
import scrollToElement from "scroll-to-element";
import Navigation from "../components/Navigation";

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

  const wheel = (e) => {
    if (!scrolling && !mobile) {
      setScrolllock(true);
      if (e.deltaY < 0) {
        if (
          sections[(sectionID + sections.length - 1) % tsections.length] !==
          sections[sections.length - 1]
        )
          setSectionID((sectionID + sections.length - 1) % sections.length);
      } else {
        if (sectionID !== sections.length - 1)
          setSectionID(sectionID + (1 % sections.length));
      }
      const el = document.getElementById(sections[sectionID]);
      scrollToElement(el, {
        offset: 0,
        ease: "in-out-expo",
        duration: 2000,
      }).on("end", () => {
        setScrolling(false);
      });
    }
  };

  return (
    <>
      <ThemeProvider value={{ height: mobile ? "auto" : height }}>
        <Navigation change={setSectionID} />
        <div onWheel={(e) => wheel(e)}>{children}</div>
      </ThemeProvider>
    </>
  );
}

export default Layout;
