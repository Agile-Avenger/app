import React, { useState } from 'react';
import HomePage from './components/HomePage';
import UploadPage from './components/UploadPage';
import ResultsPage from './components/ResultsPage';
import Header from './components/Header';
import './styles.css';

function App() {
  const [currentPage, setCurrentPage] = useState('home');
  const [uploadedImage, setUploadedImage] = useState(null); // Ensure this is defined

  return (
    <div className="app">
      <Header currentPage={currentPage} setCurrentPage={setCurrentPage} />
      {currentPage === 'home' && <HomePage setCurrentPage={setCurrentPage} />}
      {currentPage === 'upload' && (
        <UploadPage 
          setCurrentPage={setCurrentPage} 
          setUploadedImage={setUploadedImage} // Ensure this prop is passed correctly
        />
      )}
      {currentPage === 'results' && (
        <ResultsPage 
          setCurrentPage={setCurrentPage} 
          uploadedImage={uploadedImage} 
        />
      )}
    </div>
  );
}

export default App;
