import React from 'react'
import handleViewport from 'react-in-viewport'
import CountUp from 'react-countup'
import './styles.scss'

class Progress_Animation extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            value: 0,
            inViewport: false,
            animation_complete: false
        }
    }

    componentDidUpdate() {
        if (this.state.inViewport !== this.props.inViewport && !this.state.animation_complete) {
            this.setState({inViewport: this.props.inViewport})
            this.setState({animation_complete: true})
            this.showProgress()
        }
    }

    showProgress() {
        setTimeout(() => { 
            this.setState({value : this.props.value})
        }, this.props.delay);
    }

    
    render() {
        const { name } = this.props
        return(
            <div className="progress-container">
                <span className="name">{name}</span>
                <span className="value"><CountUp start={0} end={this.state.inViewport === true ? this.state.value : 0} />%</span>
                <div className="progress" style={{width: `${this.state.value}%`}}></div>
            </div>
        )
    }
}
const Progress = handleViewport(Progress_Animation);

export default Progress