import { useEffect, useState } from 'react';
import './About.scss';
import axios from 'axios';

function About() {
    const [data, setData] = useState([]);
    const [image1, setImage1] = useState(
        'https://raw.githubusercontent.com/thuykieu06012002/cutimage/main/nam.101.png',
    );
    const [image2, setImage2] = useState('https://raw.githubusercontent.com/thuykieu06012002/cutimage/main/nu.101.png');
    const [imgBase64M, setImgBase64M] = useState('');
    const [imgBase64Fm, setImgBase64Fm] = useState('');

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

        const uploadImgMale = () => {
            const formData = new FormData();
            formData.append('image', imgBase64M);

            let apiresponse = axios
                .post('https://api.imgbb.com/1/upload?key=a07b4b5e0548a50248aecfb194645bac', formData)
                .then((res) => {
                    setImage1(res.data.data.url);
                    return res.data;
                })
                .catch((error) => {
                    return null;
                });
            return apiresponse;
        };
        const uploadImgFeMale = () => {
            const formData = new FormData();
            formData.append('image', imgBase64Fm);

            let apiresponse = axios
                .post('https://api.imgbb.com/1/upload?key=a07b4b5e0548a50248aecfb194645bac', formData)
                .then((res) => {
                    setImage2(res.data.data.url);
                    return res.data;
                })
                .catch((error) => {
                    return null;
                });
            return apiresponse;
        };

        fetchData();
        uploadImgMale();
        uploadImgFeMale();
    }, [image1, image2, imgBase64M, imgBase64Fm]);

    //
    const handleChangeImageMale = async (event) => {
        let file = event.target.files[0];
        if (file) {
            const objectUrl = URL.createObjectURL(file);
            setImage1(objectUrl);
            setImgBase64M(file);
        }
    };

    const handleChangeImageFemale = async (event) => {
        let file = event.target.files[0];
        if (file) {
            const objectUrl = URL.createObjectURL(file);
            setImage2(objectUrl);
            setImgBase64Fm(file);
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
