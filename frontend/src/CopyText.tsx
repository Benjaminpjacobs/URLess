import React from "react";
import "./CopyText.css";
import { CopyToClipboard } from 'react-copy-to-clipboard';

type Props = {
  url: string;
  updateShortened: Function
}

const CopyText: React.FC<Props>= (props: Props) => {
  const { url, updateShortened } = props
  const [copyText, setCopyText] = React.useState("COPY")

  const handleCopy = () => {
    setCopyText("COPIED!")
    setTimeout(() => setCopyText("COPY"), 1000)
  }

  return (
    <>
      <div className="LinkToCopy">
        <div className="url">{url}</div>
        <CopyToClipboard text={url}
          onCopy={handleCopy}>
            <div className="copy-button-wrapper">
              <span className="copy-button">{copyText}</span>
            </div>
        </CopyToClipboard>
      </div>
      <input type="button" value="another one" onClick={()=>updateShortened(null)}/>
    </>
  );
};

export default CopyText;
