import { useEffect, useState } from 'react';
import './About.scss';
import axios from 'axios';

function About() {
    const [data, setData] = useState([]);
    const [image1, setImage1] = useState(
        'https://raw.githubusercontent.com/thuykieu06012002/cutimage/main/nam.101.png',
    );
    const [image2, setImage2] = useState('https://raw.githubusercontent.com/thuykieu06012002/cutimage/main/nu.101.png');
    const [image3, setImage3] = useState('https://raw.githubusercontent.com/thuykieu06012002/futurelove/main/101.jpg');
    const [image4, setImage4] = useState('https://raw.githubusercontent.com/thuykieu06012002/futurelove/main/101.jpg');

    useEffect(() => {
        const fetchData = async () => {
            const reponse = await axios.get('http://14.225.7.221:2663/homev1', {
                headers: {
                    Link_img1: image1,
                    Link_img2: image2,
                    Link_img3: image3,
                    Link_img4: image4,
                },
            });
            setData(reponse.data);
        };

        const uploadImgMale = () => {
            const formData = new FormData();
            formData.append('image', image1);

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
            formData.append('image', image2);

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
        const uploadImgMaleFeMale = () => {
            const formData = new FormData();
            formData.append('image', image3);

            let apiresponse = axios
                .post('https://api.imgbb.com/1/upload?key=a07b4b5e0548a50248aecfb194645bac', formData)
                .then((res) => {
                    setImage3(res.data.data.url);
                    return res.data;
                })
                .catch((error) => {
                    return null;
                });
            return apiresponse;
        };
        const uploadImgFeMaleMale = () => {
            const formData = new FormData();
            formData.append('image', image4);

            let apiresponse = axios
                .post('https://api.imgbb.com/1/upload?key=a07b4b5e0548a50248aecfb194645bac', formData)
                .then((res) => {
                    setImage4(res.data.data.url);
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
        uploadImgFeMaleMale();
        uploadImgMaleFeMale();
    }, [image1, image2, image3, image4]);

    //
    const handleChangeImageMale = async (event) => {
        let file = event.target.files[0];
        //let id = event.target.id;

        if (file) {
            setImage1(file);
        }
    };
    const handleChangeImageFemale = async (event) => {
        let file = event.target.files[0];
        if (file) {
            setImage2(file);
        }
    };
    const handleChangeImgMaleFemale = async (event) => {
        let file = event.target.files[0];
        if (file) {
            setImage3(file);
        }
    };
    const handleChangeImgFemaleMale = async (event) => {
        let file = event.target.files[0];

        if (file) {
            setImage4(file);
        }
    };

    return (
        <div className="wrapper-about">
            <div className="about-top">
                <div className="male">
                    <input type="file" id="male" onChange={handleChangeImageMale} />
                    <div className="image" style={{ backgroundImage: `url(${image1})` }}></div>
                    <div className="name">
                        <p>Name Male</p>
                    </div>
                </div>
                <div className="female">
                    <input type="file" id="female" onChange={handleChangeImageFemale} />
                    <div className="image" style={{ backgroundImage: `url(${image2})` }}></div>
                    <div className="name">Name feMale</div>
                </div>
                <div className="male-female">
                    <input type="file" id="male-female" onChange={handleChangeImgMaleFemale} />
                    <div className="image" style={{ backgroundImage: `url(${image3})` }}></div>
                    <div className="name">Image Male - Female</div>
                </div>
                <div className="female-male">
                    <input type="file" id="female-male" onChange={handleChangeImgFemaleMale} />
                    <div className="image" style={{ backgroundImage: `url(${image4})` }}></div>
                    <div className="name">Image Female - Male</div>
                </div>
            </div>
            {data && data.Link_img && (
                <div className="img-swap">
                    <div className="img-swap-image" style={{ backgroundImage: `url(${data.Link_img})` }}></div>
                    <div className="name">Image Swap</div>
                </div>
            )}
            <div className="about-main">
                <div className="future-love">The future of your love...!</div>
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
