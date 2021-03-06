import React from 'react'
import { Link } from 'gatsby'
import Helmet from 'react-helmet'
import 'scss/retro.scss'

class page404 extends React.Component {

    render() {
        return(
            <div>
                <Helmet>
                    <title>Error : 404</title>
                </Helmet>
                <div className="error-404">
                    <div>
                        <h1>404</h1>
                        <h2>The page you are looking for could not be found</h2>
                        <Link to="/">
                            Home
                        </Link>
                    </div>
                </div>
            </div>
        )
    }
}

export default page404
