import React from 'react'
import './styles.scss'

class Glitch extends React.Component {

    render() {
        const { text } = this.props
        return(
            <div className="glitch" data-text={text}>{text}</div>
        )
    }
}
export default Glitch