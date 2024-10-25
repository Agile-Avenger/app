import React from 'react';

const Header = ({ currentPage, setCurrentPage }) => {
  return (
    <header className="header">
      <div className="logo gradient-text">Agile Avengers AI</div>
      <nav>
        <ul className="nav-links">
          <li onClick={() => setCurrentPage('home')} className={currentPage === 'home' ? 'active' : ''}>
            Home
          </li>
          <li onClick={() => setCurrentPage('upload')} className={currentPage === 'upload' ? 'active' : ''}>
            Diagnose
          </li>
        </ul>
      </nav>
    </header>
  );
};

export default Header;
