import { mount } from '@vue/test-utils'
import ButtonCounter from '../../../app/javascript/esm/components/button_counter';

test('renders', () => {
  const wrapper = mount(ButtonCounter)
  const buttonCounter = wrapper.get('.button-counter-component')
  expect(buttonCounter.exists()).toBe(true)
})
