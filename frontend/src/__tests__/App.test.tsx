import React from 'react';
import App from '../App';
import {screen, fireEvent, render} from '@testing-library/react';
import axios from 'axios';

jest.mock('axios');
const mockedAxios = axios as jest.Mocked<typeof axios>;

it('renders app page', () => {
  render(<App/>,);

  // Shows banner, input and submit buttons
  expect(screen.getByRole("banner")).toBeTruthy();
  expect(screen.getByRole("textbox")).toBeTruthy();
  expect(screen.getByRole("button")).toBeTruthy();

  // Shows styled site name
  expect(screen.getByText("UR")).toBeTruthy();
  expect(screen.getByText("L")).toBeTruthy();
  expect(screen.getByText("ess")).toBeTruthy();

  // Shows input label and submit button text
  expect(screen.getByText("URL")).toBeTruthy();
  expect(screen.getByText("make it shorter")).toBeTruthy();
});

it('displays shortened url when successful', async () => {
  render(<App/>,);

  const textBox = screen.getByRole("textbox")
  const button = screen.getByRole("button")

  // change input text and click submit
  fireEvent.change(textBox, {target: { value: "http://www.google.com"} } )
  fireEvent.click(button)

  // mock response to be success
  const new_url = "http://example.com/hash"
  mockedAxios.post.mockResolvedValue({
    data: { new_url },
    status: 201
  });

  // ensure new url is present
  await screen.findByText(new_url)

  // ensure copy and reset buttons are present
  expect(screen.getByText("COPY")).toBeTruthy()
  expect(screen.getByText("another one")).toBeTruthy()
})
