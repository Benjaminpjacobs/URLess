
import axios from 'axios';
const BACKEND_API_URL = "http://localhost:3000";

const postUrl = (originalUrl: string | undefined) => {
  const requestOptions = {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
    },
    url: { original_url: originalUrl },
  };
  return axios.post(BACKEND_API_URL, requestOptions);
};

export default postUrl
