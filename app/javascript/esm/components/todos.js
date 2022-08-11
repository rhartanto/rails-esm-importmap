export default {
  template: `
    <div class="todos-component">
      <ol >
        <li v-for="todo in todos">
          <span :class="{ active: todo.active }">{{ todo.text }}</span>
        </li>
      </ol>    
    </div>
  `,
  data() {
    return {
      todos: [
        { text: 'Learn JavaScript', active: false },
        { text: 'Learn Vue', active: true },
        { text: 'Build something awesome', active: false },
        { text: 'Python for dummies', active: false },
      ]
    }
  },
}
