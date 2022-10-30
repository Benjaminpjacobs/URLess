import React from 'react';
import CopyText from '../CopyText';
import {screen, fireEvent, render} from '@testing-library/react';

const mockUpdateShortened = jest.fn(()=> {})

jest.mock('copy-to-clipboard', () =>
  jest.fn().mockImplementation((input) => {
    return true;
  })
);

it('renders copy text', async () => {
  const url = "www.example.com"
  render(<CopyText url={url} updateShortened={mockUpdateShortened}/>,);

  expect(screen.getByText(url)).toBeTruthy();
  expect(screen.getByText("another one")).toBeTruthy();

  const copyButton = screen.getByText("COPY")
  fireEvent.click(copyButton)
  await screen.findByText("COPIED!")
});
