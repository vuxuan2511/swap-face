import { useEffect, useState } from 'react';
import './About.scss';
import axios from 'axios';

function About() {
    const [data, setData] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
            const reponse = await axios.get('http://14.225.7.221:2663/homev1', {
                headers: {
                    Link_img1: 'https://raw.githubusercontent.com/thuykieu06012002/cutimage/main/nam.101.png',
                    Link_img2: 'https://raw.githubusercontent.com/thuykieu06012002/cutimage/main/nu.101.png',
                },
            });
            setData(reponse.data);
            console.log(reponse.data);
        };
        fetchData();
    }, []);

    return (
        <div className="wrapper-about">
            <div className="about-top">
                <div className="male">
                    <div className="male-image"></div>
                    <div className="name">Name Male</div>
                </div>
                <div className="female">
                    <div className="female-image"></div>
                    <div className="name">Name feMale</div>
                </div>
                <div className="img-swap">
                    <div className="female-image" style={{ backgroundImage: `url(${data.Link_img})` }}></div>
                    <div className="name">Swap</div>
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
