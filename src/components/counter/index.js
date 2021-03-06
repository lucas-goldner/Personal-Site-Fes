import React from 'react'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import CountUp from 'react-countup'
import handleViewport from 'react-in-viewport'

class Counter_Component extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            inViewport: false,
            animation_complete: false
        }
    }

    componentDidUpdate() {
        if (this.state.inViewport !== this.props.inViewport && !this.state.animation_complete) {
            this.setState({inViewport: this.props.inViewport})
            this.setState({animation_complete: true})
            this.setState({value: this.props.state})
        }
    }

    render() {
        const { icon, text, value, symbol} = this.props
        return (
            <div className="counter_component">
                <div className="icon">
                    <FontAwesomeIcon icon={icon} />
                </div>
                <div className="value">
                    <CountUp start={0} end={this.state.inViewport === true ? value : 0} duration={this.props.duration ? this.props.duration : 1}/><span className="symbol">{symbol}</span>
                </div>
                <div className="text">
                    {text}
                </div>
            </div>
        )
    }
}

const Counter = handleViewport(Counter_Component);

export default Counter