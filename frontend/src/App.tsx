import React from "react";
import URLForm from "./Form";
import CopyText from "./CopyText";
import "./App.css";

const App: React.FC = () => {
  const [shortended, updateShortened] = React.useState(null);

  return (
    <div className="App">
      <header className="App-header">
        <div>
          <strong>UR</strong><em>L</em>ess
        </div>
      </header>

      {!shortended && <URLForm updateShortened={updateShortened} />}
      {shortended && <CopyText url={shortended} updateShortened={updateShortened} />}
    </div>
  );
};

export default App;
