import React, { useState } from "react";
import "../styles/navigation.scss";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTimes, faBars } from "@fortawesome/free-solid-svg-icons";
import scrollToElement from "scroll-to-element";

function Navigation({ setSectionID }) {
  const [show, setShow] = false;
  const [sections, setSections] = [
    {
      name: "Home",
    },
    {
      name: "About",
    },
    {
      name: "Services",
    },
    {
      name: "Portfolio",
    },
    {
      name: "Testimonials",
    },
    {
      name: "Contact",
    },
  ];

  const navScroll = (id, v) => {
    setShow(false);
    const el = document.getElementById(id);
    scrollToElement(el, {
      offset: 0,
      ease: "in-out-expo",
      duration: 2000,
    }).on("end", () => {
      setSectionID(v);
    });
  };

  return (
    <>
      <div>
        <div className="opener">
          <FontAwesomeIcon
            icon={faBars}
            className="closeNav"
            onClick={() => setShow(true)}
          />
        </div>
        <div className={`navigation ${show ? "active" : ""}`}>
          <FontAwesomeIcon
            icon={faTimes}
            className="closeNav"
            onClick={() => setShow(false)}
          />
          <div className="logo">
            <img src="img/logo.png" alt="logo" />
          </div>
          <div className="links">
            <ul>
              {sections.map((value, index) => {
                return (
                  <li key={index}>
                    <button
                      onClick={() => navScroll(value.name.toLowerCase(), index)}
                    >
                      {value.name}
                    </button>
                  </li>
                );
              })}
            </ul>
          </div>
        </div>
      </div>
    </>
  );
}

export default Navigation;
