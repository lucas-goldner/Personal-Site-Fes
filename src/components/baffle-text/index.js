import React from 'react'
import Baffle from "baffle-react";
import handleViewport from 'react-in-viewport'

class Baffle_Text extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            value: 0,
            inViewport: false,
            animation_complete: false,
            obfuscate: true,
            force: false
        }
    }

    componentDidUpdate() {
        if (this.state.inViewport !== this.props.inViewport && !this.state.animation_complete) {
            this.setState({inViewport: this.props.inViewport})
            this.setState({animation_complete: true})
            this.setState({obfuscate: false})
            this.forceUpdate()
            if (this.props.callMethodTime) {
                this.parentMethod()
            }
        }
    }

    forceUpdate() {
        const { revealDuration, revealDelay } = this.props
        setTimeout(() => { 
            this.setState({force:true})
        }, revealDuration+revealDelay);
    }

    parentMethod() {
        const { callMethodTime } = this.props
        setTimeout(() => { 
            this.props.parentMethod()
        }, callMethodTime);
    }

    render() {
        return(
            <span className="baffle_text">
                {this.text()}
            </span>
        )
    }

    text() {
        const { text, revealDuration, revealDelay } = this.props
        if (!this.state.force) {
            return (
                <Baffle
                    speed={50}
                    characters="ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*"
                    obfuscate={this.state.obfuscate}
                    update={true}
                    revealDuration={revealDuration}
                    revealDelay={revealDelay}
                >
                    {text}
                </Baffle>
            )
        } else {
            return <span>{text}</span>
        }
    }
}
const BaffleText = handleViewport(Baffle_Text);

export default BaffleText