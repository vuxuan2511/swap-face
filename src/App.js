import './App.scss';

import SideBar from './sideBar/SideBar';
function App() {
    return (
        <div className="App">
            <header className="App-header">
                <p>Future Love</p>
                <div className="img-love"></div>
            </header>
            <div>
                <SideBar />
            </div>
        </div>
    );
}

export default App;
