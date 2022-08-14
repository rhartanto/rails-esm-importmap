import { mount } from '@vue/test-utils'
import Todos from '../../../app/javascript/esm/components/todos';

test('renders', () => {
  const wrapper = mount(Todos)
  const todos = wrapper.get('.todos-component')
  expect(todos.exists()).toBe(true)
})
