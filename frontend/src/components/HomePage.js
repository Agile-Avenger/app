import React from 'react';

const HomePage = ({ setCurrentPage }) => {
  return (
    <div className="homepage">
      <div className="container">
        <h1 className="title gradient-text">AI-Powered Medical Image Analysis</h1>
        <p className="description">
          Leverage cutting-edge artificial intelligence to analyze medical images and detect potential health
          conditions. Our system provides rapid, accurate insights to support medical professionals.
        </p>
        <button onClick={() => setCurrentPage('upload')} className="btn-start">
          Get Started
        </button>
      </div>
    </div>
  );
};

export default HomePage;
