import React from 'react'
import handleViewport from 'react-in-viewport'
import 'animate.css/animate.css'

class Animation_Container extends React.Component {

      constructor(props) {
          super(props)
          this.state = {
              inViewport: false,
              animation_complete: false,
              classChanged: false,
          }
      }


      componentDidUpdate() {
          if (this.state.inViewport !== this.props.inViewport && !this.state.animation_complete) {
              this.setState({inViewport: this.props.inViewport})
              this.changeClass()
              this.setState({animation_complete: true})
          }
      }

      changeClass() {
        const { delay } = this.props
        setTimeout(() => { 
            this.setState({classChanged: true});
        }
        , delay);
      }


      render() {
        const { children, animation, id, height } = this.props
        return (
            <div className={this.state.classChanged ? `animated ${animation}` : ""} style={{opacity: this.state.classChanged ? 1 : 0, height: height ? height : "auto"}} id={id} >
                {children}
            </div>
        );
      }

}
const AnimationContainer = handleViewport(Animation_Container);

export default AnimationContainer