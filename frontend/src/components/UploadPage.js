import React, { useState } from 'react';
import { FaCheckCircle } from 'react-icons/fa';
import loadingGif1 from '../assets/scan2.gif'; 
import loadingGif2 from '../assets/scan.gif';

const UploadPage = ({ setCurrentPage, setUploadedImage }) => {
  const [selectedFile, setSelectedFile] = useState(null);
  const [isFileUploaded, setIsFileUploaded] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [gifToggle, setGifToggle] = useState(true); 

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSelectedFile(URL.createObjectURL(file)); 
      setIsFileUploaded(true); 
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!selectedFile) {
      alert('Please select an image and disease category');
      return;
    }

    setIsLoading(true); 
    setUploadedImage(selectedFile); 

    setTimeout(() => {
      setCurrentPage('results');
      setIsLoading(false);
      setGifToggle(!gifToggle); // Toggle the GIF on each submission
    }, 2000);
  };

  return (
    <div className={`upload-page ${isLoading ? 'blur-background' : ''}`}>
      {/* Wrap your main content inside the main-content div */}
      <div className="main-content">
        <div className="container">
          <h2 className="upload-title gradient-text">Upload Medical Image</h2>
          <form onSubmit={handleSubmit} className="upload-form">
            <div className="upload-area" onClick={() => document.getElementById('file-input').click()}>
              {isFileUploaded ? (
                <div className="uploaded-indicator">
                  <FaCheckCircle color="green" size={40} />
                  <span>File Uploaded!</span>
                </div>
              ) : (
                <span>Click to upload image</span>
              )}
              <input
                type="file"
                accept="image/*"
                id="file-input"
                style={{ display: 'none' }} 
                onChange={handleFileChange}
              />
            </div>

            <select className="disease-select">
              <option value="" disabled selected>
                Select Disease Category
              </option>
              <option value="pneumonia">Pneumonia</option>
              <option value="tuberculosis">Tuberculosis</option>
              <option value="covid19">COVID-19</option>
              <option value="brain_tumor">Brain Tumor</option>
              <option value="skin_cancer">Skin Cancer</option>
              <option value="diabetes_retinopathy">Diabetic Retinopathy</option>
              <option value="breast_cancer">Breast Cancer</option>
            </select>

            <button type="submit" className="btn-analyze" disabled={isLoading}>
              {isLoading ? 'Analyzing...' : 'Analyze Image'}
            </button>
          </form>
        </div>
      </div>

      {isLoading && (
        <div className="loading-overlay">
          <img
            src={gifToggle ? loadingGif1 : loadingGif2}
            alt="Loading..."
            className="loading-gif"
          />
        </div>
      )}
    </div>
  );
};

export default UploadPage;
