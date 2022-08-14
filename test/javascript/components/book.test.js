import { mount, flushPromises } from '@vue/test-utils'
import axios from "axios";
import Book from '../../../app/javascript/esm/components/book';

jest.spyOn(axios, 'get').mockResolvedValue({ data: {ip: '1.2.3.4'} })

afterEach(() => {
  jest.clearAllMocks();
});

test('renders', async () => {

  const wrapper = mount(Book)
  const book = wrapper.get('[data-test="app-message"]')
  expect(book.text()).toBe("Hello Vue! - IP: -");

  await flushPromises() // axios promise is resolved immediately
  expect(book.text()).toBe("Hello Vue! - IP: 1.2.3.4");

  const todos = wrapper.get('.todos-component')
  expect(todos.exists()).toBe(true)

  const buttonCounter = wrapper.get('.button-counter-component')
  expect(buttonCounter.exists()).toBe(true)
})
