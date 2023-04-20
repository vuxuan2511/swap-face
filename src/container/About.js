import { useEffect, useState } from 'react';
import './About.scss';
import axios from 'axios';

function About() {
    const [data, setData] = useState([]);
    const [image1, setImage1] = useState(
        'https://raw.githubusercontent.com/thuykieu06012002/cutimage/main/nam.101.png',
    );
    const [image2, setImage2] = useState('https://raw.githubusercontent.com/thuykieu06012002/cutimage/main/nu.101.png');

    useEffect(() => {
        const fetchData = async () => {
            const reponse = await axios.get('http://14.225.7.221:2663/homev1', {
                headers: {
                    Link_img1: image1,
                    Link_img2: image2,
                },
            });
            setData(reponse.data);
        };
        fetchData();
    }, [image1, image2]);
    const handleChangeImageMale = async (event) => {
        let data = event.target.files;
        console.log(data);
        let file = data[0];
        if (file) {
            const objectUrl = URL.createObjectURL(file);
            setImage1(objectUrl);
        }
    };
    const handleChangeImageFemale = async (event) => {
        let data = event.target.files;
        console.log(data);
        let file = data[0];
        if (file) {
            const objectUrl = URL.createObjectURL(file);
            setImage2(objectUrl);
        }
    };

    return (
        <div className="wrapper-about">
            <div className="about-top">
                <div className="male">
                    <input type="file" id="male" onChange={handleChangeImageMale} />
                    <div className="male-image" style={{ backgroundImage: `url(${image1})` }}></div>
                    <div className="name">Name Male</div>
                </div>
                <div className="female">
                    <input type="file" id="female" onChange={handleChangeImageFemale} />
                    <div className="female-image" style={{ backgroundImage: `url(${image2})` }}></div>
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
