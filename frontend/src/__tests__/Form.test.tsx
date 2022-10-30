import React from 'react';
import Form from '../Form';
import {screen, fireEvent, render} from '@testing-library/react';
import axios from 'axios';

jest.mock('axios');

const mockedAxios = axios as jest.Mocked<typeof axios>;
const mockUpdateShortened = jest.fn(()=> {})

it('renders form', () => {
  render(<Form updateShortened={mockUpdateShortened}/>,);
  //Form components display
  expect(screen.getByRole("textbox")).toBeTruthy();
  expect(screen.getByRole("button")).toBeTruthy();

  //Form text displays
  expect(screen.getByText("URL")).toBeTruthy();
  expect(screen.getByText("make it shorter")).toBeTruthy();
});

it('displays not a valid url error', async () => {
  render(<Form updateShortened={mockUpdateShortened}/>,);
  const textBox = screen.getByRole("textbox")
  const button = screen.getByRole("button")

  //Change input to break validation
  fireEvent.change(textBox, {target: { value: "not a real url"} } )
  fireEvent.click(button)

  //Message appears
  await screen.findByText("ENTER A VALID HTTP(S) URL")
})

it('displays error use host url error', async () => {
  render(<Form updateShortened={mockUpdateShortened}/>,);
  const textBox = screen.getByRole("textbox")
  const button = screen.getByRole("button")

  fireEvent.change(textBox, {target: { value: "http://localhost:3000"} } )
  fireEvent.click(button)

  const err = { response: { data: { error: ["CANNOT USE HOST URL" ] } } }
  mockedAxios.post.mockRejectedValueOnce(err);

  //Message appears from api error response
  await screen.findByText("CANNOT USE HOST URL")
})
