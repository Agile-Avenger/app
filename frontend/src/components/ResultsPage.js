import React from 'react';
import Card from './Card';

const ResultsPage = ({ setCurrentPage, uploadedImage }) => {
  return (
    <div className="results-page">
      <div className="container">
        <h2 className="results-title gradient-text">Analysis Results</h2>
        <div className="results-content">
          <div className="result-image">
            <h3>Uploaded Image</h3>
            <img id="resultImage" src={uploadedImage} alt="Uploaded medical image" />
          </div>

          <div className="result-analysis">
            <Card
              title="Primary Diagnosis"
              content="High likelihood of condition detected."
            />
            <Card
              title="Confidence Score"
              content="92.7%"
            />
            <Card
              title="Additional Notes"
              content="Recommended for clinical correlation and further evaluation."
            />
          </div>
        </div>
        <button onClick={() => setCurrentPage('upload')} className="btn-analyze-another">
          Analyze Another Image
        </button>
      </div>
    </div>
  );
};

export default ResultsPage;
