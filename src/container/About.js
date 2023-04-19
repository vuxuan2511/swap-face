import './About.scss';
function About() {
    return (
        <div className="wrapper-about">
            <div className="about-top">
                <div className="male">
                    <div
                        className="male-image"
                        // style={{ backgroundImage: URL() }}
                    ></div>
                    <div className="name">Name Male</div>
                </div>
                <div className="female">
                    <div
                        className="female-image"
                        // style={{ backgroundImage: URL() }}
                    ></div>

                    <div className="name">Name feMale</div>
                </div>
            </div>
            <div className="about-main">
                <div className="future-love">The future of your love...!</div>
                <div className="about-main-group">
                    <div>Sad Openning</div>
                    <div>Event Happy</div>
                    <div>Event Sad</div>
                    <div>Sweetheart</div>
                    <div>Sad Ending</div>
                </div>
            </div>
            <div className="about-bottom">
                <button>
                    Try again <i className="fas fa-sync-alt"></i>
                </button>
            </div>
        </div>
    );
}

export default About;
